//
//  SetUpTransactionTableViewController.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 06/08/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

import UIKit

class SetUpTransactionTableViewController: UITableViewController {
    
    var datePicker = UIDatePicker()
    
    @IBOutlet weak var CurrencyLabel: UILabel!
    @IBOutlet weak var EditTextDate: UITextField!
    @IBOutlet weak var PickExchangeTitle: UIButton!
    @IBAction func PickExchange(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        alertController.addAction(cancelAction)
        
        let CoinBaseAction = UIAlertAction(title: "Coinbase", style: .default) { action in
            self.PickExchangeTitle.setTitle("Coinbase", for: .normal)
            self.PickExchangeTitle.titleLabel?.font = UIFont(name: "transaction", size: 12.0)
        }
        alertController.addAction(CoinBaseAction)
        
        let PoloniexAction = UIAlertAction(title: "Poloniex", style: .default) { action in
            self.PickExchangeTitle.setTitle("Poloniex", for: .normal)
            self.PickExchangeTitle.titleLabel?.font = UIFont(name: "transaction", size: 12.0)
        }
        alertController.addAction(PoloniexAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
    
    //  song object sent from the SearchTableViewController through the segue
    var FullName = String()
    
    // number of rows per section
    var rows: [Int] = [3, 2, 1]

    @IBOutlet weak var TradePriceTextField: UITextField!
    @IBAction func SaveTransactionButton(_ sender: UIBarButtonItem) {
        print(self.TradePriceTextField.text ?? "error")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CurrencyLabel.text = FullName
        
        //print("FullName = \(FullName)")
        //print("CurrencyLabel.text = \(CurrencyLabel.text)")
        
        createDatePicker()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func createDatePicker(){
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let confirmButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(confirmDate))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelDate))
        toolbar.setItems([cancelButton, confirmButton], animated: true)
        EditTextDate.inputAccessoryView = toolbar
        
        EditTextDate.inputView = datePicker
    }
    
    func confirmDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        EditTextDate.text = dateFormatter.string(from: datePicker.date)
        EditTextDate.endEditing(true)
    }
    
    func cancelDate(){
        EditTextDate.endEditing(true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows[section]
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
