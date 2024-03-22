import UIKit
import CoreLocation


class WeatherAtUsersLocationController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var apiKey = "731e3eeefa633f697edc576abc855ea2"
    var currentLatitude: Double?
    var currentLongitude: Double?

    private lazy var controllerLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Узнайте погоду в своей локации"
        label.textAlignment = .center
        return label
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
    private lazy var getWeatherInformationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Узнать погоду", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .black
        
        button.addTarget(self, action: #selector(getWeatherInformationFromApi), for: .touchUpInside)
        return button
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
    lazy var temp = CurrentWeatherView(image: UIImage(named: "Thermometer") ?? UIImage(), name: "Температура", info: "-26 градусов")
    lazy var wind = CurrentWeatherView(image: UIImage(named: "Wind") ?? UIImage(), name: "Ветер", info: "2 м/с")
    lazy var precipitation = CurrentWeatherView(image: UIImage(named: "Clould") ?? UIImage(), name: "Влажность", info: "2мм")
    lazy var clould = CurrentWeatherView(image: UIImage(named: "Clould") ?? UIImage(), name: "Облачность", info: "Низкая")
    private lazy var forecastView = ForecastView()
    private func addElementsToMainStackView() {
        stackViewTemptAndWind.addArrangedSubview(temp)
        stackViewTemptAndWind.addArrangedSubview(wind)
        stackViewClouldAndPrecipitation.addArrangedSubview(clould)
        stackViewClouldAndPrecipitation.addArrangedSubview(precipitation)
        stackViewMain.addArrangedSubview(getWeatherInformationButton)
        stackViewMain.addArrangedSubview(stackViewTemptAndWind)
        stackViewMain.addArrangedSubview(stackViewClouldAndPrecipitation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        view.backgroundColor = .darkGray
        view.addSubview(controllerLabel)
        view.addSubview(stackViewMain)
        view.addSubview(forecastView)
        addElementsToMainStackView()
        NSLayoutConstraint.activate([
            controllerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            controllerLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            controllerLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            controllerLabel.heightAnchor.constraint(equalToConstant: 50),
            
            stackViewMain.topAnchor.constraint(equalTo: controllerLabel.bottomAnchor, constant: 10),
            stackViewMain.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            stackViewMain.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            stackViewMain.heightAnchor.constraint(equalToConstant: 150),
            
            forecastView.topAnchor.constraint(equalTo: stackViewMain.bottomAnchor, constant: 20),
            forecastView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            forecastView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            forecastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
            
        ])
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
                    currentLatitude = location.coordinate.latitude
                    currentLongitude = location.coordinate.longitude

                }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    func updateWeatherUI(temperature: Double, wind: Wind, clouds: Clouds, humid: Double){
        temp.infoLabel.text = String("\(temperature) in C")
        self.wind.infoLabel.text = String("\(wind.speed) in km/h")
        self.clould.infoLabel.text = String("\(clouds.all)%")
        self.precipitation.infoLabel.text = String("\(humid)%")
    }
    func updateWeatherForecast(daily: [DailyWeather]){
        forecastView.forecastData = daily
        forecastView.reloadData()
    }
    @objc
    private func getWeatherInformationFromApi() {
        guard let lat = currentLatitude, let lon = currentLongitude else {
            print("Location is not available")
            return
        }
        
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
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
        let forecastUrlStr = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=\(apiKey)&units=metric"
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
struct WeatherResponse: Decodable {
    let main: Main
    let wind: Wind
    let clouds: Clouds
}
struct ForecastResponse: Decodable{
    let list: [DailyWeather]
}
struct DailyWeather: Decodable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}
struct Weather: Decodable {
    let description: String
}
struct Temperature: Decodable {
    let day: Double
}
struct Main: Decodable {
    let temp: Double
    let humidity: Double
}

struct Wind: Decodable {
    let speed: Double
    let deg: Double?
}

struct Clouds: Decodable {
    let all: Int
}

