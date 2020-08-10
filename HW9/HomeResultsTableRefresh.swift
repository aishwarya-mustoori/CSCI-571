//
//  HomeResultsTableRefresh.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/19/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//
import Alamofire
import SwiftyJSON
import UIKit
import CoreLocation
class HomeResultsTableRefresh: UITableViewController,CLLocationManagerDelegate {
    var location = CLLocationManager()
    var homeResults: [JSON]=[];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(tableView != nil){
            
            location.desiredAccuracy = kCLLocationAccuracyHundredMeters
            location.startUpdatingLocation()
            location.requestWhenInUseAuthorization()
            location.delegate = self;
            
            
            tableView.isHidden = false
            tableView.delegate = self
            tableView.dataSource = self
            AF.request("https://amustoori.azurewebsites.net/IOSsectionsg?section=home").responseJSON { (responseData) -> Void in
                if((responseData.data) != nil) {
                    print(responseData.data)
                    let swiftyJsonVar = JSON(responseData.data)
                    print(swiftyJsonVar)
                    self.homeResults=[]
                    for values in swiftyJsonVar
                    {
                        print(values.1)
                        
                        self.homeResults.append(values.1)
                    }
                    self.tableView.reloadData()
                    
                    
                    
                }
            }
            self.tableView.reloadData()
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        print("yahooooo")
        print(lastLocation)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
            if error == nil {
                if let firstLocation = placemarks?[0],
                    let cityName = firstLocation.locality { // get the city name
                    self?.location.stopUpdatingLocation()
                    print("why this col")
                    firstLocation.locality
                }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.homeResults.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UIHomeTableViewCell",for: indexPath) as! UIHomeTableViewCell
        
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        if(homeResults != nil && homeResults[indexPath.row] != nil && homeResults[indexPath.row] ["fields"] != nil && homeResults[indexPath.row]["fields"]["thumbnail"] != nil){
            print(homeResults[indexPath.row]["fields"]["thumbnail"])
            var url = NSURL(string :homeResults[indexPath.row]["fields"]["thumbnail"].string!)
            let imgData = NSData.init(contentsOf: url! as URL)
            cell.homeImage.image = UIImage(data :imgData! as Data)
        }else{
            var url = NSURL(string :"https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png")
            let imgData = NSData.init(contentsOf: url! as URL)
            cell.homeImage.image = UIImage(data :imgData! as Data)
        }
        if(homeResults != nil && homeResults[indexPath.row] != nil && homeResults[indexPath.row]["webPublicationDate"] != nil){
            print(homeResults[indexPath.row]["webPublicationDate"])
            let date = homeResults[indexPath.row]["webPublicationDate"].string!
            
            let dateFormatter = ISO8601DateFormatter()
            let webDate = dateFormatter.date(from:date)!
            let today = Date()
            let relativeDtf = RelativeDateTimeFormatter()
            var diff = relativeDtf.localizedString(for: webDate , relativeTo: today)
            if(diff.contains("years")){
                diff = diff.replacingOccurrences(of: " years" , with: "y")
            }
            if(diff.contains("year")){
                diff = diff.replacingOccurrences(of: " year" , with: "y")
            }
            if(diff.contains("hours")){
                diff = diff.replacingOccurrences(of: " hours" , with: "h")
            }
            if(diff.contains("hour")){
                diff = diff.replacingOccurrences(of: " hour" , with: "h")
            }
            if(diff.contains("minutes")){
                diff = diff.replacingOccurrences(of: " minutes" , with: "m")
            }
            if(diff.contains("minute")){
                diff = diff.replacingOccurrences(of: " minute" , with: "m")
            }
            if(diff.contains("seconds")){
                diff = diff.replacingOccurrences(of: " seconds" , with: "s")
            }
            if(diff.contains("second")){
                diff = diff.replacingOccurrences(of: " second" , with: "s")
            }
            print(diff)
            cell.homeTime.text = diff
            
        }
        if(homeResults != nil && homeResults[indexPath.row] != nil && homeResults[indexPath.row]["sectionId"] != nil){
            var section = homeResults[indexPath.row]["sectionId"].string!
            cell.homeSection.text = "| " + section
        }
        if(homeResults != nil && homeResults[indexPath.row] != nil && homeResults[indexPath.row]["webTitle"] != nil){
            print(homeResults[indexPath.row]["webTitle"])
            if(cell.homeTitle != nil){
                cell.homeTitle.text = homeResults[indexPath.row]["webTitle"].string!
                
            }}
        
        //print(cell)
        return cell;
        
    }
    
    
    
}

