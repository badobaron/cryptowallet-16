//
//  CoinMarketCap.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 02/08/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CoinMarketCap: NSObject{
    
    class func getReturnTicker(completion: @escaping ([Coin]?, Bool) -> Void) {
        let url = "https://api.coinmarketcap.com/v1/ticker/?convert=EUR"
        var arrayCoin = [Coin]()
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
    
    class func parseData(obj: JSON) -> Coin{
        return Coin(
            Id : nil,
            ImageUrl : nil,
            Name : obj["symbol"].stringValue,
            FullName : obj["name"].stringValue,
            BTC : Double(obj["price_btc"].stringValue),
            EUR : Double(obj["price_eur"].stringValue),
            USD : Double(obj["price_usd"].stringValue),
            SortOrder: nil,
            available_supply : Double(obj["available_supply"].stringValue),
            total_supply : Double(obj["total_supply"].stringValue),
            percent_change_1h : Double(obj["percent_change_1h"].stringValue),
            percent_change_24h : Double(obj["percent_change_24h"].stringValue),
            percent_change_7d : Double(obj["percent_change_7d"].stringValue),
            market_cap_eur : Double(obj["market_cap_eur"].stringValue),
            market_cap_usd : Double(obj["market_cap_usd"].stringValue),
            h24_volume_usd : Double(obj["24h_volume_usd"].stringValue),
            h24_volume_eur : Double(obj["24h_volume_eur"].stringValue)
        )
    }
    
}
