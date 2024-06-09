//
//  HomeViewUIComponents.swift
//  Gratify
//
//  Created by Caio Marques on 07/06/24.
//

import Foundation
import SwiftUI

/// ARQUIVO FEITO PARA MANTÉR OS COMPONENTES DE UI QUE SÃO ESPECÍFICOS PARA A HOMEVIEW E QUE MUITO PROVAVELMENTE NÃO VÃO MUDAR.
extension HomeView {
    var reminderButton : some View {
        Button {
            vm.showReminderSheet = true
        } label: {
            Image(systemName: "bell")
        }
        .sheet(isPresented: $vm.showReminderSheet, content: {
            ConfigurarNotificacao()
                .presentationDetents([.medium])
        })
    }
    
    var informationButton : some View {
        Button {
            vm.showInfoSheet = true
        } label: {
            Image(systemName: "info.circle")
        }
        .sheet(isPresented: $vm.showInfoSheet, content: {
            InformacaoGratidao()
        })
    }
    
    var toolbarBottom : some View {
        HStack {
            rollDiceButton
            Spacer()
            streakCapsule
            Spacer()
            registerButton
        }
        .padding(.horizontal)
    }
    
    var registerButton : some View {
        Button {
            vm.showRegisterGratitude = true
        } label: {
            Image(systemName: "square.and.pencil")
        }
        .navigationDestination(isPresented: $vm.showRegisterGratitude) {
            RegistrarGratidaoView()
        }
    }
        
    var rollDiceButton : some View {
        Button {
            vm.rollDice()
        } label: {
            Image(systemName: "dice")
        }
        .alert("Não encontramos gratidão 😔", isPresented: $vm.openAlertGratitudeNotFound) {
            Button ("OK") {}
        } message: {
            Text("Adicione uma gratidão para a gente sortear!")
        }
        .navigationDestination(item: $vm.randomGratitude) { gratitude in
            DetalhamentoView(gratidao: gratitude)
        }
    }
    
    var streakCapsule : some View {
        HStack (spacing: 5){
            if vm.showMaximizedStreak{
                Text("\(vm.streak) dia\(vm.streak > 1 ? "s" : "") de streak")
            } else {
                Text(vm.streak.description)
            }
            Image(systemName: "flame.fill")
        }
        .padding(5)
        .padding(.horizontal, 10)
        .foregroundStyle(.white)
        .font(.caption2)
        .bold()
        .frame(width: vm.showMaximizedStreak ? 200 : 60)
        .background(vm.wroteGratitudeToday ? Color(.brightBlue) : .gray)
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .onTapGesture {
            HapticHandler.instance.impacto(estilo: .light)
            withAnimation (.spring){
                vm.showMaximizedStreak.toggle()
            }
        }
    }
    
    var noGratitudeYet : some View {
        VStack{
            Spacer()
            Text("Adicione sua primeira gratidão! 😉")
                .font(.footnote)
                .foregroundColor(Color(.systemGray2))
            Spacer()
        }
    }
    
    var backgroundList : some View {
        VStack {
            HStack {
                Image("nuvemRosa")
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    var backgroundDismissKeyboard : some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                vm.dismissKeyboard()
            }
    }
    
    var backgroundPinkClouds : some View {
        
        VStack {
            
            HStack {
                Spacer()
            }
            .offset(x: -30)
            
            Spacer()
            
            HStack {
                Spacer()
                Image("nuvemrosa")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .offset(y: -30)
                    .opacity(0.2)
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Image("nuvemrosa")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .opacity(0.3)
                Spacer()
            }
            .padding(.horizontal)
            Spacer()
            
            Spacer()
            
            HStack {
                Spacer()
                Image("nuvemrosa")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .opacity(0.3)
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Image("nuvemrosa")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .opacity(0.4)
                Spacer()
            }
            Spacer()

            
        }
        
    }

    
    
}
