//
//  SidebarView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/07/12.
//

import SwiftUI

struct SidebarView: View {
    var db: AccountDatabase
    
    var body: some View {
        List {
            NavigationLink(destination: OverviewView(db: self.db)){
                Label("Overview", systemImage: "doc.text.magnifyingglass")
                    .font(.title3)
            }
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
        .frame(minWidth: 150)
        .listStyle(SidebarListStyle())
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct SidebarItem: View {
    let menuTitle: String
    let imageName: String
    
    var body: some View {
        Label(menuTitle, systemImage: imageName)
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(db: AccountDatabase.mock())
    }
}
