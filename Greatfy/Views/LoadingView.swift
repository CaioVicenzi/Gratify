//
//  LoadingView.swift
//  Gratify
//
//  Created by Caio Marques on 10/06/24.
//

import SwiftUI

struct LoadingView: View {
    @State var dots : String = "."
    @State var finalizarEspera : Bool = false
    @EnvironmentObject var gratidaoController : GratidaoController
    
    var body: some View {
        VStack {
            Text("Carregando informações")
            Text("Isso pode levar um tempinho\(dots)")
        }
        .navigationDestination(isPresented: $finalizarEspera, destination: {
            HomeView()
                .navigationBarBackButtonHidden()
        })
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if gratidaoController.semaforo {
                    finalizarEspera = true
                    timer.invalidate()
                }
                if dots == "..." {
                    dots = "."
                } else {
                    dots.append(".")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoadingView()
    }
}
