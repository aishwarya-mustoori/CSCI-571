//
//  BookmarkView.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/21/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
class BookmarkView: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    
    @IBOutlet weak var bookmarkCollection: UICollectionView!
    @IBOutlet weak var dataLabel: UILabel!
    var bookmarkResults : [JSON] = []
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        bookmarkCollection.layer.removeAllAnimations()
        bookmarkCollection.delegate = self
        bookmarkCollection.dataSource = self
        bookmarkResults = []
        var data =  UserDefaults.standard.array(forKey: "bookmarkData")
        
        if(data != nil ){
            for datas in JSON(data!){
                bookmarkResults.append(datas.1)
            }
            if(bookmarkResults != nil && bookmarkResults.count > 0){
                dataLabel.isHidden =   true
                bookmarkCollection.isHidden = false
                
                
            }else{
                dataLabel.isHidden = false
                bookmarkCollection.isHidden = true
            }
        }else{
            dataLabel.isHidden = false
            bookmarkCollection.isHidden = true
        }
        self.bookmarkCollection.reloadData()
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(bookmarkResults != nil && bookmarkResults.count > 0){
            return self.bookmarkResults.count
            
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmark", for: indexPath) as! BookmarkCell
        cell.layer.removeAllAnimations()
        
        cell.contentView.layer.borderWidth = 0.6
        cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        if(bookmarkResults[indexPath.row].count > 0 ){
            
            if(bookmarkResults != nil && bookmarkResults[indexPath.row] != nil && bookmarkResults[indexPath.row] != nil && bookmarkResults[indexPath.row]["image"] != nil && !bookmarkResults[indexPath.row]["image"].string!.contains("not present")){
                
                var url = NSURL(string :bookmarkResults[indexPath.row]["image"].string!)
                let imgData = NSData.init(contentsOf: url! as URL)
                cell.bookmarkImage.image = UIImage(data :imgData! as Data)
            }else{
                
                cell.bookmarkImage.image =  UIImage(named : "default-guardian")!
            }
            if(bookmarkResults != nil && bookmarkResults[indexPath.row] != nil && bookmarkResults[indexPath.row]["date"] != nil){
                
                let date = bookmarkResults[indexPath.row]["date"].string!

                let dateFormatter1 = DateFormatter()
                let dateFormatter = ISO8601DateFormatter()
                let webDate = dateFormatter.date(from : date)!
                 
                                       
               dateFormatter1.dateFormat = "dd MMM"
             let convertedDate: String = dateFormatter1.string(from:webDate )
                          
                
                cell.bookmarkTime.text = convertedDate
                
            }
            if(bookmarkResults != nil && bookmarkResults[indexPath.row] != nil && bookmarkResults[indexPath.row]["sectionId"] != nil){
                
                var section = bookmarkResults[indexPath.row]["sectionId"].string!
                cell.bookmarkSection.text = "| " + section
                
            }
            
            if(bookmarkResults != nil && bookmarkResults[indexPath.row] != nil && bookmarkResults[indexPath.row]["webTitle"] != nil){
                
                if(cell.bookmarkTitle != nil){
                    cell.bookmarkTitle.text = bookmarkResults[indexPath.row]["webTitle"].string!
                    
                }}
            
            
            cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: UIControl.State.normal)
            cell.bookmarkButton.tag = indexPath.row
            cell.bookmarkButton.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        }
        return cell;
        
    }
    @objc func buttonClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        let defaults = UserDefaults.standard
        var data = defaults.array(forKey: "bookmarkData")
        
        self.view.makeToast("Article Removed from Bookmarks", duration: 2.0)
        data!.remove(at: buttonRow)
        
        
        
        bookmarkResults.remove(at: buttonRow)
        
        defaults.set(data, forKey: "bookmarkData")
        defaults.synchronize()
        if(bookmarkResults != nil && bookmarkResults.count > 0){
            dataLabel.isHidden =   true
            bookmarkCollection.isHidden = false
            
            
        }else{
            dataLabel.isHidden = false
            bookmarkCollection.isHidden = true
        }
        self.bookmarkCollection.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/2.0-5
        let yourHeight = yourWidth + 100
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? BookmarkCell,
            let indexPath = self.bookmarkCollection.indexPath(for: cell) {
            let vc = segue.destination as! HomeResultsDetailedArticle //Cast with your DestinationController
            //Now simply set the title property of vc
            vc.id = self.bookmarkResults[indexPath.row]["id"].string!
        }
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let twitter = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter"), identifier: nil) { action in
                let textString = self.bookmarkResults[indexPath.row]["webUrl"].string! + "#CSCI_571_NewsApp"
                let tweetUrl = self.bookmarkResults[indexPath.row]["webTitle"].string!
                
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
                "id" : self.bookmarkResults[indexPath.row]["id"],
                "image" :self.bookmarkResults[indexPath.row]["image"],
                "sectionId" : self.bookmarkResults[indexPath.row]["sectionId"],
                "date": self.bookmarkResults[indexPath.row]["date"],
                "webTitle": self.bookmarkResults[indexPath.row]["webTitle"],
                "webUrl" : self.bookmarkResults[indexPath.row]["webUrl"],
            ]
            
            var deletedData = [[]];
            var addOrDelete = false
            var index = 0
            if(data == nil || data?.count == 0)
            {
                self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 2.0)
                
                
                var data1  = [
                    "id" : self.bookmarkResults[indexPath.row]["id"],
                    "image" :self.bookmarkResults[indexPath.row]["image"],
                    "sectionId" : self.bookmarkResults[indexPath.row]["sectionId"],
                    "date": self.bookmarkResults[indexPath.row]["date"],
                    "webTitle": self.bookmarkResults[indexPath.row]["webTitle"],
                    "webUrl" : self.bookmarkResults[indexPath.row]["webUrl"],
                ]
                
                
                defaults.set([data1], forKey: "bookmarkData")
                defaults.synchronize()
                let delay = 0.4
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.bookmarkCollection.performBatchUpdates({
                        
                        self.bookmarkCollection.deleteItems(at: [indexPath])
                    })
                }
                
                
                
            }else{
                for datas in JSON(data!) {
                    
                    if(datas.1.count != 0 && datas.1["id"].string!  == self.bookmarkResults[indexPath.row]["id"].string! ){
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
                    self.bookmarkResults.remove(at :index)
                    
                    
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
                    self.bookmarkCollection.performBatchUpdates({
                        
                        self.viewDidLoad()
                    })
                }
                
                
            }
            
            
            let edit = UIMenu(__title: "Edit", image: nil, identifier: nil, children:[twitter,bookmark])
            return UIMenu(__title: "Menu", image: nil, identifier: nil, children:[twitter, bookmark])
        }
        return configuration
    }
    
}
