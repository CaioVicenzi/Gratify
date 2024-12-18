//
//  ListItem.swift
//  Gratify
//
//  Created by Caio Marques on 07/06/24.
//

import SwiftUI

struct ListItem: View {
    var gratitude : Gratidao
    @Environment(\.managedObjectContext) var moc
    @Binding var sharedItem:Gratidao?
    
    var body: some View {
        VStack {
            HStack{
                title
                Spacer()
                date
            }.padding(.bottom, 2)
            HStack{
                if let description = gratitude.descricao {
                    Text(description)
                        .lineLimit(1)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if gratitude.favoritado{
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color(.brightBlue))
                }
            }
        }
        .swipeActions(edge: .trailing, content: {
            
            // EXCLUIR
            Button (role: .destructive){
                HapticHandler.instance.notification(feedbackType: .warning)
                GratitudeController().deleteGratitude(gratitude: gratitude, context: moc)
            } label: {
                Image(systemName: "trash")
            }
            // COMPARTILHAR
            Button {
                sharedItem = gratitude
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .tint(Color(.pinky))
        })
        
        
        .swipeActions(edge: .leading) {
            // FAVORITAR
            Button {
                HapticHandler.instance.impact(feedbackStyle: .light)
                GratitudeController().toggleFavorited(gratitude: gratitude, context: moc)
                
            } label: {
                
                Image(systemName: "heart")
                
            }.tint(gratitude.favoritado ?  Color.gray : Color(.brightBlue))
        }
        .sheet(item: $sharedItem) { item in
            if let titulo = item.titulo, let descricao = item.descricao, let data = item.data {
                let texto : String = "\(titulo)\n\n\(descricao)\n\nEstou fazendo um diário da gratidão no Gratify! Esse foi do dia \(data.formatted(date: .numeric, time: .omitted))\nFaça o seu também: https://apps.apple.com/br/app/gratify/id6449554523"
                ShareSheet(activityItems: [texto])
            }
        }
    }
    
    
    // MARK: UI COMPONENTS
    var title : some View {
        if let title = gratitude.titulo {
            Text(title)
                .font(.headline)
        } else {
            Text("")
        }
    }
    
    var date : some View {
        if let gratitudeDate = gratitude.data {
            Text(gratitudeDate.formatted(date: .numeric, time: .omitted))
                .fontWeight(.light)
                .font(.caption2)
                .foregroundColor(.gray)
        } else {
            Text("dd/mm/aaaa")
        }
    }
}

#Preview {
    ListItem(gratitude: Gratidao(), sharedItem: .constant(Gratidao()))
}
