//
//  ViewController.swift
//  Clima
//
//  Created by Joy Massey on 23/01/21.
//  
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController,UITextFieldDelegate,WeatherManagerDelegate {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""
        {
            return true
        }
        else
        {
            textField.placeholder = "Type Something"
            return false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text
        {
            weatherManager.featchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func didUpdateWeather(_ weatherManager:WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
       
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}
extension WeatherViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last
        {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            print(lat,long)
            weatherManager.fetchWeather(lat: lat, lon: long)
        }
        print("gotLocation")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("error:: \(error.localizedDescription)")
      }

      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          if status == .authorizedWhenInUse {
              locationManager.requestLocation()
          }
      }

}
