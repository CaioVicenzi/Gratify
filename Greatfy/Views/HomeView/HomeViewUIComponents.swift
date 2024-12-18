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
            ConfigureNotification()
                .presentationDetents([.medium])
        })
    }
    
    var informationButton : some View {
        Button {
            vm.showInfoSheet = true
        } label: {
            Image(systemName: "info.circle")
        }
        .navigationDestination(isPresented: $vm.showInfoSheet, destination: {
            InformationPage()
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
            RegisterView()
        }
    }
        
    var rollDiceButton : some View {
        Button {
            vm.rollDice(gratidoes)
        } label: {
            Image(systemName: "dice")
        }
        .alert("Não encontramos gratidão 😔", isPresented: $vm.openAlertGratitudeNotFound) {
            Button ("OK") {}
        } message: {
            Text("Adicione uma gratidão para a gente sortear!")
        }
        .navigationDestination(item: $vm.randomGratitude) { gratitude in
            DetailView(gratitude: gratitude)
        }
    }
    
    var streakCapsule : some View {
        HStack (spacing: 5){
            let streak = vm.calculateStreak(gratidoes)
            if vm.showMaximizedStreak{
                Text("\(streak) dia\(streak > 1 ? "s" : "") de streak")
            } else {
                Text(streak.description)
            }
            Image(systemName: "flame.fill")
        }
        .padding(5)
        .padding(.horizontal, 10)
        .foregroundStyle(.white)
        .font(.caption2)
        .bold()
        .frame(width: vm.showMaximizedStreak ? 200 : 60)
        .background(vm.wroteGratitudeToday(gratidoes) ? Color(.brightBlue) : .gray)
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .onTapGesture {
            HapticHandler.instance.impact(feedbackStyle: .light)
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
    
    var backgroundDismissKeyboard : some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                vm.dismissKeyboard()
            }
    }
}
