//
//  MyPortfolioViewController.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 06/08/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

import UIKit

class MyPortfolioViewController: UIViewController {
    
    @IBOutlet weak var CurrentPortfollioValueLabel: UILabel!
    @IBOutlet weak var TitleCurrentPortfolioValueLabel: UILabel!
    @IBOutlet weak var TotalCostLabel: UILabel!
    @IBOutlet weak var TitleTotalCoestLabel: UILabel!
    @IBOutlet weak var TotalProfitLabel: UILabel!
    @IBOutlet weak var TitleTotalProfitLabel: UILabel!
    @IBOutlet weak var TotalPercentageProfitLabel: UILabel!
    @IBOutlet weak var TitleTotalPercentageProfitLabel: UILabel!
    @IBOutlet weak var MyCoinsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TitleTotalCoestLabel.text = "TOTAL COST"
        TitleTotalProfitLabel.text = "TOTAL PROFIT"
        TitleCurrentPortfolioValueLabel.text = "CURRENT PORTFOLIO VALUE"
        TitleTotalPercentageProfitLabel.text = "TOTAL % PROFIT"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
