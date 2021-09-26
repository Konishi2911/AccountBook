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
    @State private var isShowingFilterView: Bool = false
    
    init(db: AccountDatabase) {
        self.model_ = .init(ref: db)
    }
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    ForEach (self.model_.items) { item in
                        NavigationLink(
                            destination: self.accountDetailView_(recID: item.id),
                            tag: item.id,
                            selection: self.$model_.selected
                        ) {
                            BookItemView(item: item)
                        }
                        .id(item.id)
                    }
                    .onDelete(perform: { indexSet in
                        self.model_.deleteRecord(indexSet)
                    })
                }
                .frame(idealWidth: 250)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        HStack {
                            SearchBar(text: self.$searchStr_)
                                .frame(minWidth: 100, idealWidth: 200, maxWidth: .infinity)
                        }
                    }
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            self.createNewItem_(proxy)
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                }
            }
            Text("No Items Selected")
                .font(.title)
                .foregroundColor(.gray)
        }
        .navigationTitle("History")
        .navigationSubtitle(self.model_.items.count.description + " records")
    }
    
    func accountDetailView_(recID: UUID) -> some View {
        VStack {
            AccountDetailView(recordID: recID, ref: self.model_.db)
                .padding([.trailing])
            Spacer()
        }
    }
    
    private func createNewItem_(_ proxy: ScrollViewProxy) {
        let id = self.model_.createNewRecord()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            withAnimation {
                proxy.scrollTo(id, anchor: .center)
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(db: .mock())
    }
}
