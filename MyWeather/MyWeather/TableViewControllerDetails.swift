//
//  TableViewControllerDetails.swift
//  MyWeather
//
//  Created by Zdzislaw Sroczynski 2023.
//

import UIKit


class TableViewControllerDetails: UITableViewController {

    var WeatherDetails = WeatherData()
    
    @IBOutlet weak var LblTemp: UILabel!
    
    @IBOutlet weak var LblPress: UILabel!
    
    @IBOutlet weak var LblTempMin: UILabel!
    

    @IBOutlet weak var LblTempMax: UILabel!
    
    @IBOutlet weak var LblHum: UILabel!
    
    @IBOutlet var TableViewWeatherDetails: UITableView!
    
    
    func R2(_ nmb : Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: nmb))!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LblTemp.text = String(R2(WeatherDetails.temp))
        LblPress.text = String(WeatherDetails.pres)
        LblTempMin.text = String(R2(WeatherDetails.tmin))
        LblTempMax.text = String(R2(WeatherDetails.tmax))
        LblHum.text = String(WeatherDetails.hum)
    
        self.title = WeatherDetails.loc + " " + WeatherDetails.dt
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


}
