//
//  TableViewController.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 21/07/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

import UIKit
import CoreData

class CoinViewController: UITableViewController, UISearchBarDelegate {
    
    public var CoinTableView = [Any]()
    public var currentTableView = [Any]()
    public var searchController : UISearchController!
    
    let managedContext = DataManager().objectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line  to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //  creating the search controller
        searchController = UISearchController(searchResultsController: nil)
        //  A Boolean indicating whether the underlying content is dimmed during a search.
        searchController.dimsBackgroundDuringPresentation = false
        //  A Boolean indicating whether the navigation bar should be hidden when searching.
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        
        // completion to get the result from the poloniex api request
        poloniex.getReturnTicker{coinArray, connect in
            if connect{
                self.navigationController?.navigationBar.topItem?.title = "Saving"
                self.CoinTableView = coinArray!
                
                let entity =  NSEntityDescription.entity(forEntityName: "AllCoins", in:self.managedContext!)
                let coins = NSManagedObject(entity: entity!, insertInto: self.managedContext)
                
                for coin in coinArray! {
                    coins.setValue(coin.name, forKey: "name")
                    coins.setValue(coin.percentChange, forKey: "percentChange")
                    coins.setValue(coin.value, forKey: "value")
                    
                    do {
                        try self.managedContext?.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                }
            }else{
                print("fetching")
                /*self.navigationController?.navigationBar.topItem?.title = "Fetching"
                // fetching all the songs from CoreData
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllCoins")
                
                do {
                    let coins = try self.managedContext?.fetch(fetchRequest)
                    self.CoinTableView = coins as! [NSManagedObject]
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }*/
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        currentTableView.removeAll()
        
        for coin in CoinTableView{
            //print((coin as! Coin).name)
            //print(searchController.searchBar.text!.uppercased())
            //tprint((coin as! Coin).name.range(of: searchController.searchBar.text!.uppercased())!)
            if ((coin as! Coin).name.range(of: searchController.searchBar.text!.uppercased()) != nil) {
                //print("coin = \(coin as! Coin)")
                currentTableView.append(coin)
            }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentTableView.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        configureCell(cell: cell, forRowAtIndexPath: indexPath as NSIndexPath)

        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        cell.textLabel?.text = (currentTableView[indexPath.row] as! Coin).name
        cell.detailTextLabel?.text = (currentTableView[indexPath.row] as! Coin).value
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to suppbort conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
