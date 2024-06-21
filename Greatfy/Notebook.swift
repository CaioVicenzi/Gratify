//
//  s.swift
//  Gratify
//
//  Created by Caio Marques on 16/06/24.
//

import SwiftUI

struct Notebook: View {
    @Binding var text : String
    
    var body: some View {
        TextEditor(text: $text)
            .opacity(0.8)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack (spacing: 30){
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                    Divider()
                }
            }
    }
}
