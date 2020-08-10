//
//  DetailedArticleHome.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/22/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class DetailedArticleHome: UIViewController {

    @IBOutlet weak var detailedDesc: UILabel!
    
    @IBOutlet weak var detailedButton: UIButton!
    @IBOutlet weak var detailedTime: UILabel!
    
    @IBOutlet weak var detailedSection: UILabel!
    @IBOutlet weak var detailedImage: UIImageView!
    @IBOutlet weak var detailedTitle: UILabel!
    
    @IBOutlet weak var twitterShare: UIButton!
   
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var detailedView: UIView!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBAction func onClickTwitter(_ sender: UIButton) {
        let textString = self.detailedResults[0]["webUrl"]! + "#CSCI_571_NewsApp"
        let tweetUrl = self.detailedResults[0]["webTitle"]!
                       
                       let shareString = "https://twitter.com/intent/tweet?text=\(textString)"
                       //encode a space to %20 for example
                       let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                       // cast to an url
                       let url = URL(string: escapedShareString)
                       
                       // open in safari
                       //UIApplication.shared.openURL(url!)
                       UIApplication.shared.open(url!)
    }
  
    var detailedResults : [[String : String]] = [[:]]
    var id = ""
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scroll.contentSize =  CGSize(width : 414, height : 1100)
    }
    override func viewDidLoad() {
        SwiftSpinner.show("Loading Detailed  Article...")
        super.viewDidLoad()
        view.addSubview(scroll)
    
    AF.request("https://amustoori.azurewebsites.net/detailed",parameters : ["id" : id]).responseJSON { (responseData) -> Void in
              
               if((responseData.data) != nil) {
                  
                   let swiftyJsonVar = JSON(responseData.data)
                   
                self.detailedResults = []
                   for values in swiftyJsonVar
                   {
                
                       self.detailedResults.append([
                           "image" : values.1[4]["url"].string!,
                           "id" : values.1[0]["id"].string!,
                           "sectionId" : values.1[1]["section"].string!,
                           "date": values.1[2]["date"].string!,
                           "webTitle": values.1[3]["title"].string!,
                           "webUrl" : values.1[5]["idUrl"].string!,
                        "description" :values.1[6]["description"].string!
                           
                       ])
                    
                       
                   }
                
                var defaults = UserDefaults.standard
                                    
                                     defaults.synchronize()
                                     var data = defaults.array(forKey: "bookmarkData")
                                  
                                     var addOrDelete = false
                                     if(data != nil){
                                     
                                     for datas in JSON(data!) {
                                         if(datas.1.count != 0  && datas.1["id"].string!  == self.detailedResults[0]["id"]! ){
                                             addOrDelete = true
                                             break;
                                         }
                                     }
                                     }
                                
                                     if(addOrDelete)
                                     {
                                        self.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: UIControl.State.normal)
                                                        
                                     }else{
                                       
                                        self.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: UIControl.State.normal)
                                                        
                                     }
                self.bookmarkButton.addTarget(self, action: #selector(self.buttonClicked), for: UIControl.Event.touchUpInside)

                                          
                let dateFormatter1 = DateFormatter()
                let dateFormatter = ISO8601DateFormatter()
                let webDate = dateFormatter.date(from : self.detailedResults[0]["date"]! )!
                
                dateFormatter1.dateFormat = "dd MMM yyyy"
                let convertedDate: String = dateFormatter1.string(from:webDate )
             
                self.detailedTitle.text = self.detailedResults[0]["webTitle"]
                self.detailedTime.text = convertedDate
                self.detailedSection.text = self.detailedResults[0]["sectionId"]
                if(self.detailedResults != nil && self.detailedResults[0] != nil && self.detailedResults[0]["image"] != nil && !self.detailedResults[0]["image"]!.contains("not present")){
                    
                    var url = NSURL(string :self.detailedResults[0]["image"]!)
                    let imgData = NSData.init(contentsOf: url! as URL)
                    self.detailedImage.image = UIImage(data :imgData! as Data)
                }else{
                    self.detailedImage.image =  UIImage(named : "default-guardian")!
                }

                self.detailedDesc.text = self.detailedResults[0]["description"]?.html2String
                self.detailedButton.addTarget(self, action: #selector(self.buttonClick), for: .touchUpInside)
                
                 
                self.navigationItem.title = self.detailedResults[0]["webTitle"]
                   
                   DispatchQueue.global(qos: .background).async {
                       
                       // Background Thread
                       
                       DispatchQueue.main.async {
                           // Run UI Updates
                        self.detailedView.reloadInputViews()
                           SwiftSpinner.hide()
                       }
                   }
                 

      
        
        
    }
    

   
    
        }
}
    
    @objc func buttonClick (sender : Any){
        let shareString = URL(string:self.detailedResults[0]["webUrl"]!)
        UIApplication.shared.open(shareString!)
    

        
    }
    


@objc func buttonClicked(sender:UIButton) {
       
       
       let defaults = UserDefaults.standard
       var data = defaults.array(forKey: "bookmarkData")
   
     
       if(data == nil || data?.count == 0)
       {
           self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
           var url="";
          
                     if(self.detailedResults[0]["image"] != nil ){
                      url = detailedResults[0]["image"]!
                     }

           var data1  = [
               "id" : self.detailedResults[0]["id"]!,
               "image" :url,
               "sectionId" : self.detailedResults[0]["sectionId"]!,
               "date": self.detailedResults[0]["date"]!,
               "webTitle": self.detailedResults[0]["webTitle"]!,
               "webUrl" : self.detailedResults[0]["webUrl"]!,
               ]


           defaults.set([data1], forKey: "bookmarkData")
           defaults.synchronize()
         self.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: UIControl.State.normal)
         self.bookmarkButton.reloadInputViews()
       


       }else {
           var url="";
           if(self.detailedResults[0]["image"] != nil ){
            url = detailedResults[0]["image"]!
           }
           var data1  = [
                          "id" : self.detailedResults[0]["id"]!,
                          "image" :url,
                          "sectionId" : self.detailedResults[0]["sectionId"]!,
                          "date": self.detailedResults[0]["date"]!,
                          "webTitle": self.detailedResults[0]["webTitle"]!,
                          "webUrl" : self.detailedResults[0]["webUrl"]!,
           ]
           var deletedData = [[]];
           var addOrDelete = false
           var index = 0
           for datas in JSON(data!) {

               if(datas.1.count != 0  && datas.1["id"].string!  == self.detailedResults[0]["id"]! ){
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
             
             self.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: UIControl.State.normal)
 self.bookmarkButton.reloadInputViews()
               defaults.set(data, forKey: "bookmarkData")
                defaults.synchronize()
            self.scroll.reloadInputViews()
            self.navigationController?.reloadInputViews()
               
           }else{
           data!.append(data1)
               self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
             self.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: UIControl.State.normal)
            self.bookmarkButton.reloadInputViews()

               defaults.set(data, forKey: "bookmarkData")
                defaults.synchronize()
            self.scroll.reloadInputViews()
            self.navigationController?.reloadInputViews()

           }


       }

       
   }
   
}
