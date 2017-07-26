//
//  Coin.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 22/07/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//


class Coin {
    var name: String
    var percentChange: String
    var value: String
    
    init(name: String, percentChange: String, value: String) {
        self.name = name
        self.percentChange = percentChange
        self.value = value
    }
}
