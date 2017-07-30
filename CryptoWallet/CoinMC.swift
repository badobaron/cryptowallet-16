//
//  CoinMC.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 27/07/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

class CoinMC {
    var id: String
    var name: String
    var symbol: String
    var rank: String
    var price: Float
    var price_btc: Float
    var h24_volume_usd: Float
    var market_cap_usd: Float
    var available_supply: Float
    var total_supply: Float
    var percent_change_1h: Float
    var percent_change_24h: Float
    var percent_change_7d: Float
    var last_updated: String
    
    init(id: String, name: String, symbol: String, rank: String, price: Float, price_btc: Float, h24_volume_usd: Float, market_cap_usd: Float, available_supply: Float, total_supply: Float, percent_change_1h: Float, percent_change_24h: Float, percent_change_7d: Float, last_updated: String) {
            self.id = id
            self.name = name
            self.symbol = symbol
            self.rank = rank
            self.price = price
            self.price_btc = price_btc
            self.h24_volume_usd = h24_volume_usd
            self.market_cap_usd = market_cap_usd
            self.available_supply = available_supply
            self.total_supply = total_supply
            self.percent_change_1h = percent_change_1h
            self.percent_change_7d = percent_change_7d
            self.percent_change_24h = percent_change_24h
            self.last_updated = last_updated
    }
}
