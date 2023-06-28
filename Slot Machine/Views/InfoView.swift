//
//  InfoView.swift
//  Slot Machine
//
//  Created by Patrick Masterson on 10/26/22.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section(header: Text("About the application")) {
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine")
                    FormRowView(firstItem: "Platforms", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Pat Masterson")
                    FormRowView(firstItem: "Designer", secondItem: "Pat Masterson")
                    FormRowView(firstItem: "Music", secondItem: "adsf")
                    FormRowView(firstItem: "Website", secondItem: "n/a")
                    FormRowView(firstItem: "Copyright", secondItem: "2020 All rights reserved")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                }
                .font(.body)
            }
            
        }
        .padding(.top, 40)
        .overlay(
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                audioPlayer?.stop()
            }) {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }
                .padding(.top, 30)
                .padding(.trailing, 20)
                .accentColor(.secondary)
            , alignment: .topTrailing
        )
        .onAppear() {
            playSound(sound: "background-music", type: "mp3")
        }
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    
    var body: some View {
        HStack {
            Text(firstItem)
                .foregroundColor(.gray)
            Spacer()
            Text(secondItem)
        }
    }
}



struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

