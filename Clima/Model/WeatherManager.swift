//
//  WeatherManager.swift
//  Clima
//
//  Created by Joy Massey on 23/01/21.
// 
//

import Foundation
import CoreLocation
struct WeatherManager {
    var delegate:WeatherManagerDelegate?
let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=803352dd31c4fde6108ea4b4f1e5bdab&units=metric"
    func featchWeather(cityName:String)
    {
        let urlString = "\(weatherURL)&q=\(cityName)"
       
        performRequest(with: urlString)
    }

    func performRequest(with urlString:String)
    {
        //create Url
        if let url = URL(string: urlString){
        
        //create sesion
        let session = URLSession(configuration: .default)
        
            let task =  session.dataTask(with: url) {  (data:Data?,urlresponse:URLResponse?,error:Error?) in
        if error != nil
        {
            delegate?.didFailWithError(error: error!)
            return
        }
        if let safeData = data{
            if let weather =  self.parseJSON(safeData)
          {
                delegate?.didUpdateWeather(self, weather: weather)
          }
        }
    }
            
            task.resume()
        }
    }
    func parseJSON(_ weatherData:Data)->WeatherModel?
    {
       let decoder = JSONDecoder()
        do{
    let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
    
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temperature = decodedData.main.temp
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temperature)
            print(weather.conditionName)
           // print(weather.temperatureString)
            return weather
        }
        catch{delegate?.didFailWithError(error: error)
            return nil}
      
    }
    func fetchWeather(lat:CLLocationDegrees,lon:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)    }
}
