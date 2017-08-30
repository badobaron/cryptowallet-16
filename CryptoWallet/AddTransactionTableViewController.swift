//
//  AddTransactionTableViewController.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 06/08/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

import UIKit

class AddTransactionTableViewController: UITableViewController, UISearchBarDelegate {

    public var CoinTableView = [Any?]()
    public var currentTableView = [Any?]()
    //  search controller
    var searchController : UISearchController!
    //  activity indicator view
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //  creating activity indicator view
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        
        //  creating the search controller
        searchController = UISearchController(searchResultsController: nil)
        //  A Boolean indicating whether the underlying content is dimmed during a search.
        searchController.dimsBackgroundDuringPresentation = true
        //  A Boolean indicating whether the navigation bar should be hidden when searching.
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for coin"
        
        tableView.tableHeaderView = searchController.searchBar
        //  The search to the spotify api starts here, so I display the activity indicator
        startAnimation()
        
        // completion to get the result from the poloniex api request
        CoinMarketCap.getReturnTicker(first: false){coinArray, connect in
            if connect{
                self.CoinTableView = coinArray!
                self.currentTableView = self.CoinTableView as! [Coin]
                self.stopAnimation()
                self.tableView.reloadData()
            }else{
                self.stopAnimation()
            }
        }
    }
    
    //  Starting the activity indicator view
    func startAnimation() {
        //  I display none the cell separators in order to get a better look at the activity indicator
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        activityIndicatorView.startAnimating()
    }
    
    //  Stopping the activity indicator view
    func stopAnimation() {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        activityIndicatorView.stopAnimating()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CoinTableView.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        let name = cell.viewWithTag(1) as! UILabel
        name.text = (CoinTableView[indexPath.row] as? Coin)?.FullName

        return cell
    }
    
    // Research
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        CoinTableView = currentTableView
        CoinTableView.removeAll()
        
        for coin in currentTableView{
            if ((coin as! Coin).FullName?.uppercased().range(of: searchController.searchBar.text!.uppercased()) != nil) {
                CoinTableView.append(coin)
            }
        }
        
        // if there is at least one match between the seachBar text and the coin list, I add the title cell
        /*if !CoinTableView.isEmpty {
            self.createTitleCell()
        }*/
        
        // if text deleted, I display the entire coin list
        if (searchController.searchBar.text == "") {
            CoinTableView = currentTableView
        }
        
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        CoinTableView = currentTableView
        self.tableView.reloadData()
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
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "coinTransaction" {
            if let indexPath = tableView.indexPathForSelectedRow {
                print("indexPath = \(indexPath)")
                let destinationNavigationController = segue.destination as! SetUpTransactionTableViewController
                //let targetController = destinationNavigationController.topViewController as! SetUpTransactionTableViewController
                
                destinationNavigationController.FullName = ((CoinTableView[indexPath.row] as? Coin)?.FullName)!
            }
        }
    }
    

}
