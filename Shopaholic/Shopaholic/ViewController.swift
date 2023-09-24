//
//  ViewController.swift
//  Shopaholic
//
//  Created by Zdzislaw Sroczynski 2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var elems = [ItemToBuy]()
    var velems = [Int]()
    @IBOutlet weak var MainNavigationBar: UINavigationBar!
    
    func UpdateVElems(){
        velems = []
        if SearchBarMain.text != "" {
            var idx = 0
            for el in elems {
                if el.name!.localizedLowercase.contains(SearchBarMain.text!.localizedLowercase) {
                    print(el.name!.localizedLowercase)
                    print(SearchBarMain.text!.localizedLowercase)
                    print(idx)
                    velems.append(idx)
                }
                idx += 1
            }
        }
        else
        {
            var idx = 0
            for _ in elems {
                velems.append(idx)
                idx += 1
            }
        }
        DispatchQueue.main.async {
                self.TableViewItems.reloadData()

            }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UpdateVElems()
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UpdateVElems()
    }
    
    func UpdateCountInfo(){
        var cnt = 0
        for el in elems{
            if !el.done{cnt+=1}
        }
        UIApplication.shared.applicationIconBadgeNumber = cnt;
        if cnt > 0 {
            MainNavigationBar!.topItem!.title = "Shopaholic ("+String(cnt)+")"
        }
        else
        {
            MainNavigationBar!.topItem!.title = "Shopaholic"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddViewID") {
            let dest = segue.destination as! ViewControllerAdd
            dest.MainViewController  = self
        }
    }
  
    @IBOutlet weak var SearchBarMain: UISearchBar!
    
    @IBAction func SearchButtonClick(_ sender: Any) {
        SearchBarMain.isHidden = !SearchBarMain.isHidden
        if SearchBarMain.isHidden{
            SearchBarMain.text = ""
            SearchBarMain.searchTextField.endEditing(true)
        }
        UpdateVElems()
    }
    func AddElemClick(_ ANazwa: String,_ AIle: Int) {
        let managedContext = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!

        let newElem = ItemToBuy(context: managedContext)
        newElem.setValue(ANazwa, forKey: #keyPath(ItemToBuy.name))
        newElem.setValue(AIle, forKey: #keyPath(ItemToBuy.amount))
        newElem.setValue(false, forKey: #keyPath(ItemToBuy.favourite))
        newElem.setValue(false, forKey: #keyPath(ItemToBuy.done))
        elems.append(newElem)
        UpdateVElems()
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                         
        DispatchQueue.main.async {
                self.TableViewItems.reloadData()
                self.UpdateCountInfo()
            }
    }
    
    
    @IBOutlet weak var TableViewItems: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return velems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableCellId", for: indexPath);
        print("row="+String(indexPath.row))
        let currElem = elems[velems[indexPath.row]]
        cell.textLabel?.text = currElem.name
        cell.detailTextLabel?.text = String(currElem.amount)
        if currElem.done {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        else
        {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Usuń"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.delete(elems[velems[indexPath.row]])
            elems.remove(at: velems[indexPath.row])
            UpdateVElems()
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            DispatchQueue.main.async {
                tableView.reloadData()
                //tableView.deleteRows(at: [indexPath], with: .fade)
                self.UpdateCountInfo()
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(indexPath.row)
        SearchBarMain.searchTextField.endEditing(true)
        elems[velems[indexPath.row]].done = !elems[velems[indexPath.row]].done
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        DispatchQueue.main.async {
            //self.TableViewItems.reloadRows(at:[indexPath],
            tableView.beginUpdates()
            tableView.reloadRows(at:[indexPath],with:UITableView.RowAnimation.automatic)
            self.UpdateCountInfo()
            tableView.endUpdates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItemsToBuy()
        UpdateVElems()
        UpdateCountInfo()
        TableViewItems.delegate = self
        TableViewItems.dataSource = self
        self.SearchBarMain.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func getItemsToBuy() {
        let ItemToBuyFetch: NSFetchRequest<ItemToBuy> = ItemToBuy.fetchRequest()
//        let sortByDate = NSSortDescriptor(key: #keyPath(Note.dateAdded), ascending: false)
//        noteFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
            let results = try managedContext.fetch(ItemToBuyFetch)
            elems = results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }

}

