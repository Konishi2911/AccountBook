//
//  AccountBookApp.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import SwiftUI

@main
struct AccountBookApp: App {
    var body: some Scene {
        WindowGroup {
            let db = try! loadOldDB()
            ContentView(db: db)
        }
    }
    
    func loadOldDB() throws -> AccountDatabase {
        let url = URL(fileURLWithPath: "/Users/koheikonishi/Downloads/transactionTable_bak.bmt")
        let data = try Data(contentsOf: url)
        
        
        return try AccountDatabase(fromBMT: url)
    }
}
