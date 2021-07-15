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
            ContentView(db: AccountDatabase.mock())
        }
    }
}
