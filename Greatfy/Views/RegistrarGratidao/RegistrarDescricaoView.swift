//
//  RegistrarDescricaoView.swift
//  Gratify
//
//  Created by Caio Marques on 16/06/24.
//

import SwiftUI

struct RegistrarDescricaoView: View {
    @StateObject var vm : RegisterViewModel
    
    var body: some View {
        VStack  (alignment: .leading){
            // título
            Text("Pelo que você é grato?")
                .font(.headline)
                .padding(.bottom, 30)
            
            
            Notebook(text: $vm.descricao)
                .opacity(0.6)

            /*
            TextEditor(text: $vm.descricao)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay (alignment: .top){
                    VStack (spacing: 25){
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
            */
            
        }
    }
}

