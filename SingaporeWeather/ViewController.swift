//
//  ViewController.swift
//  SingaporeWeather
//
//  Created by Ammar Rusydi on 11/01/2018.
//  Copyright © 2018 Ammar. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift

// Create global variable for realm object
var RealmObjectData : Results<RealmObject>!
var realm = try! Realm()

class ViewController: UIViewController {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UINavigationItem!
    @IBOutlet weak var tblForecast: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var weatherObject : WeatherObject!
    var weatherData : [getWeather] = []
    var isRefresh : Bool = false
    
    // declare weatherData object
    var city : String = ""
    var country : String = ""
    var date : String = ""
    var text : String = ""
    var temp : String = ""
    var forecast : [Forecast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RealmObjectData = realm.objects(RealmObject.self)
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        self.scrollView.addSubview(self.refreshControl)
        
        // Check internet connection availability
        checkInternetConnection()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadJobOrder(_:)), name: NSNotification.Name(rawValue: "DONE_GET_DATA"), object: nil)
    }
    
    @objc
    fileprivate func loadJobOrder(_ notification:Notification) {
        
        weatherData = weatherObject.arrayWeatherData
        
        for index in weatherData {
            city = index.city!
            country = index.country!
            date = index.date!
            text = index.text!
            temp = index.temp!
            forecast = index.forecast!
        }
        
        saveToLocal()
        setUI()
    }
    
    // Check internet connection availability
    func checkInternetConnection() {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show(withStatus:"Please Wait...")
            weatherObject = WeatherObject.init()
        }else{
            print("Internet Connection NOT Available!")
            let alert = UIAlertController(title: "Cannot update weather", message: "No Internet connection available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default , handler:{ action in
                self.readFromLocal()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setUI() {
        self.dateLbl.text = date
        self.tempLbl.text = temp
        self.descriptionLbl.text = text
        self.titleLbl.title = "\(city), \(country)"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font : UIFont.init(name: "HelveticaNeue-Medium", size: 17)!]
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        
        tblForecast.dataSource = self
        tblForecast.delegate = self
        tblForecast.reloadData()
        
        SVProgressHUD.dismiss()
        isRefresh ? refreshControl.endRefreshing() : print("not refresh")
        isRefresh = false //reset isRefresh value
    }
    
    func saveToLocal() {
        let singaporeWeather = RealmObject()
        
        singaporeWeather.city = city
        singaporeWeather.country = country
        singaporeWeather.temp = temp
        singaporeWeather.text = text
        singaporeWeather.date = date

        for data in forecast {
            let singaporeForecast = RealmForecast()
            
            singaporeForecast.date = data.date
            singaporeForecast.high = data.high
            singaporeForecast.low = data.low
            singaporeForecast.text = data.text
            singaporeForecast.day = data.day
            
            singaporeWeather.forecast.append(singaporeForecast)
        }
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(singaporeWeather)
        }
    }
    
    func readFromLocal() {
        var forecastTest = List<RealmForecast>()
        forecast = []  //reset forecast value
        
        for singaporeWeather in RealmObjectData {
            city = singaporeWeather.city!
            country = singaporeWeather.country!
            date = singaporeWeather.date!
            text = singaporeWeather.text!
            temp = singaporeWeather.temp!
            
            forecastTest = singaporeWeather.forecast
        }
        
        for data in forecastTest {
            var forecastData = Forecast()
            
            forecastData.date = data.date!
            forecastData.high = data.high!
            forecastData.low = data.low!
            forecastData.text = data.text!
            forecastData.day = data.day!
            
            forecast.append(forecastData)
        }
        setUI()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        refreshControl.attributedTitle = NSAttributedString(string : "Fetching Weather Data ...")
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        isRefresh = true
        checkInternetConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        self.dateLbl.text = date
        self.tempLbl.text = temp
        self.descriptionLbl.text = text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ForecastTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "forecastTblCell") as! ForecastTableViewCell
        
        let item : Forecast = forecast[indexPath.row]
        
        cell.dateLbl.text = "\(item.date ?? ""), \(item.day ?? "")"
        cell.tempRangeLbl.text = "\(item.low ?? "") - \(item.high ?? "")"
        cell.descriptionLbl.text = item.text

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
}
