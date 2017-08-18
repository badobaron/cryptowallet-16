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
import CoreData

class CoinListTableViewController: UITableViewController, UISearchBarDelegate {
    
    public var CoinTableView = [Any?]()
    public var currentTableView = [Any?]()
    public var searchController : UISearchController!
    var sharedInstance = TWMessageBarManager()
    let managedContext = DataManager().objectContext
    var Song = [NSManagedObject]()
    
    //  activity indicator view
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  creating activity indicator view
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        
        // I init here the reloading system of the table view
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // completion to get the result from the CoinMarketCap api request
            CoinMarketCap.getReturnTicker{coinArray, connect in
                if connect{
                    self?.CoinTableView = coinArray!
                    //self?.saveToCoreData(coinArray: self?.CoinTableView as! [Coin])
                    //self?.fetchCoreData()
                    self?.createTitleCell()
                    self?.currentTableView = self?.CoinTableView as! [Coin]
                    self?.tableView.reloadData()
                    self?.tableView.dg_stopLoading()
                }else{
                    self?.sharedInstance.showMessage(withTitle: "No internet connection", description: "Previous data displayed", type: TWMessageBarMessageType.error)
                    // TODO CoreData here
                    self?.tableView.dg_stopLoading()
                }

            }        }, loadingView: loadingView)
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
        
        //  The search to the spotify api starts here, so I display the activity indicator
        startAnimation()
        
        // completion to get the result from the poloniex api request
        CoinMarketCap.getReturnTicker{coinArray, connect in
            if connect{
                self.sharedInstance.showMessage(withTitle: "Data updated", description: "Connected to Internet", type: TWMessageBarMessageType.success)
                self.CoinTableView = coinArray!
                //self.saveToCoreData(coinArray: self.CoinTableView as! [Coin])
                //self.fetchCoreData()
                // get price from each currency
                //for item in self.CoinTableView as! [Coin]{
                    //print("item name = \(item.Name)")
                    /*CryptoCompare.getCoinPrice(fsym: item.Name!, tsyms: ["EUR"]){coin, connect in
                        if connect{
                            
                            if (coin?.EUR) != nil && (coin?.percent_change_24h) != nil {
                                print("coin = \(String(describing: coin?.EUR!))")
                                item.EUR = coin?.EUR!
                                item.percent_change_24h = coin?.percent_change_24h!
                            }
                            
                            self.tableView.reloadData()
                        }
                    }*/
                //}
                
                // here i add a new coin that represents the title cell
                self.createTitleCell()
                self.currentTableView = self.CoinTableView as! [Coin]
                self.stopAnimation()
                self.tableView.reloadData()
            }else{
                self.sharedInstance.showMessage(withTitle: "Data Not updated", description: "No internet connection", type: TWMessageBarMessageType.error)
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
    
    /*func clearCoreData(){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Coins")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
    }*/
    
    func saveToCoreData(coinArray: [Coin]){
        print("count coinArray = \(coinArray.count)")

        let entity =  NSEntityDescription.entity(forEntityName: "Coins", in:self.managedContext!)
        let coins = NSManagedObject(entity: entity!, insertInto: self.managedContext)
        
        for coin in coinArray {
            coins.setValue(coin.Id, forKey: "id")
            coins.setValue(coin.ImageUrl, forKey: "imageUrl")
            coins.setValue(coin.Name, forKey: "name")
            coins.setValue(coin.FullName, forKey: "fullName")
            coins.setValue(coin.BTC, forKey: "btc")
            coins.setValue(coin.EUR, forKey: "eur")
            coins.setValue(coin.USD, forKey: "usd")
            coins.setValue(coin.SortOrder, forKey: "sortOrder")
            coins.setValue(coin.available_supply, forKey: "availableSupply")
            coins.setValue(coin.total_supply, forKey: "totalSupply")
            coins.setValue(coin.percent_change_1h, forKey: "percentChange1h")
            coins.setValue(coin.percent_change_24h, forKey: "percentChange24h")
            coins.setValue(coin.percent_change_7d, forKey: "percentChange7d")
            coins.setValue(coin.market_cap_eur, forKey: "marketCapEur")
            coins.setValue(coin.market_cap_usd, forKey: "marketCapUsd")
            coins.setValue(coin.h24_volume_usd, forKey: "h24VolumeUsd")
            coins.setValue(coin.h24_volume_eur, forKey: "h24VolumeEur")
            
            do {
                try self.managedContext?.save()
                print("self.managedContext?.save = \(coins)")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func fetchCoreData(){
        // fetching all the songs from CoreData
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Coins")
        
        do {
            let songs = try managedContext?.fetch(fetchRequest)
            Song = songs as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("1")
        print("countSong = \(Song.count)")

        for coin in Song{
            CoinTableView.removeAll()
            CoinTableView.append(Coin(
                Id: coin.value(forKey: "id") as? Int,
                ImageUrl: coin.value(forKey: "imageUrl") as? String,
                Name: coin.value(forKey: "name") as? String,
                FullName: coin.value(forKey: "fullName") as? String,
                BTC: coin.value(forKey: "btc") as? Double,
                EUR: coin.value(forKey: "eur") as? Double,
                USD: coin.value(forKey: "usd") as? Double,
                SortOrder: coin.value(forKey: "sortOrder") as? Int,
                available_supply: coin.value(forKey: "availableSupply") as? Double,
                total_supply: coin.value(forKey: "totalSupply") as? Double,
                percent_change_1h: coin.value(forKey: "percentChange1h") as? Double,
                percent_change_24h: coin.value(forKey: "percentChange24h") as? Double,
                percent_change_7d: coin.value(forKey: "percentChange7d") as? Double,
                market_cap_eur: coin.value(forKey: "marketCapEur") as? Double,
                market_cap_usd: coin.value(forKey: "h24VolumeUsd") as? Double,
                h24_volume_usd: coin.value(forKey: "h24VolumeUsd") as? Double,
                h24_volume_eur: coin.value(forKey: "h24VolumeEur") as? Double
            ))
        }
        print("count = \(CoinTableView.count)")
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if CoinTableView[indexPath.row] != nil {
            return 50
        } else {
            return 153
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Row is DefaultCell
        if (CoinTableView[indexPath.row] as? Coin) != nil {
            if (CoinTableView[indexPath.row] as! Coin).Name == "title" {
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
                let marketCap = expansionCell.viewWithTag(10) as! UILabel
                marketCap.text = tranformNumber(number: (CoinTableView[parentCellIndex] as! Coin).market_cap_eur!)
                
                let circulatingSupply = expansionCell.viewWithTag(11) as! UILabel
                //print("circulatingSupply = \((CoinTableView[parentCellIndex] as! Coin).available_supply!)")
                circulatingSupply.text = tranformNumber(number: (CoinTableView[parentCellIndex] as! Coin).available_supply!)
                
                let volume24h = expansionCell.viewWithTag(12) as! UILabel
                volume24h.text = tranformNumber(number: (CoinTableView[parentCellIndex] as! Coin).h24_volume_eur!)
                
                let h1 = expansionCell.viewWithTag(13) as! UILabel
                h1.text = tranformNumber(number: (CoinTableView[parentCellIndex] as! Coin).percent_change_1h!)
                h1.text?.append("%")
                
                
                let d7 = expansionCell.viewWithTag(14) as! UILabel
                d7.text = tranformNumber(number: (CoinTableView[parentCellIndex] as! Coin).percent_change_7d!)
                d7.text?.append("%")
                
                let h24 = expansionCell.viewWithTag(15) as! UILabel
                h24.text = tranformNumber(number: (CoinTableView[parentCellIndex] as! Coin).percent_change_24h!)
                h24.text?.append("%")
                
                if d7.text?.characters.first == "-"{
                    d7.textColor = UIColor.red
                } else {
                    d7.textColor = UIColor.green
                }
                
                if h1.text?.characters.first == "-"{
                    h1.textColor = UIColor.red
                } else {
                    h1.textColor = UIColor.green
                }
                
                if h24.text?.characters.first == "-"{
                    h24.textColor = UIColor.red
                } else {
                    h24.textColor = UIColor.green
                }
                
                return expansionCell
            } else {
                return UITableViewCell()
            }
        }
    }
    
        
    /*  Get parent cell for selected ExpansionCell  */
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: Coin?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 1) {
            selectedCellIndex -= 1
            selectedCell = CoinTableView[selectedCellIndex] as? Coin
        }
        
        return selectedCellIndex
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        // tag 1 is the coin name in the table view cell
        let coinName = cell.viewWithTag(1) as! UILabel
        coinName.text = (CoinTableView[indexPath.row] as? Coin)?.FullName
        //print("coinName = \(String(describing: coinName.text))")
        
        // tag 2 is price of the coin in the table view cell
        let priceCoin = cell.viewWithTag(4) as! UILabel
        if (CoinTableView[indexPath.row] as? Coin)?.EUR != nil {
            priceCoin.text = tranformNumber(number: (CoinTableView[indexPath.row] as! Coin).EUR!)
            
        }
        priceCoin.text?.append("€")
        print("priceCoin.text = \(String(describing: priceCoin.text))")
        // tag 3 is the 24h change in the table view cell
        let h24Change = cell.viewWithTag(3) as! UILabel
        if (CoinTableView[indexPath.row] as? Coin)?.percent_change_24h != nil {
            h24Change.text = tranformNumber(number: (CoinTableView[indexPath.row] as! Coin).percent_change_24h!)
        }
        //print("h24Change = \(String(describing: h24Change.text))")
        h24Change.text?.append("%")
        
        // TODO : add image
        // tag 1 is the coin name in the table view cell
        //var coinImage = cell.viewWithTag(8) as! UIImage
        //coinImage.imageView.image = UIImage(named: (CoinTableView[indexPath.row] as! Coin).ImageUrl)
        
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
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.white
        selectedCell.selectionStyle = .none
        //selectedCell.layer.borderWidth = 1.0
        //selectedCell.layer.borderColor = UIColor.lightGray.cgColor
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
            if ((coin as! Coin).FullName?.uppercased().range(of: searchController.searchBar.text!.uppercased()) != nil) {
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
        self.CoinTableView.insert(Coin(Id: nil, ImageUrl: "", Name: "title", FullName: "", BTC: nil, EUR: nil, USD: nil, SortOrder: nil, available_supply: nil, total_supply: nil, percent_change_1h: nil, percent_change_24h: nil, percent_change_7d: nil, market_cap_eur: nil, market_cap_usd: nil, h24_volume_usd: nil, h24_volume_eur: nil ), at: 0)
    }
    
    func tranformNumber(number: Double) -> String{
        var newString = String(number)
        let res = String(number).range(of: ".")
        print("number = \(String(describing: number))")
        if let range = res {
            
            // Start of range of found string.
            let start = range.lowerBound
            let length = String(number)[String(number).startIndex..<start].characters.count
            print("length = \(length)")
            
            // Display string starting at first index.
            print(String(number)[start..<String(number).endIndex])
            //print(String(number).startIndex)
            var j = 0
            var sumup = String(number).startIndex
            var keepLooping = true
            var broken = false
            // Display string before first index.
            print(String(number)[String(number).startIndex..<start])
            if String(number)[String(number).startIndex..<start].characters.count > 3{
                if String(number)[String(number).startIndex..<start].characters.count % 3 == 0{
                    // number has 3 digits
                    print("3 digits = \(String(number)[String(number).startIndex..<start].characters)")
                }else{
                    // number has more than 3 digits
                    while keepLooping {
                        for i in String(number).characters.indices[sumup..<start]
                        {
                            print("res : \((length - j)%3) + i : \(i)")
                            print("at : \(newString[i])")
                            if (length - j)%(3) == 0 {
                                newString.insert(",", at: i)
                                sumup = i
                                broken = true
                                break
                            }else{
                                broken = false
                            }
                            j += 1
                            sumup = i
                            broken = false
                        }
                        if broken  {
                            keepLooping = false
                        }
                        
                    }
                    
                    
                    
                }
            }
        }
        return newString
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
