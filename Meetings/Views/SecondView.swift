//
//  SecondView.swift
//  Meetings
//
//  Created by Yu on 2022/09/20.
//

import SwiftUI

struct SecondView: View {
    
    // States
    @State private var keyword = ""
    @State private var isSubmited = false
    
    var body: some View {
        NavigationView {
            SearchList(keyword: $keyword, isSubmited: $isSubmited)
            
                .searchable(text: $keyword, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("keyword"))
                .onSubmit(of: .search) {
                    isSubmited = true
                    
                    // 検索した単語を検索履歴に保存
                    var searchedWords = UserDefaults.standard.stringArray(forKey: "searchedWords") ?? []
                    searchedWords.insert(keyword, at: 0)
                    searchedWords = NSOrderedSet(array: searchedWords).array as! [String]
                    UserDefaults.standard.set(searchedWords, forKey: "searchedWords")
                }
            
                .navigationTitle("search")
                .navigationBarTitleDisplayMode(.inline)
            
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        SignInMenuOrProfileButton()
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}
