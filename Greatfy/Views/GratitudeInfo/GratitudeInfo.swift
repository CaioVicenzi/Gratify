import SwiftUI
import WebKit

struct GratitudeInfo: View {
    @State var showFonts = [false, false, false]
    @State var showLinks = false
    
    var body: some View {
        VStack {
            ScrollView{
                VStack (alignment: .leading){
                    Text("O que é gratidão")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .foregroundColor(Color.accentColor)
                    
                    Text("A gratidão é uma emoção positiva em que você se sente agradecido. Quando você pratica a gratidão, responde com sentimentos de bondade e generosidade a todas as coisas que acontecem com você.")
                        .foregroundStyle(Color.secondary)
                    
                    Text("Por que a gratidão é importante?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .foregroundColor(Color.accentColor)
                    Text("A gratidão trás diversos benefícios como bem-estar, diminuição do estresse e ajuda a prevenir a depressão. Pessoas mais gratas possuem sistema imunológico mais forte e dormem melhor. \nUm estudo conduzido com 300 pessoas concluiu que pessoas que praticam a gratidão possuem uma melhor saúde mental do que os indivíduos que não praticam. \nA gratidão ajuda a valorizar aquilo que o indivíduo já tem e diminui consideravelmente a ansiedade que ele possui por coisas que ele não tem ou que desejaria ter.")
                        .foregroundStyle(Color.secondary)
                    
                    Text("Como ser grato?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .foregroundColor(Color.accentColor)
                    Text("Salvando a sua gratidão diária no seu Gratify!")
                        .foregroundStyle(Color.secondary)
                    
                    HStack {
                        Text("Fontes:")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical)
                        Image(systemName: "chevron.right")
                            .rotationEffect(.degrees(showLinks ? 90 : 0))
                            
                    }
                    .foregroundColor(Color.accentColor)
                    .onTapGesture {
                        withAnimation {
                            self.showLinks.toggle()
                        }
                    }

                    
                    if showLinks {
                        VStack (alignment: .leading){
                            FontLink(showFont: $showFonts[0], link: "https://omnihypnosis.com.br/blog-como-praticar-a-gratidao/")
                            FontLink(showFont: $showFonts[1], link: "https://www.ibccoaching.com.br/portal/a-importancia-da-gratidao/")
                            FontLink(showFont: $showFonts[2], link: "https://www.metropoles.com/colunas/claudia-meireles/gratidao-provada-por-estudos-de-harvard-que-faz-bem-para-o-cerebro")
                            
                        }
                        .multilineTextAlignment(.leading)
                        .accentColor(.secondary)
                    }
                }.padding()
            }
        }
        .navigationTitle("Sobre a gratidão")
    }
}

struct FontLink : View {
    @Binding var showFont : Bool
    let link : String
    
    var body: some View {
        Button{
            showFont = true
        } label: {
            HStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                Text(link)
                    .multilineTextAlignment(.leading)
            }
            
        }.sheet(isPresented: $showFont, onDismiss: nil) {
            if let url = URL(string: link) {
                WebView(url: url)
            }
        }
    }
}

struct WebView : UIViewRepresentable{
    var url : URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let requisicao = URLRequest (url: url)
        uiView.load(requisicao)
    }
    
}

/*
 #Preview {
 InformacaoGratidao()
 }
 */
