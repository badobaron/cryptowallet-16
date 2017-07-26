//
//  Poloniex.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 23/07/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class poloniex: NSObject{
    
    
    class func getReturnTicker(completion: @escaping ([Coin]?, Bool) -> Void) {
        let baseUrl = "https://poloniex.com/public?command="
        let url = baseUrl + "returnTicker"
        var arrayCoin = [Coin]()
        DispatchQueue.global(qos: .userInteractive).async {
            Alamofire.request(url).validate().responseJSON { (response) in
                print(response.result)
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    // get all currencies
                    var arrayJsonCoin = [(JSON, String)]()
                    arrayJsonCoin.append((json["BTC_BCN"],"BTC_BCN"))
                    arrayJsonCoin.append((json["BTC_BELA"],"BTC_BELA"))
                    arrayJsonCoin.append((json["BTC_BLK"],"BTC_BLK"))
                    arrayJsonCoin.append((json["BTC_BTCD"],"BTC_BTCD"))
                    arrayJsonCoin.append((json["BTC_BTM"],"BTC_BTM"))
                    arrayJsonCoin.append((json["BTC_BTS"],"BTC_BTS"))
                    arrayJsonCoin.append((json["BTC_BURST"],"BTC_BURST"))
                    arrayJsonCoin.append((json["BTC_CLAM"],"BTC_CLAM"))
                    arrayJsonCoin.append((json["BTC_DASH"],"BTC_DASH"))
                    arrayJsonCoin.append((json["BTC_DGB"],"BTC_DGB"))
                    arrayJsonCoin.append((json["BTC_DOGE"],"BTC_DOGE"))
                    arrayJsonCoin.append((json["BTC_EMC2"],"BTC_EMC2"))
                    arrayJsonCoin.append((json["BTC_FLDC"],"BTC_FLDC"))
                    arrayJsonCoin.append((json["BTC_FLO"],"BTC_FLO"))
                    arrayJsonCoin.append((json["BTC_GAME"],"BTC_GAME"))
                    arrayJsonCoin.append((json["BTC_GRC"],"BTC_GRC"))
                    arrayJsonCoin.append((json["BTC_HUC"],"BTC_HUC"))
                    arrayJsonCoin.append((json["BTC_LTC"],"BTC_LTC"))
                    arrayJsonCoin.append((json["BTC_MAID"],"BTC_MAID"))
                    arrayJsonCoin.append((json["BTC_OMNI"],"BTC_OMNI"))
                    arrayJsonCoin.append((json["BTC_NAUT"],"BTC_NAUT"))
                    arrayJsonCoin.append((json["BTC_NAV"],"BTC_NAV"))
                    arrayJsonCoin.append((json["BTC_NEOS"],"BTC_NEOS"))
                    arrayJsonCoin.append((json["BTC_NMC"],"BTC_NMC"))
                    arrayJsonCoin.append((json["BTC_NOTE"],"BTC_NOTE"))
                    arrayJsonCoin.append((json["BTC_NXT"],"BTC_NXT"))
                    arrayJsonCoin.append((json["BTC_PINK"],"BTC_PINK"))
                    arrayJsonCoin.append((json["BTC_POT"],"BTC_POT"))
                    arrayJsonCoin.append((json["BTC_PPC"],"BTC_PPC"))
                    arrayJsonCoin.append((json["BTC_RIC"],"BTC_RIC"))
                    arrayJsonCoin.append((json["BTC_SJCX"],"BTC_SJCX"))
                    arrayJsonCoin.append((json["BTC_STR"],"BTC_STR"))
                    arrayJsonCoin.append((json["BTC_SYS"],"BTC_SYS"))
                    arrayJsonCoin.append((json["BTC_VIA"],"BTC_VIA"))
                    arrayJsonCoin.append((json["BTC_XVC"],"BTC_XVC"))
                    arrayJsonCoin.append((json["BTC_VRC"],"BTC_VRC"))
                    arrayJsonCoin.append((json["BTC_VTC"],"BTC_VTC"))
                    arrayJsonCoin.append((json["BTC_XBC"],"BTC_XBC"))
                    arrayJsonCoin.append((json["BTC_XCP"],"BTC_XCP"))
                    arrayJsonCoin.append((json["BTC_XEM"],"BTC_XEM"))
                    arrayJsonCoin.append((json["BTC_XMR"],"BTC_XMR"))
                    arrayJsonCoin.append((json["BTC_XPM"],"BTC_XPM"))
                    arrayJsonCoin.append((json["BTC_XRP"],"BTC_XRP"))
                    arrayJsonCoin.append((json["USDT_BTC"],"USDT_BTC"))
                    arrayJsonCoin.append((json["USDT_DASH"],"USDT_DASH"))
                    arrayJsonCoin.append((json["USDT_LTC"],"USDT_LTC"))
                    arrayJsonCoin.append((json["USDT_NXT"],"USDT_NXT"))
                    arrayJsonCoin.append((json["USDT_STR"],"USDT_STR"))
                    arrayJsonCoin.append((json["USDT_XMR"],"USDT_XMR"))
                    arrayJsonCoin.append((json["USDT_XRP"],"USDT_XRP"))
                    arrayJsonCoin.append((json["XMR_BCN"],"XMR_BCN"))
                    arrayJsonCoin.append((json["XMR_BLK"],"XMR_BLK"))
                    arrayJsonCoin.append((json["XMR_BTCD"],"XMR_BTCD"))
                    arrayJsonCoin.append((json["XMR_DASH"],"XMR_DASH"))
                    arrayJsonCoin.append((json["XMR_LTC"],"XMR_LTC"))
                    arrayJsonCoin.append((json["XMR_MAID"],"XMR_MAID"))
                    arrayJsonCoin.append((json["XMR_NXT"],"XMR_NXT"))
                    arrayJsonCoin.append((json["BTC_ETH"],"BTC_ETH"))
                    arrayJsonCoin.append((json["USDT_ETH"],"USDT_ETH"))
                    arrayJsonCoin.append((json["BTC_SC"],"BTC_SC"))
                    arrayJsonCoin.append((json["BTC_BCY"],"BTC_BCY"))
                    arrayJsonCoin.append((json["BTC_EXP"],"BTC_EXP"))
                    arrayJsonCoin.append((json["BTC_FCT"],"BTC_FCT"))
                    arrayJsonCoin.append((json["BTC_RADS"],"BTC_RADS"))
                    arrayJsonCoin.append((json["BTC_AMP"],"BTC_AMP"))
                    arrayJsonCoin.append((json["BTC_DCR"],"BTC_DCR"))
                    arrayJsonCoin.append((json["BTC_LSK"],"BTC_LSK"))
                    arrayJsonCoin.append((json["ETH_LSK"],"ETH_LSK"))
                    arrayJsonCoin.append((json["BTC_LBC"],"BTC_LBC"))
                    arrayJsonCoin.append((json["BTC_STEEM"],"BTC_STEEM"))
                    arrayJsonCoin.append((json["ETH_STEEM"],"ETH_STEEM"))
                    arrayJsonCoin.append((json["BTC_SBD"],"BTC_SBD"))
                    arrayJsonCoin.append((json["BTC_ETC"],"BTC_ETC"))
                    arrayJsonCoin.append((json["ETH_ETC"],"ETH_ETC"))
                    arrayJsonCoin.append((json["USDT_ETC"],"USDT_ETC"))
                    arrayJsonCoin.append((json["BTC_REP"],"BTC_REP"))
                    arrayJsonCoin.append((json["USDT_REP"],"USDT_REP"))
                    arrayJsonCoin.append((json["ETH_REP"],"ETH_REP"))
                    arrayJsonCoin.append((json["BTC_ARDR"],"BTC_ARDR"))
                    arrayJsonCoin.append((json["BTC_ZEC"],"BTC_ZEC"))
                    arrayJsonCoin.append((json["ETH_ZEC"],"ETH_ZEC"))
                    arrayJsonCoin.append((json["USDT_ZEC"],"USDT_ZEC"))
                    arrayJsonCoin.append((json["XMR_ZEC"],"XMR_ZEC"))
                    arrayJsonCoin.append((json["BTC_STRAT"],"BTC_STRAT"))
                    arrayJsonCoin.append((json["BTC_NXC"],"BTC_NXC"))
                    arrayJsonCoin.append((json["BTC_PASC"],"BTC_PASC"))
                    arrayJsonCoin.append((json["BTC_GNT"],"BTC_GNT"))
                    arrayJsonCoin.append((json["ETH_GNT"],"ETH_GNT"))
                    arrayJsonCoin.append((json["BTC_GNO"],"BTC_GNO"))
                    arrayJsonCoin.append((json["ETH_GNO"],"ETH_GNO"))
                    
                    for coin in arrayJsonCoin{
                        arrayCoin.append(self.parseData(obj: coin.0, name: coin.1))
                    }
                    
                    completion(arrayCoin, response.result.isSuccess)
                    
                //return nil
                case .failure(let error):
                    
                    print("erreur = \(error)")
                    completion(nil,  response.result.isSuccess)
                }
            }
        }
    }
    
    class func parseData(obj: JSON, name: String) -> Coin{
        return Coin(
            name: name,
            percentChange: obj["percentChange"].stringValue,
            value: obj["last"].stringValue
        )
    }

}
