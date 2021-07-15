//
//  ContentView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/11.
//

import SwiftUI

struct ContentView: View {
    var db: AccountDatabase
    
    var body: some View {
        NavigationView {
            SidebarView(db: db)
            OverviewView(db: db)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(db: AccountDatabase.mock())
    }
}
