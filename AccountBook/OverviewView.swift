//
//  OverviewView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/13.
//

import SwiftUI

struct OverviewView: View {
    @State private var showingDialog = false
    
    var db: AccountDatabase
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Overview").bold().font(.largeTitle).padding()
            HistoryView(db: self.db)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: { self.showingDialog.toggle() } ) {
                    Image(systemName: "plus")
                }
                .popover(isPresented: self.$showingDialog) {
                    AccountEntryDialog(isShowing: self.$showingDialog)
                }
            }
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView(db: AccountDatabase.mock())
    }
}
