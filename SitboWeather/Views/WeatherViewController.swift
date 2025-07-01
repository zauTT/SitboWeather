//
//  WeatherViewController.swift
//  SitboWeather
//
//  Created by Giorgi Zautashvili on 01.07.25.
//


import UIKit

class WeatherViewController: UIViewController {
    
    private let viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Weather Test"
        
        viewModel.onUpdate = { [weak self] in
            print("Weather data loaded")
            for hour in self?.viewModel.hourlyWeather ?? [] {
                let time = hour.time
                let temp = hour.data.instant.details.airTemperature
                let icon = hour.data.next1Hours?.summary.symbolCode ?? "N/A"
                print("Time: \(time), Temp: \(temp)°C, Icon: \(icon)")
            }
        }
        
        viewModel.loadWeather(for: 41.7151, lon: 44.8271)
    }
    
}
