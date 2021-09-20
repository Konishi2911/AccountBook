//
//  BookView.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/20.
//

import SwiftUI

struct BookView: View {
    let db_: AccountDatabase
    @State private var searchStr_: String = ""
    
    init(db: AccountDatabase) {
        self.db_ = db
    }
    var body: some View {
        NavigationView {
            List {
                ForEach (self.source_()) { item in
                    NavigationLink(destination: self.accountDetailView_(recID: item.id)) {
                        BookItemView(item: item)
                    }
                }
            }
        }
    }
    
    func accountDetailView_(recID: UUID) -> some View {
        VStack {
            AccountDetailView(ref: self.db_)
                .padding([.trailing])
            Spacer()
        }
    }
    
    private func source_() -> [BookItem] {
        let records = self.db_.getRecords()
        return records.map { BookItem(from: $0) }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(db: .mock())
    }
}
