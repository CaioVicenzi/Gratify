import SwiftUI

struct DetailView: View {
    @StateObject var gratitude: Gratidao
    @Environment(\.managedObjectContext) var moc
    @StateObject var vm = DetailViewModel()
    @FocusState var editMode
    
    // pegando a cor do ambiente
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    //MARK:  titulo
                    if vm.showLongTitleError {
                        PopupErro(showPopup: $vm.showLongTitleError)
                    }
                        
                    title
                    Divider()
                    
                    //MARK: descricao
                    HStack{
                        Text("Descrição")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        self.shownDate
                        
                    }
                    .padding(.horizontal)
                    .foregroundColor(Color.accentColor)
                        
                    descriptionTextEditor
                    image
                    inclusionDateLabel
                }
            }
            .onAppear{
                vm.setupTemps(moc: moc, gratitude: gratitude)
            }
            .toolbar{
                if vm.somethingChanged() {
                    ToolbarItem (placement: .automatic){
                        doneButton
                    }
                } else {
                    ToolbarItem (placement:.automatic) {
                        favButton
                    }
                    
                    ToolbarItem (placement: .automatic) {
                        shareButton
                    }
                }
            }
        }
        .padding(.bottom)
    }
}
