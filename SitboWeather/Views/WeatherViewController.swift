//
//  WeatherViewController.swift
//  SitboWeather
//
//  Created by Giorgi Zautashvili on 01.07.25.
//


import MapKit
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private let viewModel = WeatherViewModel()
    private var collectionView: UICollectionView!
    private let searchBar = UISearchBar()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Hourly Forecast"
        
        setupSearchBar()
        setupCollectionView()
        
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                
                if let icon = self?.viewModel.hourlyWeather.first(where: {
                    $0.data.next1Hours?.summary?.symbolCode != nil
                })?.data.next1Hours?.summary?.symbolCode {
                    self?.view.backgroundColor = self?.viewModel.backgroundColor(for: icon)
                }
            }
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search city"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(HourlyWeatherCell.self, forCellWithReuseIdentifier: HourlyWeatherCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

extension WeatherViewController: UICollectionViewDataSource, UISearchBarDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCell.identifier, for: indexPath) as? HourlyWeatherCell else {
            return UICollectionViewCell()
        }

        let weather = viewModel.hourlyWeather[indexPath.item]
        let timeString = String(weather.time.dropFirst(11).prefix(5))
        let tempString = "\(Int(weather.data.instant.details.airTemperature))°"

        let symbolCode = weather.data.next1Hours?.summary?.symbolCode
        let icon = viewModel.systemImageName(for: symbolCode)
        
        print("🔎 SymbolCode: \(symbolCode ?? "nil") → SF Symbol: \(icon)")

        cell.configure(time: timeString, temp: tempString, iconName: icon)
        print("Symbol: \(String(describing: symbolCode)) → SF Symbol: \(icon)")

        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text else { return }
        searchBar.resignFirstResponder()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { [weak self] placemarks, error in
            if let location = placemarks?.first?.location {
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                self?.viewModel.loadWeather(for: lat, lon: lon)
            } else {
                print("❌ Location not found")
            }
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("📍 Got location: \(lat), \(lon)")
            viewModel.loadWeather(for: lat, lon: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error:", error)
        
        viewModel.loadWeather(for: 41.7151, lon: 44.8271)
    }

}
