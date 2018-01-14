//
//  RealmObject.swift
//  SingaporeWeather
//
//  Created by Ammar Rusydi on 13/01/2018.
//  Copyright © 2018 Ammar. All rights reserved.
//

import Foundation
import RealmSwift

class RealmObject : Object {
    @objc dynamic var city : String? = ""
    @objc dynamic var country : String? = ""
    @objc dynamic var date : String? = ""
    @objc dynamic var temp : String? = ""
    @objc dynamic var text : String? = ""
    let forecast = List<RealmForecast>()
}

class RealmForecast : Object {
    @objc dynamic var date : String? = ""
    @objc dynamic var low : String? = ""
    @objc dynamic var high : String? = ""
    @objc dynamic var text : String? = ""
    @objc dynamic var day : String? = ""
}
