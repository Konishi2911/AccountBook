//
//  BookView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/20.
//

import SwiftUI

struct BookView: View {
    @ObservedObject private var model_: BookItemModel
    @State private var searchStr_: String = ""
    
    init(db: AccountDatabase) {
        self.model_ = .init(ref: db)
    }
    var body: some View {
        NavigationView {
            List {
                ForEach (self.model_.items) { item in
                    NavigationLink(
                        destination: self.accountDetailView_(recID: item.id),
                        tag: item.id,
                        selection: self.$model_.selected
                    ) {
                        BookItemView(item: item)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: { self.model_.createNewRecord() }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
    }
    
    func accountDetailView_(recID: UUID) -> some View {
        VStack {
            AccountDetailView(recordID: recID, ref: self.model_.db)
                .padding([.trailing])
            Spacer()
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(db: .mock())
    }
}
