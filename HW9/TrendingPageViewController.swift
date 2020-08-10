//
//  TrendingPageViewController.swift
//  IOSApp
//
//  Created by Aishwarya Mustoori on 4/18/20.
//  Copyright © 2020 Aishwarya Mustoori. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON
class TrendingPageViewController: ViewController {

    @IBOutlet weak var lineChartView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lineChart: LineChartView!
    var values :[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = nil
        var text = ""
              lineChart.layer.borderColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

               lineChart.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
               lineChart.layer.borderWidth = 1
        if(textField.text!.count == 0){
        text = "Coronavirus"
        }else{
            text = textField.text!
        }
        textField.addTarget(self, action: #selector(onInputChange), for: UIControl.Event.editingDidEndOnExit)
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
        AF.request("https://amustoori.azurewebsites.net/googTrends",parameters : ["keyword": text] ).responseJSON { (responseData) -> Void in
         
            self.values = []
            
            if((responseData.data) != nil) {
                var swifty = JSON(responseData.data)
               
                for i in  swifty["default"]["timelineData"]{
                 
                    self.values.append(i.1["value"][0].int!)
                   
                }
            }

            var dataEntry = [ChartDataEntry]()
            for i in 0 ..< self.values.count {
                let minT = ChartDataEntry(x: Double(i),y: Double(self.values[i]) as! Double)
                dataEntry.append(minT)
            }
            let label = ("Trending Charts for " + text)
            let plotData = LineChartData()
            
            let line = LineChartDataSet(entries : dataEntry,label : label)
            line.circleHoleColor = NSUIColor.systemBlue
            line.colors = [NSUIColor.systemBlue]
            
            line.circleRadius = 4.3
            line.circleColors = [NSUIColor.systemBlue]
           
            
            plotData.addDataSet(line)
     
            self.lineChart.data = plotData
         }
        }
        }
            
    }
    
    @objc func onInputChange(sender : UITextField){
        viewDidLoad()
    }
    
    override  func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           viewDidLoad()
    }
}
