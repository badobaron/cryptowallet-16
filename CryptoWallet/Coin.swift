//
//  CoinList.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 01/08/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

class Coin {
    var Id: Int?
    var ImageUrl: String?
    var Name: String?
    var FullName: String?
    var BTC: Double?
    var EUR: Double?
    var USD: Double?
    var SortOrder: Int?
    var available_supply: Double?
    var total_supply: Double?
    var percent_change_1h: Double?
    var percent_change_24h: Double?
    var percent_change_7d: Double?
    var market_cap_eur: Double?
    var market_cap_usd: Double?
    var h24_volume_usd: Double?
    var h24_volume_eur: Double?
    
    init(Id: Int?, ImageUrl: String?, Name: String?, FullName: String?, BTC: Double?, EUR: Double?, USD: Double?, SortOrder: Int?, available_supply: Double?, total_supply: Double?, percent_change_1h: Double?, percent_change_24h: Double?, percent_change_7d: Double?, market_cap_eur: Double?, market_cap_usd: Double?, h24_volume_usd: Double?, h24_volume_eur: Double?) {
        self.Id = Id
        self.ImageUrl = ImageUrl
        self.Name = Name
        self.FullName = FullName
        self.BTC = BTC
        self.EUR = EUR
        self.USD = USD
        self.SortOrder = SortOrder
        self.available_supply = available_supply
        self.total_supply = total_supply
        self.percent_change_1h = percent_change_1h
        self.percent_change_24h = percent_change_24h
        self.percent_change_7d = percent_change_7d
        self.market_cap_eur = market_cap_eur
        self.market_cap_usd = market_cap_usd
        self.h24_volume_eur = h24_volume_eur
        self.h24_volume_usd = h24_volume_usd
    }
}
