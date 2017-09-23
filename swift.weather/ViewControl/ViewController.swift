//
//  ViewController.swift
//  swift.weather
//
//  Created by JsonLu on 2017/9/23.
//  Copyright © 2017年 JsonLu. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManage = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManage.delegate = self

        locationManage.requestAlwaysAuthorization()
        print("开始定位")
        locationManage.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func ios8() -> Bool {
        print(UIDevice.current.systemVersion)
        return UIDevice.current.systemVersion == "8.0"
    }

    var S = false

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1] as CLLocation

        if location.horizontalAccuracy > 0 && !S {
            S = true
            manager.stopUpdatingLocation()
            updateWeatherInfo(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)

        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temp: UILabel!

    func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let url = "http://openweathermap.org/data/2.5/weather"
//        let appid = "b1b15e88fa797225412429c1c50c122a1" as Any
        let params = ["lat": latitude, "lon": longitude]

        let url = "http://weixin.jirengu.com/weather"
        let netManage = NetworkManager.shared
        netManage.request(requestType: HTTPMethod.GET, url: url, parameters: params, resultBlock: { (res: [String: Any]?, err: Error?) -> () in
            if res != nil {
                if let object = Weather.deserialize(from: res) {
                    print(object.toJSONString()!)
                    let weather: WeatherContext = object.weather[0]
                    let city_name = weather.city_name
                    let now: Now = weather.now
                    let temperature: String = now.temperature
//
                    self.location.text = city_name
                    self.temp.text = now.text + "," + temperature + "℃"
                }
            }
        })

    }


}

