//
//  OverviewView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/13.
//

import SwiftUI

struct OverviewView: View {
    var db: AccountDatabase
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Overview").bold().font(.largeTitle).padding()
            HistoryView(db: self.db)
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView(db: AccountDatabase.mock())
    }
}
