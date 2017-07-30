//
//  TableViewController.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 27/07/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

import UIKit
import TWMessageBarManager
import DGElasticPullToRefresh

class CMKTableViewController: UITableViewController, UISearchBarDelegate {
    
    public var CoinTableView = [Any?]()
    public var currentTableView = [Any]()
    public var searchController : UISearchController!
    var sharedInstance = TWMessageBarManager()
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I init here the reloading system of the table view
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // completion to get the result from the CoinMarketCap api request
            CoinMarketCap.getReturnTicker{coinArray, connect in
                if connect{
                    self?.CoinTableView = coinArray!
                    self?.createTitleCell()
                    self?.currentTableView = self?.CoinTableView as! [CoinMC]
                    self?.tableView.reloadData()
                    self?.tableView.dg_stopLoading()
                }else{
                    self?.sharedInstance.showMessage(withTitle: "No internet connection", description: "Previous data displayed", type: TWMessageBarMessageType.error)
                    // TODO CoreData here
                    self?.tableView.dg_stopLoading()
                }
            }
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        //  creating the search controller
        searchController = UISearchController(searchResultsController: nil)
        //  A Boolean indicating whether the underlying content is dimmed during a search.
        searchController.dimsBackgroundDuringPresentation = false
        //  A Boolean indicating whether the navigation bar should be hidden when searching.
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        
        // completion to get the result from the poloniex api request
        CoinMarketCap.getReturnTicker{coinArray, connect in
            if connect{
                self.sharedInstance.showMessage(withTitle: "Data updated", description: "Connected to Internet", type: TWMessageBarMessageType.success)
                self.CoinTableView = coinArray!
                
                // here i add a new coin that represents the title cell
                self.createTitleCell()
                self.currentTableView = self.CoinTableView as! [CoinMC]
                self.tableView.reloadData()
            }else{
                self.sharedInstance.showMessage(withTitle: "Data Not updated", description: "No internet connection", type: TWMessageBarMessageType.error)
            }
        }
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
        // Row is DefaultCell
        if (CoinTableView[indexPath.row] as? CoinMC) != nil {
            if (CoinTableView[indexPath.row] as! CoinMC).id == "title" {
                let cellStatic = tableView.dequeueReusableCell(withIdentifier: "titleStatic", for: indexPath)
                
                // full line separator in between cells
                cellStatic.preservesSuperviewLayoutMargins = false
                cellStatic.separatorInset = UIEdgeInsets.zero
                cellStatic.layoutMargins = UIEdgeInsets.zero
                
                // Configure the cell...
                cellStatic.backgroundColor = UIColor.lightGray
                
                return cellStatic
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                
                // full line separator in between cells
                cell.preservesSuperviewLayoutMargins = false
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
                
                // Configure the cell...
                return configureCell(cell: cell ,forRowAtIndexPath: indexPath as NSIndexPath)
            }
        }
        // Row is ExpansionCell
        else {
            if CoinTableView[getParentCellIndex(expansionIndex: indexPath.row)] != nil {
                
                //  Create an ExpansionCell
                let expansionCell = tableView.dequeueReusableCell(withIdentifier: "ExpansionCell", for: indexPath)
                
                //  Get the index of the parent Cell (containing the data)
                let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
                
                //  Set the cell's data
                let coinTestName = expansionCell.viewWithTag(7) as! UILabel
                coinTestName.text = (CoinTableView[parentCellIndex] as! CoinMC).symbol
                
                return expansionCell
            } else {
                return UITableViewCell()
            }
        }
    }
    
        
    /*  Get parent cell for selected ExpansionCell  */
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: CoinMC?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 1) {
            selectedCellIndex -= 1
            selectedCell = CoinTableView[selectedCellIndex] as? CoinMC
        }
        
        return selectedCellIndex
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        // tag 1 is the coin name in the table view cell
        let coinName = cell.viewWithTag(1) as! UILabel
        coinName.text = (CoinTableView[indexPath.row] as! CoinMC).name
        // tag 2 is price of the coin in the table view cell
        let priceCoin = cell.viewWithTag(4) as! UILabel
        priceCoin.text = String((CoinTableView[indexPath.row] as! CoinMC).price)
        priceCoin.text?.append("€")
        // tag 3 is the 24h change in the table view cell
        let h24Change = cell.viewWithTag(3) as! UILabel
        h24Change.text = String((CoinTableView[indexPath.row] as! CoinMC).percent_change_24h)
        h24Change.text?.append("%")
        
        // color green for + and red for -
        if h24Change.text?.characters.first == "-"{
            priceCoin.textColor = UIColor.red
            h24Change.textColor = UIColor.red
        } else {
            priceCoin.textColor = UIColor.green
            h24Change.textColor = UIColor.green
        }
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // There is no expansion for the title cell, so i cannot select it
        if indexPath.row != 0{
            if CoinTableView[indexPath.row] != nil {
                // If user clicked last cell, do not try to access cell+1 (out of range)
                if(indexPath.row + 1 >= (CoinTableView.count)) {
                    expandCell(tableView: tableView, index: indexPath.row)
                }
                else {
                    // If next cell is not nil, then cell is not expanded
                    if(CoinTableView[indexPath.row+1] != nil) {
                        expandCell(tableView: tableView, index: indexPath.row)
                        // Close Cell (remove ExpansionCells)
                    } else {
                        contractCell(tableView: tableView, index: indexPath.row)
                        
                    }
                }
            }
        }
    }
    
    private func expandCell(tableView: UITableView, index: Int) {
        CoinTableView.insert(nil, at: index + 1)
        tableView.insertRows(at: [NSIndexPath(row: index + 1, section: 0) as IndexPath] , with: .top)
    }
    
    private func contractCell(tableView: UITableView, index: Int) {
        CoinTableView.remove(at: index+1)
        tableView.deleteRows(at: [NSIndexPath(row: index+1, section: 0) as IndexPath], with: .top)
    }
    
    // Research
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        CoinTableView = currentTableView
        CoinTableView.removeAll()
        
        for coin in currentTableView{
            if ((coin as! CoinMC).name.uppercased().range(of: searchController.searchBar.text!.uppercased()) != nil) {
                CoinTableView.append(coin)
            }
        }
        
        // if there is at least one match between the seachBar text and the coin list, I add the title cell
        if !CoinTableView.isEmpty {
            self.createTitleCell()
        }
        
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
    
    func createTitleCell() {
        self.CoinTableView.insert(CoinMC(id: "title", name: "", symbol: "", rank: "", price: 0, price_btc: 0, h24_volume_usd: 0, market_cap_usd: 0, available_supply: 0, total_supply: 0, percent_change_1h: 0, percent_change_24h: 0, percent_change_7d: 0, last_updated: ""), at: 0)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
