//
//  ServerRequest.swift
//  SingaporeWeather
//
//  Created by Ammar Rusydi on 12/01/2018.
//  Copyright © 2018 Ammar. All rights reserved.
//

import Foundation

public class ServerRequest {
    
    private class var prefix: String {
        return "https://query.yahooapis.com/v1/public/yql?q="
    }
    
    private class var location: String {
        return "select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22singapore%2C%20sg%22)"
    }
    
    private class var suffix: String {
        return "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=";
    }
    
    public class func query() -> String
    {
        return "\(prefix)\(location)\(suffix)"
    }
}
