//
//  WeatherUI.swift
//  VkTestMarket2024
//
//  Created by Артемий on 25.03.2024.
//

import Foundation
import UIKit
class WeatherUI: UIView{
    private var currentCity: String?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private lazy var stackViewMain: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    lazy var city = CurrentWeatherView(image: UIImage(named: "City") ?? UIImage(), name: "Ваш город:", info: "Неизвестно")
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
    func updateWeatherUI(temperature: Double, wind: Wind, clouds: Clouds, humid: Double){
        temp.infoLabel.text = String("\(temperature) in C")
        self.wind.infoLabel.text = String("\(wind.speed) in km/h")
        self.clould.infoLabel.text = String("\(clouds.all)%")
        self.precipitation.infoLabel.text = String("\(humid)%")
        self.city.infoLabel.text = currentCity
    }
    func updateWeatherForecast(daily: [DailyWeather]){
        forecastView.forecastData = daily
        forecastView.reloadData()
    }
    func setupView(){
        backgroundColor = .darkGray
        addSubview(stackViewMain)
        addSubview(forecastView)
        addElementsToMainStackView()
        NSLayoutConstraint.activate([
            stackViewMain.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackViewMain.leftAnchor.constraint(equalTo: leftAnchor),
            stackViewMain.rightAnchor.constraint(equalTo: rightAnchor),
            stackViewMain.heightAnchor.constraint(equalToConstant: 200),
            
            forecastView.topAnchor.constraint(equalTo: stackViewMain.bottomAnchor, constant: 20),
            forecastView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            forecastView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            forecastView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20)
            
        ])
    }
}
