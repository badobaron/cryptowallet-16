  //
//  CryptoCompare.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 01/08/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

 import Foundation
 import Alamofire
 import SwiftyJSON
 
 class CryptoCompare: NSObject{
    
    enum Data: String {
        case CoinList = "https://www.cryptocompare.com/api/data/coinlist/"
        case Price = "https://min-api.cryptocompare.com/data/pricemultifull?"
        case PriceHistorical = "https://min-api.cryptocompare.com/data/pricehistorical?"
        case SocialStats = "https://www.cryptocompare.com/api/data/socialstats/?id="
        case HistoMinute = "https://min-api.cryptocompare.com/data/histominute?"
        case HistoHour = "https://min-api.cryptocompare.com/data/histohour?"
        case HistoDay = "https://min-api.cryptocompare.com/data/histoday?"
    }
    
    class func getUrlImage(ListCoin: [Coin], completion: @escaping ([Coin]?, Bool) -> Void) {
        let url:String = Data.CoinList.rawValue
        
        DispatchQueue.global(qos: .userInteractive).async {
            Alamofire.request(url).validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    let data = json["Data"]
                    var arrayJsonCoin = [JSON]()
                    
                    for (_,subJson):(String, JSON) in data {
                        arrayJsonCoin.append(subJson)
                    }
                    
                    var found = false
                    for item2 in ListCoin {
                        for item in arrayJsonCoin {
                            if item["Name"].stringValue == item2.Name {
                                item2.ImageUrl = "https://www.cryptocompare.com" + item["ImageUrl"].stringValue
                                found = true
                                break
                            }
                        }
                        if !found {
                            item2.Image = UIImage(named: "DefaultCoin")
                        }
                        found = false
                    }
                    
                    completion(ListCoin, response.result.isSuccess)
                    
                case .failure(let error):
                    
                    print("erreur = \(error)")
                    completion(nil,  response.result.isFailure)
                }
            }
        }
    }
    
    class func parseDatagetCoinList(obj: JSON) -> Coin{
        return Coin(
            Rank : obj["Id"].intValue,
            Image: nil,
            ImageUrl : obj["ImageUrl"].stringValue,
            Name : obj["Name"].stringValue,
            FullName : obj["FullName"].stringValue,
            EUR : nil,
            USD : nil,
            available_supply: nil,
            total_supply : nil,
            percent_change_1h : nil,
            percent_change_24h : nil,
            percent_change_7d : nil,
            market_cap_eur: nil,
            market_cap_usd: nil,
            h24_volume_usd: nil,
            h24_volume_eur: nil
            
            
            
        )
    }
    
    /*class func getCoinPrice(fsym: String ,tsyms: [String] ,completion: @escaping (Coin?, Bool) -> Void) {
        var url:String = Data.Price.rawValue
        url += "fsyms=" + fsym + "&tsyms="
        for i in 0 ..< tsyms.count  {
            if i == (tsyms.count - 1) {
                url += tsyms[i]
            } else {
                url += tsyms[i] + ","
            }
        }

        DispatchQueue.global(qos: .userInteractive).async {
            Alamofire.request(url).validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    let eur = json["RAW"][fsym][tsyms]["PRICE"].doubleValue
                    let h24 = json["RAW"][fsym][tsyms]["CHANGEPCT24HOUR"].doubleValue
                    let coin = Coin(Id: nil,
                                    ImageUrl: "",
                                    Name: "title",
                                    FullName: "",
                                    BTC: nil,
                                    EUR: eur,
                                    USD: nil,
                                    SortOrder: nil,
                                    available_supply: nil,
                                    total_supply : nil,
                                    percent_change_1h : nil,
                                    percent_change_24h : h24,
                                    percent_change_7d : nil,
                                    market_cap_eur: nil,
                                    market_cap_usd: nil,
                                    h24_volume_usd: nil,
                                    h24_volume_eur: nil
                    )
                    
                    // The order we rank the coin inside our internal system
                    completion(coin , response.result.isSuccess)
                    
                //return nil
                case .failure(let error):
                    
                    print("erreur = \(error)")
                    completion(nil,  response.result.isSuccess)
                }
            }
        }
    }*/
}
