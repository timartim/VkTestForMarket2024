import UIKit

class WeatherAtUsersLocationController: UIViewController {
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
    private func addElemenetsToTempAndWindStackView() {
        let temp = CurrentWeatherView(image: UIImage(named: "Thermometer") ?? UIImage(), name: "Температура", info: "-26 градусов")
        let wind = CurrentWeatherView(image: UIImage(named: "Wind") ?? UIImage(), name: "Ветер", info: "2 м/с")
        let precipitation = CurrentWeatherView(image: UIImage(named: "Clould") ?? UIImage(), name: "Осадки", info: "2мм")
        let clould = CurrentWeatherView(image: UIImage(named: "Clould") ?? UIImage(), name: "Облачность", info: "Низкая")
        stackViewTemptAndWind.addArrangedSubview(temp)
        stackViewTemptAndWind.addArrangedSubview(wind)
        stackViewClouldAndPrecipitation.addArrangedSubview(clould)
        stackViewClouldAndPrecipitation.addArrangedSubview(precipitation)
        stackViewMain.addArrangedSubview(stackViewTemptAndWind)
        stackViewMain.addArrangedSubview(stackViewClouldAndPrecipitation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        view.addSubview(controllerLabel)
        view.addSubview(stackViewMain)
        addElemenetsToTempAndWindStackView()
        NSLayoutConstraint.activate([
            controllerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            controllerLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            controllerLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            controllerLabel.heightAnchor.constraint(equalToConstant: 50),
            
            stackViewMain.topAnchor.constraint(equalTo: controllerLabel.bottomAnchor, constant: 10),
            stackViewMain.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            stackViewMain.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            stackViewMain.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
