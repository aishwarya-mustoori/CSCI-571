//
//  scienceView.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/24/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyJSON
import Alamofire

import XLPagerTabStrip

class ScienceView: UIViewController,IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var scienceResultsTable: UITableView!
    var refreshControl = UIRefreshControl()
    var scienceResults : [[String : String]] = [[:]]
    var selected = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        SwiftSpinner.show("Loading SCIENCE Headlines..")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        scienceResultsTable.addSubview(refreshControl)
        scienceResultsTable.isHidden = false
        scienceResultsTable.delegate = self
        scienceResultsTable.dataSource = self
        
        AF.request("https://amustoori.azurewebsites.net/searchSections?section=science").responseJSON { (responseData) -> Void in
            
            if((responseData) != nil) {
                
                let swiftyJsonVar = JSON(responseData.data)
                
                self.scienceResults=[]
                for values in swiftyJsonVar
                {
                    
                    self.scienceResults.append([
                        "image" : values.1[4]["url"].string!,
                        "id" : values.1[0]["id"].string!,
                        "sectionId" : values.1[1]["section"].string!,
                        "date": values.1[2]["date"].string!,
                        "webTitle": values.1[3]["title"].string!,
                        "webUrl" : values.1[5]["idUrl"].string!
                        
                    ])
                    
                }
                
                DispatchQueue.global(qos: .background).async {
                    
                    // Background Thread
                    
                    DispatchQueue.main.async {
                        // Run UI Updates
                        self.scienceResultsTable.reloadData()
                        
                        SwiftSpinner.hide()
                    }
                }
            }
            
            
            
        }
        
        
    }
    
    @objc func refresh() {
        
        
        AF.request("https://amustoori.azurewebsites.net/searchSections?section=science").responseJSON { (responseData) -> Void in
            if((responseData.data) != nil) {
                
                let swiftyJsonVar = JSON(responseData.data)
                
                self.scienceResults=[]
                for values in swiftyJsonVar
                {
                    self.scienceResults.append([
                        "image" : values.1[4]["url"].string!,
                        "id" : values.1[0]["id"].string!,
                        "sectionId" : values.1[1]["section"].string!,
                        "date": values.1[2]["date"].string!,
                        "webTitle": values.1[3]["title"].string!,
                        "webUrl" : values.1[5]["idUrl"].string!
                    ])
                    
                }
                
                
                DispatchQueue.global(qos: .background).async {
                    
                    // Background Thread
                    
                    DispatchQueue.main.async {
                        // Run UI Updates
                        self.scienceResultsTable.reloadData()
                        
                        SwiftSpinner.hide()
                    }
                }
                
                
                
                
            }
            
            
            
            
            self.refreshControl.endRefreshing()
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scienceResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scienceCells",for: indexPath) as! PoliticsCells

        cell.contentView.layer.borderWidth = 0.6
                cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
               cell.contentView.layer.cornerRadius = 12
               cell.contentView.layer.masksToBounds = true
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 10 , left: 10, bottom: 0, right:10))
        
        if(scienceResults != nil && scienceResults[indexPath.row] != nil && scienceResults[indexPath.row] != nil && scienceResults[indexPath.row]["image"] != nil && !scienceResults[indexPath.row]["image"]!.contains("not present")  ){
            
            var url = NSURL(string :scienceResults[indexPath.row]["image"]!)
            let imgData = NSData.init(contentsOf: url! as URL)
            cell.mainImage.image = UIImage(data :imgData! as Data)
        }else{
            
            cell.mainImage.image =  UIImage(named : "default-guardian")!
        }
        if(scienceResults != nil && scienceResults[indexPath.row] != nil && scienceResults[indexPath.row]["date"] != nil){
            
            let date = scienceResults[indexPath.row]["date"]!
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
            
            cell.mainTime.text = diff
            
        }
        if(scienceResults != nil && scienceResults[indexPath.row] != nil && scienceResults[indexPath.row]["sectionId"] != nil){
            
            var section = scienceResults[indexPath.row]["sectionId"]!
            cell.mainSection.text = "| " + section
            
        }
        
        if(scienceResults != nil && scienceResults[indexPath.row] != nil && scienceResults[indexPath.row]["webTitle"] != nil){
            
            if(cell.mainTitle != nil){
                cell.mainTitle.text = scienceResults[indexPath.row]["webTitle"]!
                
            }}
        
        var defaults = UserDefaults.standard
        
        defaults.synchronize()
        var data = defaults.array(forKey: "bookmarkData")
        var addOrDelete = false
        if(data != nil &&  self.scienceResults[0]["id"] != nil){
            
            for datas in JSON(data!) {
                if(datas.1["id"].string!  == self.scienceResults[indexPath.row]["id"]! ){
                    addOrDelete = true
                    break;
                }
            }
        }
        
        if(addOrDelete)
        {
            cell.mainBookmark.setImage(UIImage(systemName: "bookmark.fill"), for: UIControl.State.normal)
            
        }else{
            
            cell.mainBookmark.setImage(UIImage(systemName: "bookmark"), for: UIControl.State.normal)
            
        }
        
        
        cell.mainBookmark.tag = indexPath.row
        cell.mainBookmark.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        
        
        
        
        return cell;
        
        
    }
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SCIENCE")
    }
    @objc func buttonClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        let defaults = UserDefaults.standard
        var data = defaults.array(forKey: "bookmarkData")
        
        
        
        if(data == nil || data?.count == 0)
        {
            self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
            
            
            var data1  = [
                "id" : self.scienceResults[buttonRow]["id"]!,
                "image" :self.scienceResults[buttonRow]["image"]!,
                "sectionId" : self.scienceResults[buttonRow]["sectionId"]!,
                "date": self.scienceResults[buttonRow]["date"]!,
                "webTitle": self.scienceResults[buttonRow]["webTitle"]!,
                "webUrl" : self.scienceResults[buttonRow]["webUrl"]!,
            ]
            
            
            defaults.set([data1], forKey: "bookmarkData")
            defaults.synchronize()
            self.scienceResultsTable.reloadData()
            
            
        }else {
            var data1  = [
                "id" : self.scienceResults[buttonRow]["id"]!,
                "image" :self.scienceResults[buttonRow]["image"]!,
                "sectionId" : self.scienceResults[buttonRow]["sectionId"]!,
                "date": self.scienceResults[buttonRow]["date"]!,
                "webTitle": self.scienceResults[buttonRow]["webTitle"]!,
                "webUrl" : self.scienceResults[buttonRow]["webUrl"]!,
            ]
            var deletedData = [[]];
            var addOrDelete = false
            var index = 0
            for datas in JSON(data!) {
                
                if(datas.1["id"].string!  == self.scienceResults[buttonRow]["id"]! ){
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
            self.scienceResultsTable.reloadData()
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selected = self.scienceResults[indexPath.row]["id"]!
        performSegue(withIdentifier: "detailedArticle", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailedArticle"){
            
            var vc = segue.destination as! HomeResultsDetailedArticle
            vc.id = selected
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.scienceResultsTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let twitter = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter"), identifier: nil) { action in
                let textString = self.scienceResults[indexPath.row]["webUrl"]! + "#CSCI_571_NewsApp"
                let tweetUrl = self.scienceResults[indexPath.row]["webTitle"]
                
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
            defaults.synchronize()
            var data = defaults.array(forKey: "bookmarkData")
            
            var data1  = [
                "id" : self.scienceResults[indexPath.row]["id"]!,
                "image" :self.scienceResults[indexPath.row]["image"]!,
                "sectionId" : self.scienceResults[indexPath.row]["sectionId"]!,
                "date": self.scienceResults[indexPath.row]["date"]!,
                "webTitle": self.scienceResults[indexPath.row]["webTitle"]!,
                "webUrl" : self.scienceResults[indexPath.row]["webUrl"]!,
            ]
            
            var deletedData = [[]];
            var addOrDelete = false
            var index = 0
            if(data == nil || data?.count == 0)
            {
                self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                
                
                var data1  = [
                    "id" : self.scienceResults[indexPath.row]["id"]!,
                    "image" :self.scienceResults[indexPath.row]["image"]!,
                    "sectionId" : self.scienceResults[indexPath.row]["sectionId"]!,
                    "date": self.scienceResults[indexPath.row]["date"]!,
                    "webTitle": self.scienceResults[indexPath.row]["webTitle"]!,
                    "webUrl" : self.scienceResults[indexPath.row]["webUrl"]!,
                ]
                
                
                defaults.set([data1], forKey: "bookmarkData")
                defaults.synchronize()
                let delay = 0.4
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.scienceResultsTable.performBatchUpdates({
                        self.scienceResultsTable.reloadRows(at : [indexPath], with: UITableView.RowAnimation.none)
                    })
                }
                
                
                
            }else{
                for datas in JSON(data!) {
                    
                    if(datas.1.count != 0 && datas.1["id"].string!  == self.scienceResults[indexPath.row]["id"] ){
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
                    self.scienceResultsTable.performBatchUpdates({
                        self.scienceResultsTable.reloadRows(at : [indexPath], with: UITableView.RowAnimation.none)
                    })
                }
                
                
                
            }
            
            
            let edit = UIMenu(__title: "Edit", image: nil, identifier: nil, children:[twitter,bookmark])
            return UIMenu(__title: "Menu", image: nil, identifier: nil, children:[twitter, bookmark])
        }
        return configuration
    }
    
    
    
}






