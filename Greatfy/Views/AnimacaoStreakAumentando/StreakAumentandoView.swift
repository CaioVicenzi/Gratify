//
//  StreakAumentandoView.swift
//  Gratify
//
//  Created by Caio Marques on 15/02/24.
//

import SwiftUI

struct StreakAumentandoView: View {
    @State var animarMao = false
    @State var animarTexto = false
    @State var animarBotao = false
    @State var mostrarContentView = false
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Gratidao.data, ascending: false)]) var gratidoes:FetchedResults<Gratidao>

    var body: some View {
        VStack (spacing: 40) {
            
            Spacer()
            maoAnimada
            
            
            VStack{
                if animarTexto {
                    let streak = calculateStreak()
                    Text("Parabéns, você completou \(streak) dia\(streak > 1 ? "s" : "") de streak")
                    Text("Continue assim!")
                }
            }
            .font(.headline)
            
            Spacer()
            if animarBotao {
            
                Button {
                    HapticHandler.instance.impacto(estilo: .medium)
                    mostrarContentView = true
                } label: {
                    Text("Vamos nessa!")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(.brightBlue))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding()
                .navigationDestination(isPresented: $mostrarContentView) {
                    HomeView()
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color(.pinky), Color(.brightBlue)], startPoint: .bottomLeading, endPoint: .topTrailing))
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                withAnimation (Animation.spring(bounce: 0.8)) {
                    animarMao = true
                }
                
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                withAnimation (Animation.spring(bounce: 0.8)) {
                    animarTexto = true
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                withAnimation (Animation.easeIn) {
                    animarBotao = true
                }
            })
        })
    }
    
    var maoAnimada : some View {
        Image(systemName: "hand.thumbsup.fill")
            .resizable()
            .scaledToFit()
            .frame(width: animarMao ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 5)
            .foregroundStyle(.purple)
    }
    
    func calculateStreak () -> Int {
        let calculator = StreakCalculator()
        calculator.configCalculator(fetchedResults: self.gratidoes)
        return calculator.calculateStreak()
    }
}

#Preview {
    StreakAumentandoView()
}
