//
// Created by JsonLu on 2017/9/23.
// Copyright (c) 2017 JsonLu. All rights reserved.
//

import Foundation
import HandyJSON

class Weather: BasicTypes {

    var status: String?
    var weather: Array<WeatherContext>!

    required init() {
    }
}

class WeatherContext: BasicTypes {
    var city_name: String!
    var now: Now!

    required init() {
    }
}

class Now: BasicTypes {

    var text: String!
    var code: String!
    var temperature: String!

    required init() {
    }
}
