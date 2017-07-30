//
//  CoinMarketCap.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 27/07/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CoinMarketCap: NSObject{
    
    class func getReturnTicker(completion: @escaping ([CoinMC]?, Bool) -> Void) {
        let url = "https://api.coinmarketcap.com/v1/ticker/?convert=EUR"
        var arrayCoin = [CoinMC]()
        DispatchQueue.global(qos: .userInteractive).async {
            Alamofire.request(url).validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    var arrayJsonCoin = [JSON]()
                    
                    for (_,subJson):(String, JSON) in json {
                        arrayJsonCoin.append(subJson)
                    }
                    
                    for coin in arrayJsonCoin{
                        arrayCoin.append(self.parseData(obj: coin))
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
    
    class func parseData(obj: JSON) -> CoinMC{
        return CoinMC(
            id : obj["id"].stringValue,
            name : obj["name"].stringValue,
            symbol : obj["symbol"].stringValue,
            rank : obj["rank"].stringValue,
            price : obj["price_eur"].floatValue,
            price_btc : obj["price_btc"].floatValue,
            h24_volume_usd : obj["24h_volume_usd"].floatValue,
            market_cap_usd : obj["market_cap_usd"].floatValue,
            available_supply : obj["available_supply"].floatValue,
            total_supply : obj["total_supply"].floatValue,
            percent_change_1h : obj["percent_change_1h"].floatValue,
            percent_change_24h : obj["percent_change_24h"].floatValue,
            percent_change_7d : obj["percent_change_7d"].floatValue,
            last_updated : obj["last_updated"].stringValue
        )
    }

}
