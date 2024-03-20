import Foundation
import UIKit

class CurrentWeatherView: UIView {
    private var image: UIImage
    private var name: String
    private var info: String

    init(image: UIImage, name: String, info: String) {
        self.image = image
        self.name = name
        self.info = info
        super.init(frame: CGRect.zero)
        setupView()
    }

    override init(frame: CGRect) {
        self.image = UIImage()
        self.name = "Не завезли"
        self.info = "Не известно"
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = name
        return label
    }()

    private lazy var infoLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = info
        return label
    }()

    private lazy var imageIcon: UIImageView = {
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private func setupView() {
        addSubview(imageIcon)
        addSubview(nameLabel)
        addSubview(infoLabel)

        NSLayoutConstraint.activate([
            imageIcon.topAnchor.constraint(equalTo: topAnchor),
            imageIcon.leftAnchor.constraint(equalTo: leftAnchor),
            imageIcon.heightAnchor.constraint(equalTo: heightAnchor),
            imageIcon.widthAnchor.constraint(equalTo: heightAnchor),  
            
            nameLabel.leftAnchor.constraint(equalTo: imageIcon.rightAnchor, constant: 8),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            infoLabel.leftAnchor.constraint(equalTo: imageIcon.rightAnchor, constant: 8),
            infoLabel.rightAnchor.constraint(equalTo: rightAnchor),
            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
