//
//  WeatherModel.swift
//  SitboWeather
//
//  Created by Giorgi Zautashvili on 01.07.25.
//

import Foundation

struct WeatherResponse: Decodable {
    let properties: WeatherProperties
}

struct WeatherProperties: Decodable {
    let timeseries: [TimeSeries]
}

struct TimeSeries: Decodable {
    let time: String
    let data: WeatherData
}

struct WeatherData: Decodable {
    let instant: InstantDetails
    let next1Hours: ForecastSummary?
    
    enum CodingKeys: String, CodingKey {
        case instant
        case next1Hours = "next_1_hours"
    }
}

struct InstantDetails: Decodable {
    let details: WeatherDetails
}

struct ForecastSummary: Decodable {
    let summary: SymbolCode
}

struct SymbolCode: Decodable {
    let symbolCode: String
    
    enum CodingKeys: String, CodingKey {
        case symbolCode = "symbol_code"
    }
}

struct WeatherDetails: Decodable {
    let airTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case airTemperature = "air_temperature"
    }
}
