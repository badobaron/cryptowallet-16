//
//  DataManager.swift
//  CryptoWallet
//
//  Created by Romain Brunie on 23/07/2017.
//  Copyright © 2017 Romain Brunie. All rights reserved.
//

import Foundation
import CoreData

class DataManager : NSObject {
    
    public static let shared = DataManager()
    
    public var objectContext: NSManagedObjectContext? = nil
    
    public override init() {
        // recuperer dun url dun fichier dans un bundle (bundle main)
        if let modelURL = Bundle.main.url(forResource: "CryptoWallet", withExtension: "momd") {
            if let model = NSManagedObjectModel(contentsOf: modelURL) {
                
                if let storageURL = FileManager.documentURL(childPath: "MyDatabase.db") {
                    let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                    _ = try? storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storageURL, options: nil)
                    
                    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    context.persistentStoreCoordinator = storeCoordinator
                    self.objectContext = context
                }
                
            }
            
        }
        
    }
    
}
