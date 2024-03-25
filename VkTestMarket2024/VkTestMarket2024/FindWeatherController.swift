//
//  FindWeatherController.swift
//  VkTestMarket2024
//
//  Created by Артемий on 19.03.2024.
//

import Foundation
import UIKit

class FindWeatherController: UIViewController {
    private var apiKey = "731e3eeefa633f697edc576abc855ea2"
    private var cityName = "Unknown"
    private lazy var userInputForSearch: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Город на английском(London например)"
        field.backgroundColor = .white
        field.addTarget(self, action: #selector(getInformation), for: .editingDidEndOnExit)
        return field
    }()
    private lazy var stackViewTemptAndWind: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var stackViewMain: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var stackViewClouldAndPrecipitation: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var temp = CurrentWeatherView(image: UIImage(named: "Thermometer") ?? UIImage(), name: "Температура", info: "Неизвестно")
    lazy var wind = CurrentWeatherView(image: UIImage(named: "Wind") ?? UIImage(), name: "Ветер", info: "Неизвестно")
    lazy var precipitation = CurrentWeatherView(image: UIImage(named: "Clould") ?? UIImage(), name: "Влажность", info: "Неизвестно")
    lazy var clould = CurrentWeatherView(image: UIImage(named: "Clould") ?? UIImage(), name: "Облачность", info: "Неизвестно")
    lazy var city = CurrentWeatherView(image: UIImage(named: "City") ?? UIImage(), name: "Город поиска", info: "Неизвестно")
    private lazy var forecastView = ForecastView()
    private func addElementsToMainStackView() {
        stackViewTemptAndWind.addArrangedSubview(temp)
        stackViewTemptAndWind.addArrangedSubview(wind)
        stackViewClouldAndPrecipitation.addArrangedSubview(clould)
        stackViewClouldAndPrecipitation.addArrangedSubview(precipitation)
        stackViewMain.addArrangedSubview(stackViewTemptAndWind)
        stackViewMain.addArrangedSubview(stackViewClouldAndPrecipitation)
        stackViewMain.addArrangedSubview(city)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        view.addSubview(userInputForSearch)
        view.addSubview(stackViewMain)
        view.addSubview(forecastView)
        addElementsToMainStackView()
        NSLayoutConstraint.activate([
            userInputForSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userInputForSearch.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            userInputForSearch.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            userInputForSearch.heightAnchor.constraint(equalToConstant: 50),
            
            stackViewMain.topAnchor.constraint(equalTo: userInputForSearch.bottomAnchor, constant: 10),
            stackViewMain.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            stackViewMain.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            stackViewMain.heightAnchor.constraint(equalToConstant: 150),
            
            forecastView.topAnchor.constraint(equalTo: stackViewMain.bottomAnchor, constant: 20),
            forecastView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            forecastView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            forecastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
            
        ])
        // Do any additional setup after loading the view.
    }
    func updateWeatherUI(temperature: Double, wind: Wind, clouds: Clouds, humid: Double){
        temp.infoLabel.text = String("\(temperature) in C")
        self.wind.infoLabel.text = String("\(wind.speed) in km/h")
        self.clould.infoLabel.text = String("\(clouds.all)%")
        self.precipitation.infoLabel.text = String("\(humid)%")
        self.city.infoLabel.text = cityName
    }
    func updateWeatherForecast(daily: [DailyWeather]){
        forecastView.forecastData = daily
        forecastView.reloadData()
    }
    @objc
    private func getInformation(){
        cityName = userInputForSearch.text ?? ""
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric"
                guard let url = URL(string: urlStr) else {
                    print("Invalid URL")
                    return
                }
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        print("Error: Invalid response")
                        return
                    }
                    guard let data = data else {
                        print("Error: No data")
                        return
                    }
                    do {
                        let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                        DispatchQueue.main.async {
                            self?.updateWeatherUI(temperature: decodedData.main.temp, wind: decodedData.wind, clouds: decodedData.clouds, humid: decodedData.main.humidity)
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }.resume()
        let forecastUrlStr = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apiKey)&units=metric"
            guard let forecastUrl = URL(string: forecastUrlStr) else {
                print("Invalid URL for forecast")
                return
            }

            URLSession.shared.dataTask(with: forecastUrl) { [weak self] data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Error: Invalid response for forecast")
                    return
                }
                guard let data = data else {
                    print("Error: No data for forecast")
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(ForecastResponse.self, from: data)
                    DispatchQueue.main.async {
                        // Обновляем табличные данные с прогнозом погоды
                        self?.updateWeatherForecast(daily: decodedData.list)
                    }
                } catch {
                    print("Error decoding forecast data: \(error.localizedDescription)")
                }
            }.resume()
    }
    

}

