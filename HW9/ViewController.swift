//
//  ViewController.swift
//  MUSTOORII
//
//  Created by Aishwarya Mustoori on 4/15/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SwiftSpinner
import Toast_Swift
class ViewController: UIViewController,UITableViewDataSource,UISearchBarDelegate,UITableViewDelegate,CLLocationManagerDelegate,UISearchControllerDelegate {
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var homeResultsTable: UITableView!
    @IBOutlet weak var Home: UINavigationItem!
    
    @IBOutlet weak var autoSuggestTable: UITableView!
    var weatherResults  :Dictionary<String,String> = [:]
    var homeResults: [JSON]=[];
    var autoSuggestResults : [String]=[]
    var searchController : UISearchController!
    var autoSearchText : String = ""
    var mainResults :[JSON]=[]
    var selectedHomeResults :JSON = []
    var location = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search keyword.."
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        navigationItem.searchController = searchController
        
        
        navigationItem.hidesSearchBarWhenScrolling = true
        
        
        if(autoSuggestTable != nil ){
            autoSuggestTable.isHidden = true
            
            autoSuggestTable.delegate = self
            autoSuggestTable.dataSource = self
            
            
            
        }
        if(homeResultsTable != nil){
            SwiftSpinner.show("Loading Home Page..")
            homeResultsTable.delegate = self
            homeResultsTable.dataSource = self
            location.desiredAccuracy = kCLLocationAccuracyHundredMeters
            location.startUpdatingLocation()
            location.requestWhenInUseAuthorization()
            location.delegate = self;
            
            
            refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
            homeResultsTable.addSubview(refreshControl)
            
            
            
            AF.request("https://amustoori.azurewebsites.net/IOSsectionsg?section=home").responseJSON { (responseData) -> Void in
                if((responseData.data) != nil) {
                    
                    let swiftyJsonVar = JSON(responseData.data)
                    
                    self.homeResults=[]
                    for values in swiftyJsonVar
                    {
                        
                        self.homeResults.append(values.1)
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        // Background Thread
                        
                        DispatchQueue.main.async {
                            // Run UI Updates
                            self.homeResultsTable.reloadData()
                            
                            SwiftSpinner.hide()
                        }
                    }
                    
                    
                    
                    
                }
            }
            
        }
        
        
        
    }
    
    @objc func refresh() {
        
       
        location.startUpdatingLocation()
        AF.request("https://amustoori.azurewebsites.net/IOSsectionsg?section=home").responseJSON { (responseData) -> Void in
            if((responseData.data) != nil) {
                
                let swiftyJsonVar = JSON(responseData.data)
                
                self.homeResults=[]
                for values in swiftyJsonVar
                {
                    
                    self.homeResults.append(values.1)
                }
                
                DispatchQueue.global(qos: .background).async {
                    
                    // Background Thread
                    
                    DispatchQueue.main.async {
                        // Run UI Updates
                        self.homeResultsTable.reloadData()
                        
                   
                    }
                }
                
                
                
                
            }
        }
        
        refreshControl.endRefreshing()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
            if error == nil {
                if let firstLocation = placemarks?[0],
                    let cityName = firstLocation.locality { // get the city name
                    self?.location.stopUpdatingLocation()
                    
                    
                    AF.request("https://api.openweathermap.org/data/2.5/weather",parameters : ["q":firstLocation.locality!,"units":"metric","appid": "29457bb97e8713bdfcd1e306066c693e"]).responseJSON { (responseData) -> Void in
                        
                        
                        if(responseData.data != nil){
                            let swiftyJsonVar = JSON(responseData.data)
                            
                           
                            var temp = swiftyJsonVar["main"]["temp"].float!
                            var string = String((Int(round(temp)) )) + "°C"
                            
                            self?.weatherResults = [
                                "weatherCity" : firstLocation.locality!,
                                "weatherPlace" :firstLocation.administrativeArea!,
                                "weatherTemp" : string as String,
                                "weather" : swiftyJsonVar["weather"][0]["main"].string!
                            ]
                            self?.homeResultsTable.reloadData()
                        }
                    }
                    
                    
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case autoSuggestTable :
            return self.autoSuggestResults.count
        case homeResultsTable :
            return self.homeResults.count + 1
            
        default :
            print("wrong")
        }
        return 0
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.autoSuggestTable.isHidden = true
        searchBar.text = ""
        self.homeResultsTable.isHidden = false
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.count > 2){
            self.autoSuggestResults=[]
            self.homeResultsTable.isHidden = true
            
            let headers: HTTPHeaders = [
                "Ocp-Apim-Subscription-Key": "b6e4106b94bf492881a1c5acb58445d6",
                "Accept": "application/json"
            ]
            
            AF.request("https://api.cognitive.microsoft.com/bing/v7.0/suggestions",parameters: ["q" : searchText], headers: headers).responseJSON { (responseData) -> Void in
                if((responseData.data) != nil) {
                    let swiftyJsonVar = JSON(responseData.data)
                    for values in swiftyJsonVar["suggestionGroups"][0]["searchSuggestions"]
                    {
                        
                        self.autoSuggestResults.append(values.1["displayText"].stringValue)
                        self.autoSuggestTable.reloadData()
                    }
                }
                self.autoSuggestTable.isHidden = false
                self.autoSuggestTable.reloadData()
            }
        }else{
            autoSuggestTable.isHidden = true
            homeResultsTable.isHidden = false
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1 = UITableViewCell()
        switch tableView {
        case homeResultsTable :
            if(indexPath.row != 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "UIHomeTableViewCell",for: indexPath) as! UIHomeTableViewCell
                cell.awakeFromNib()
                cell.layer.removeAllAnimations()
                cell.contentView.layer.borderWidth = 0.6
                cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
                       cell.contentView.layer.cornerRadius = 12
                       cell.contentView.layer.masksToBounds = true
                
                if(homeResults != nil && homeResults[indexPath.row-1] != nil && homeResults[indexPath.row-1] ["fields"] != nil && homeResults[indexPath.row-1]["fields"]["thumbnail"] != nil &&  !homeResults[indexPath.row-1]["fields"]["thumbnail"].string!.contains("not present") ){
                    
                    var url = NSURL(string :homeResults[indexPath.row-1]["fields"]["thumbnail"].string!)
                    
                    let imgData = NSData.init(contentsOf: url! as URL)
                    cell.homeImage.image = UIImage(data :imgData! as Data)
                }else{
                    
                    cell.homeImage.image =  UIImage(named : "default-guardian")
                }
                if(homeResults != nil && homeResults[indexPath.row-1] != nil && homeResults[indexPath.row-1]["webPublicationDate"] != nil){
                    
                    let date = homeResults[indexPath.row-1]["webPublicationDate"].string!
                    
                    let dateFormatter = ISO8601DateFormatter()
                    let webDate = dateFormatter.date(from:date)!
                    let today = Date()
                    var diff = ""
                    let dayHourMinuteSecond: Set<Calendar.Component> = [.hour, .minute, .second]
                    let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: webDate, to: today)
                    if(difference.hour! > 0 ){
                        diff = String(difference.hour!) + "h ago"
                    }
                    else if(difference.minute! > 0) {
                        diff = String(difference.minute!) + "m ago"
                    }else if(difference.second! > 0) {
                        diff = String(difference.second!) + "s ago"
                    }
                    
                    cell.homeTime.text = diff
                    
                }
                if(homeResults != nil && homeResults[indexPath.row-1] != nil && homeResults[indexPath.row-1]["sectionName"] != nil){
                    var section = homeResults[indexPath.row-1]["sectionName"].string!
                    cell.homeSection.text = "| " + section
                }
                if(homeResults != nil && homeResults[indexPath.row-1] != nil && homeResults[indexPath.row-1]["webTitle"] != nil){
                    
                    if(cell.homeTitle != nil){
                        cell.homeTitle.text = homeResults[indexPath.row-1]["webTitle"].string!
                        
                    }}
                var defaults = UserDefaults.standard
                
                defaults.synchronize()
                var data = defaults.array(forKey: "bookmarkData")
                var addOrDelete = false
                if(data != nil){
                    
                    for datas in JSON(data!) {
                        
                        if( datas.1.count != 0  && datas.1["id"].string!  == self.homeResults[indexPath.row-1]["id"].string! ){
                            addOrDelete = true
                            break;
                        }
                    }
                }
                
                if(addOrDelete)
                {
                    cell.bookmark.setImage(UIImage(systemName: "bookmark.fill"), for: UIControl.State.normal)
                    
                }else{
                    
                    cell.bookmark.setImage(UIImage(systemName: "bookmark"), for: UIControl.State.normal)
                    
                }
                
                
                cell.bookmark.tag = indexPath.row
                cell.bookmark.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
                
                return cell;
            }else{
                if(weatherResults.count > 0){
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "weather",for: indexPath) as! UIWeather
                    
                    
                    cell.weather.text = weatherResults["weather"]!
                    cell.weatherCity.text = weatherResults["weatherCity"]!
                    cell.weatherTemp.text = weatherResults["weatherTemp"]!
                    cell.weatherPlace.text =  weatherResults["weatherPlace"]!
                    
                    if(weatherResults["weather"]!.contains("Clouds")){
                        cell.weatherImage.image = UIImage(named : "cloudy_weather")
                    }
                    else if(weatherResults["weather"]!.contains("Clear")){
                        cell.weatherImage.image = UIImage(named : "clear_weather")
                    }
                    else if(weatherResults["weather"]!.contains("Snow")){
                        cell.weatherImage.image = UIImage(named : "snowy_weather")
                    }
                    else if(weatherResults["weather"]!.contains("Rain")){
                        cell.weatherImage.image = UIImage(named : "rainy_weather")
                    }
                        
                    else if(weatherResults["weather"]!.contains("Thunderstorm") ){
                        cell.weatherImage.image = UIImage(named : "thunder_weather")
                    }else{
                        cell.weatherImage.image = UIImage(named : "sunny_weather")
                    }
                    
                    
                    return cell
                }
            }
        case autoSuggestTable :
            var cell = UITableViewCell()
            cell = autoSuggestTable.dequeueReusableCell(withIdentifier: "auto",for: indexPath)
            cell.textLabel?.text = autoSuggestResults[indexPath.row]
            return cell;
            
        default:
            print("wrong table")
        }
        
        
        return cell1;
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case autoSuggestTable :
            if( self.autoSuggestResults.count != 0 ){
                autoSearchText = self.autoSuggestResults[indexPath.row]
            }
            
            
            if( Home != nil && Home.searchController != nil && Home.searchController?.searchBar != nil && Home.searchController?.searchBar.text != nil ){
                Home.searchController?.searchBar.text = autoSearchText
            }
            self.autoSuggestTable.isHidden = true
            self.homeResultsTable.isHidden = false
            performSegue(withIdentifier: "searchResults", sender: self)
            
        case homeResultsTable:
            if(indexPath.row > 0 ){
                selectedHomeResults = self.homeResults[indexPath.row-1]
                performSegue(withIdentifier: "detailedArticle", sender: self)
            }
        default :
            
            print("wrong")
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailedArticle"){
            
            var vc = segue.destination as! HomeResultsDetailedArticle
            vc.id = selectedHomeResults["id"].string!
        }
        if(segue.identifier == "searchResults"){
            
            var vc = segue.destination as! SearchResultsView
            vc.searchText = self.autoSearchText
            
        }
    }
    
    @objc func buttonClicked(sender:UIButton) {
        
        let buttonRow = sender.tag-1
        let defaults = UserDefaults.standard
        var data = defaults.array(forKey: "bookmarkData")
        

        if(data != nil )
        {
            
            var url="";
            if(self.homeResults[buttonRow]["field"] != nil && self.homeResults[buttonRow]["fields"]["thumbnail"] != nil ){
                url = homeResults[buttonRow]["fields"]["thumbnail"].string!
            }
            var data1  = [
                "id" : self.homeResults[buttonRow]["id"].string!,
                "image" :url,
                "sectionId" : self.homeResults[buttonRow]["sectionName"].string!,
                "date": self.homeResults[buttonRow]["webPublicationDate"].string!,
                "webTitle": self.homeResults[buttonRow]["webTitle"].string!,
                "webUrl" : self.homeResults[buttonRow]["webUrl"].string!,
                
            ]
            var deletedData = [[]];
            var addOrDelete = false
            var index = 0
            for datas in JSON(data!) {
                
                if(datas.1.count != 0 && datas.1["id"].string!  == self.homeResults[buttonRow]["id"].string! ){
                    addOrDelete = true
                    break;
                }else{
                    index = index + 1
                }
            }
            
            if(addOrDelete)
            {
                self.view.makeToast("Article Removed from Bookmarks", duration: 2.0)
                data!.remove(at: index)
                
                
            }else{
                data!.append(data1)
                self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                
                
            }
            
            defaults.set(data, forKey: "bookmarkData")
            defaults.synchronize()
          
            let delay = 0.4
                      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                          self.homeResultsTable.performBatchUpdates({
                             self.homeResultsTable.reloadData()
                          })
                      }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let twitter = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter"), identifier: nil) { action in
                let textString = self.homeResults[indexPath.row-1]["webUrl"].string! + "#CSCI_571_NewsApp"
                let tweetUrl = self.homeResults[indexPath.row-1]["webTitle"]
                
                let shareString = "https://twitter.com/intent/tweet?text=\(textString)"
                
                // encode a space to %20 for example
                let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                // cast to an url
                let url = URL(string: escapedShareString)
                
                // open in safari
                //UIApplication.shared.openURL(url!)
                UIApplication.shared.open(url!)
            }
            var defaults = UserDefaults.standard
            var index = 0
            defaults.synchronize()
            var data = defaults.array(forKey: "bookmarkData")
            var url="";
            var addOrDelete = false
            if(self.homeResults[indexPath.row-1]["fields"] != nil && self.homeResults[indexPath.row-1]["fields"]["thumbnail"] != nil ){
                url = self.homeResults[indexPath.row-1]["fields"]["thumbnail"].string!
            }
            var data1 = ["":""]
            if(data != nil )
            {
                
                 data1  = [
                    "id" : self.homeResults[indexPath.row-1]["id"].string!,
                    "image" :url,
                    "sectionId" : self.homeResults[indexPath.row-1]["sectionName"].string!,
                    "date": self.homeResults[indexPath.row-1]["webPublicationDate"].string!,
                    "webTitle": self.homeResults[indexPath.row-1]["webTitle"].string!,
                    "webUrl" : self.homeResults[indexPath.row-1]["webUrl"].string!,
                    
                ]
                var deletedData = [[]];
                
              
                for datas in JSON(data!) {
                    
                    if(datas.1.count != 0 && datas.1["id"].string!  == self.homeResults[indexPath.row-1]["id"].string! ){
                        addOrDelete = true
                        break;
                    }else{
                        index = index + 1
                    }
                }
            }
            var imgName = ""
            if(addOrDelete)
            {
                imgName = "bookmark.fill"
                
            }else{
                
                imgName = "bookmark"
                
            }
            
            
            let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: imgName), identifier: nil) { action in
                
                if(addOrDelete)
                {
                    self.view.makeToast("Article Removed from Bookmarks", duration: 2.0)
                    data!.remove(at: index)
                    
                    
                }else{
                    if(data != nil){
                    data!.append(data1)
                    }else{
                        data = []
                        data!.append(data1)
                    }
                    self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                    
                    
                }
                defaults.set(data, forKey: "bookmarkData")
                defaults.synchronize()
             

                let delay = 0.4
                          DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                              self.homeResultsTable.performBatchUpdates({
                              self.homeResultsTable.reloadRows(at : [indexPath], with: UITableView.RowAnimation.none)
                              })
                          }
                

                
            }
            
            
            let edit = UIMenu(__title: "Edit", image: nil, identifier: nil, children:[twitter,bookmark])
            return UIMenu(__title: "Menu", image: nil, identifier: nil, children:[twitter, bookmark])
        }
        return configuration
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if(self.homeResultsTable != nil){
            self.homeResultsTable.reloadData()
        }
        
    }
}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
