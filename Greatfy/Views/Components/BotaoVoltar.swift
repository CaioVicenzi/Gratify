//
//  BotaoVoltar.swift
//  Gratify
//
//  Created by Caio Marques on 03/06/23.
//

import SwiftUI

struct BotaoVoltar: View {
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            HStack (spacing: 2){
                Image(systemName: "chevron.backward")
                Text("Voltar")
            }
            .bold()
        }
    }
}

struct BotaoVoltar_Previews: PreviewProvider {
    static var previews: some View {
        BotaoVoltar()
    }
}
