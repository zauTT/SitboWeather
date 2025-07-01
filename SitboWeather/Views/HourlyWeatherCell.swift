//
//  HourlyWeatherCell.swift
//  SitboWeather
//
//  Created by Giorgi Zautashvili on 01.07.25.
//


import UIKit

class HourlyWeatherCell: UICollectionViewCell {
    static let identifier = "HourlyWeatherCell"
    
    let timeLabel = UILabel()
    let iconImageView = UIImageView()
    let tempLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        timeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        timeLabel.textAlignment = .center
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .label
        
        tempLabel.font = .systemFont(ofSize: 14, weight: .medium)
        tempLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func configure(time: String, temp: String, iconName: String) {
        timeLabel.text = time
        tempLabel.text = temp
        
        iconImageView.image = UIImage(systemName: "cloud.sun.fill")
    }
    
}
