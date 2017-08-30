//
//  imageManager.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 21/08/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, row: Int, CoinTable: [Coin], completion: @escaping ([Coin]?) -> Void) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            CoinTable[row].Image = image
            completion(CoinTable)
        }.resume()
    }
}
