//
//  ViewControllerAdd.swift
//  Shopaholic
//
//  Created by Zdzislaw Sroczynski 2023.
//

import UIKit

class ViewControllerAdd: UIViewController {

    var MainViewController : ViewController?
    
    @IBOutlet weak var EditCoKupic: UITextField!
    
    @IBOutlet weak var EditIleKupic: UITextField!
    
    @IBAction func AnulujClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func ShowMessage(_ AText : String){
        let alert = UIAlertController(title: "Uwaga", message: AText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default: break
                            
                        case .cancel:
                            break
                        case .destructive:
                            break
                        @unknown default:
                            break
                        }
                    }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func DodajClick(_ sender: Any) {
        let nazwa = EditCoKupic.text!
        if nazwa.count > 0{
            let ile = Int(EditIleKupic.text!) ?? 0
            if ile > 0{
                MainViewController?.AddElemClick(nazwa, ile)
                self.dismiss(animated: true)
            }
            else
            {
               ShowMessage("Podaj ilość!")
            }
        }
        else
        {
            ShowMessage("Wpisz co chcesz kupić!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
