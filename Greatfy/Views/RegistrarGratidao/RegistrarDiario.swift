//
//  RegistrarDiario.swift
//  Greatfy
//
//  Created by Caio Marques on 14/05/23.
//

import SwiftUI


struct RegistrarDiarioView: View {
    @Binding var titulo:String
    @Binding var descricao:String
    let limite = 40
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("\(formatarDataParaBrasileira(date: Date()))").foregroundColor(corSecundaria).fontWeight(.semibold)
                Spacer()
            }
            Form () {
                
                ZStack(alignment: .topLeading) {
                    if titulo.isEmpty {
                        Text("Insira um motivo pelo qual você é grato")
                            .foregroundColor(Color(UIColor.systemGray3))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)
                    }
                    
                    TextEditor(text: $titulo)
                        .foregroundColor(.gray)
                        .background(Color.clear)
                }.font(.title3)
            
                ZStack(alignment: .topLeading) {
                    if descricao.isEmpty {
                        Text("Por que você é grato por isso? (descreva com o máximo de detalhes possível)")
                            .foregroundColor(Color(.systemGray3))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 12)
                    }
                    
                    TextEditor(text: $descricao)
                        .frame(maxHeight: .infinity)
                        .cornerRadius(8)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 12)
                        .padding(.top, 2)
                }
                
            }
        }
    }
}





 struct RegistrarDiario_Previews: PreviewProvider {
     @State static var titulo:String = ""
     @State static var descricao:String = ""
     static var previews: some View {
        RegistrarDiarioView(titulo: $titulo, descricao: $descricao)
     }
 }
 
