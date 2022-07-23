//
//  ProfileSections.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct ProfileListWhenSignedIn: View {
    
    @State private var icon: UIImage? = nil
    @State private var displayName: String? = nil
    @State private var userTag: String? = nil
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("display_name")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Appleman")
                }
                
                HStack {
                    Text("user_tag")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Apple-man-12")
                }
            }
            
            Section {
                NavigationLink(destination: AccountView()) {
                    Text("account_setting")
                }
            }
        }
        .onAppear {
            
        }
    }
}
