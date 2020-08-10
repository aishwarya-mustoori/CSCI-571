//
//  HeadlinesViewViewController.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/19/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
class HeadlinesView: ButtonBarPagerTabStripViewController,UISearchResultsUpdating,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    @IBOutlet weak var headlines: UINavigationItem!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var headlinesAutoSuggestTable: UITableView!
    @IBOutlet weak var buttons: ButtonBarView!
    
    var autoSearchText : String = ""
    var autoSuggestResults :[String] = []
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    override func viewDidLoad() {
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .systemBlue
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .blue
        
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = .systemBlue
        }
        
        
        super.viewDidLoad()
        headlinesAutoSuggestTable.delegate = self
        headlinesAutoSuggestTable.dataSource = self
        navigationItem.hidesSearchBarWhenScrolling = false
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search keyword.."
        definesPresentationContext = false
        searchController.searchBar.delegate = self
        
        searchController.searchBar.sizeToFit()
        if(headlines != nil)
        {
            headlines.searchController = searchController
        }
        
        
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let world = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "world")
        let business = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "business")
        
        let politics = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "politics")
        let sports = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sports1")
        let technology = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "technology")
        let science = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "science1")
        return [world,business,politics,sports,technology,science]
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.headlinesAutoSuggestTable.isHidden = true
        searchBar.text = ""
        self.containerView.isHidden = false
        self.buttons.isHidden = false
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.count > 2){
            self.autoSuggestResults=[]
            self.containerView.isHidden = true
            self.buttons.isHidden = true
            
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
                        self.headlinesAutoSuggestTable.reloadData()
                    }
                }
                self.headlinesAutoSuggestTable.isHidden = false
                self.headlinesAutoSuggestTable.reloadData()
            }
        }else{
            headlinesAutoSuggestTable.isHidden = true
            containerView.isHidden = false
            self.buttons.isHidden = false
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = headlinesAutoSuggestTable.dequeueReusableCell(withIdentifier: "autoSuggest",for: indexPath)
        cell.textLabel?.text = autoSuggestResults[indexPath.row]
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if( self.autoSuggestResults.count != 0 ){
            autoSearchText = self.autoSuggestResults[indexPath.row]
        }
        
        navigationItem.searchController?.searchBar.text = autoSearchText
        
        self.headlinesAutoSuggestTable.isHidden = true
        self.containerView.isHidden = false
        self.buttons.isHidden = false
        performSegue(withIdentifier: "searchResults", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.autoSuggestResults.count
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "searchResults"){
            
            var vc = segue.destination as! SearchResultsView
            vc.searchText = self.autoSearchText
            
        }
    }
}
