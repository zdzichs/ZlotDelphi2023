//
//  ViewController.swift
//  MyWeather
//
//  Created by Zdzislaw Sroczynski 2023.
//

import UIKit

struct WeatherData {
    var loc  = ""
    var dt   = ""
    var temp = 0.0
    var pres = 0
    var tmin = 0.0
    var tmax = 0.0
    var hum  = 0
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var WeatherHours = [WeatherData]()
    var WeatherToTransfer = WeatherData()
    var TimerLocName : Timer?
    
    @IBOutlet weak var ActInd: UIActivityIndicatorView!
    
    @IBOutlet weak var SearchBarCityName: UISearchBar!
    
    @IBOutlet weak var TableViewWeatherHours: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherHours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherHoursCellId", for: indexPath);
        print("row="+String(indexPath.row))
        cell.textLabel?.text = WeatherHours[indexPath.row].dt
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        WeatherToTransfer = WeatherHours[indexPath.row]
        self.performSegue(withIdentifier: "ShowDetails", sender:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
            if segue.identifier == "ShowDetails"
            {
                let dest = segue.destination as! TableViewControllerDetails
                dest.WeatherDetails = WeatherToTransfer
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewWeatherHours.delegate = self
        TableViewWeatherHours.dataSource = self
        SearchBarCityName.delegate = self
        // Do any additional setup after loading the view.
    }

    func LoadWeatherData(_ locationName : String){
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q="+locationName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!+"&units=metric&APPID=API_KEY")!
        let session = URLSession.shared
        let encoding = String.Encoding.utf8
        
        self.view.bringSubviewToFront(self.ActInd)
        self.ActInd.startAnimating()
        let task : URLSessionDataTask = session.dataTask( with: url, completionHandler:
            { data, response, error -> Void in
                NSLog("Zaladowane")
                self.WeatherHours = []
                let contents = String(data: data!, encoding:encoding)
                //DispatchQueue.main.async{self.TextViewResult.text = contents}
                do
                {
                  let parsed = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                
                    if let jsonResult = parsed as? [String: Any] {
                        let jsonCount = jsonResult["cnt"] as? Int
                        let jsonCod = jsonResult["cod"] as? String
                        if jsonCod == "200"{
                            
                            let WeatherForecastArr = jsonResult["list"] as? [[String:Any]]
                            
                            for WeatherForecast in WeatherForecastArr!{
                                var wf = WeatherData()
                                wf.dt = WeatherForecast["dt_txt"] as! String
                                var WeatherParams = WeatherForecast["main"] as? [String:Any]
                                wf.loc  = locationName
                                wf.temp = WeatherParams!["temp"] as! Double
                                wf.pres = WeatherParams!["pressure"] as! Int
                                wf.tmin = WeatherParams!["temp_min"] as! Double
                                wf.tmax = WeatherParams!["temp_max"] as! Double
                                wf.hum = WeatherParams!["humidity"] as! Int
                                self.WeatherHours.append(wf)
                            }
                        }
                        DispatchQueue.main.async{
                            self.ActInd.stopAnimating()
                            self.TableViewWeatherHours.reloadData()
                            
                        }
                            
                      
                    }
                }
                catch
                {
                    print("JSON ma bubu")
                }

            }
            
        );
        task.resume()
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if let tln = TimerLocName {
            if tln.isValid {
                tln.invalidate()
            }
        }
        TimerLocName = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.LoadWeatherData(self.SearchBarCityName.text!)
            self.SearchBarCityName.searchTextField.endEditing(true)
        }
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.SearchBarCityName.searchTextField.endEditing(true)
    }
}

