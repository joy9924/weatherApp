//
//  WeatherManagerDelegate.swift
//  Clima
//
//  Created by Joy Massey on 26/01/21.
// 
//

import Foundation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailWithError(error:Error)
    

}
