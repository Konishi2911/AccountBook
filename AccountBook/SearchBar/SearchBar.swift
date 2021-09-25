//
//  SearchBar.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/23.
//

import Foundation
import SwiftUI

struct SearchBar: NSViewRepresentable {
    typealias NSViewType = NSSearchField
    class Coordinator: NSObject, NSSearchFieldDelegate {
        let parent: SearchBar
        
        init(_ parent: SearchBar) {
            self.parent = parent
        }
        
        func controlTextDidChange(_ obj: Notification) {
            guard let searchField = obj.object as? NSSearchField else {
                return
            }
            self.parent.text = searchField.stringValue
        }
    }
    
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateNSView(_ nsView: NSSearchField, context: Context) {
        nsView.stringValue = text
        nsView.delegate = context.coordinator
    }
    
    func makeNSView(context: Context) -> NSSearchField {
        let searchBar = NSSearchField(frame: .zero)
        return searchBar
    }
}
