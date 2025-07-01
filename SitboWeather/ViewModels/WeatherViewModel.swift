//
//  WeatherViewModel.swift
//  SitboWeather
//
//  Created by Giorgi Zautashvili on 01.07.25.
//


import Foundation

class WeatherViewModel {
    var hourlyWeather: [TimeSeries] = []
    var onUpdate: (() -> Void)?
    
    func loadWeather(for lat: Double, lon: Double) {
        WeatherService.shared.fetchWeather(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let timeseries):
                self?.hourlyWeather = Array(timeseries.prefix(24))
                DispatchQueue.main.async {
                    self?.onUpdate?()
                }
            case .failure(let error):
                print("Error fetching weather: \(error)")
            }
        }
    }
}
