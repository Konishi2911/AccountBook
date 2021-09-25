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
            let db = loadOldDB() ?? AccountDatabase.mock()
            ContentView(db: db)
        }
        .windowStyle(TitleBarWindowStyle())
        .windowToolbarStyle(DefaultWindowToolbarStyle())
    }
    
    func loadOldDB() -> AccountDatabase? {                
        do {
            let urlBMT = try FileManager.default.url(
                for: .applicationSupportDirectory, in: .userDomainMask,
                appropriateFor: nil, create: false
            ).appendingPathComponent("transactionTable_bak.bmt")
            
            let url = try FileManager.default.url(
                for: .applicationSupportDirectory, in: .userDomainMask,
                appropriateFor: nil, create: false
            ).appendingPathComponent("AccountSource.act")
        
            guard let db = try? AccountDatabase(from: url) else {
                let tmp = try AccountDatabase(fromBMT: urlBMT)
                tmp.setURL(url: url)
                return tmp
            }
            return db
            
        } catch {
            return nil
        }
    }
}
