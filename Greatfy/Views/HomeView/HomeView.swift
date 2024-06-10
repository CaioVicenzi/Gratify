//
//  HomeView.swift
//  Gratify
//
//  Created by Caio Marques on 07/06/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Gratidao.data, ascending: true)]) var gratidoes:FetchedResults<Gratidao>
    @Environment (\.colorScheme) var colorScheme
    @Environment (\.managedObjectContext) var moc
    
    var body: some View {
        ZStack {
            backgroundDismissKeyboard
                .foregroundStyle(.background)
            backgroundPinkClouds
            VStack {
                if gratidoes.isEmpty {
                    noGratitudeYet
                } else {
                    List {
                        ForEach(gratidoes) { gratidao in
                            if let title = gratidao.titulo {
                                if (title.lowercased().contains(vm.searchText.lowercased()) || vm.searchText == "") {
                                    NavigationLink{
                                        DetalhamentoView(gratidao: gratidao)
                                    } label: {
                                        ListItem(gratidao: gratidao, sharedItem: $vm.sharedItem)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $vm.searchText)
                }
            }
            .navigationTitle("Gratify")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    reminderButton
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    informationButton
                }
                
                ToolbarItem(placement: .bottomBar) {
                    toolbarBottom
                }
            }
            .onAppear(perform: {
                self.vm.config(gratidoes: gratidoes)
            })
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
