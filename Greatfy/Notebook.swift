import SwiftUI

struct NotebookLines: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let lineSpacing: CGFloat = 24 // Espaçamento entre as linhas

        var y = lineSpacing
        while y < rect.height {
            path.move(to: CGPoint(x: rect.minX, y: y))
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
            y += lineSpacing
        }

        return path
    }
}


struct Notebook: View {
    @Binding var text : String
    
    var body: some View {
        ZStack {
            NotebookLines()
                .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                .padding(.horizontal)
            
            TextEditor(text: $text)
                .padding(8)
                .background(Color.clear)
        }
    }
}
