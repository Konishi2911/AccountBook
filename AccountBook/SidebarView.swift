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
            NavigationLink(destination: HighlightsView(db: db)){
                Label("Highlights", systemImage: "lightbulb")
                    .font(.title3)
            }
            NavigationLink(destination: BookView(db: db)){
                Label("Book", systemImage: "text.book.closed")
                    .font(.title3)
            }
            NavigationLink(destination: StatisticsView()){
                Label("Statistics", systemImage: "chart.bar.xaxis")
                    .font(.title3)
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
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
