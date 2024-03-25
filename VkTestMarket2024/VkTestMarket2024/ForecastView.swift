import UIKit

class ForecastView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var forecastData: [DailyWeather] = []
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        register(ForecastViewCell.self, forCellReuseIdentifier: "ForecastViewCell")
        layer.cornerRadius = 10
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastViewCell", for: indexPath) as? ForecastViewCell else {
            return UITableViewCell()
        }
        let weather = forecastData[indexPath.row]
        cell.configure(with: weather)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

class ForecastViewCell: UITableViewCell {
    
    private let dayLabel = UILabel()
    private let temperatureLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .gray
        layer.borderWidth = 5
        layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configure(with weather: DailyWeather) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(weather.dt))
        
        dayLabel.text = dateFormatter.string(from: date)
        temperatureLabel.text = "\(Int(weather.main.temp))°C"
    }
}
