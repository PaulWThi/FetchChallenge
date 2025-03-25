import SwiftUI

struct FRButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.frButtonBackground)
            .foregroundColor(.frButtonForeground)
            .cornerRadius(10)
    }
}

extension View {
    func frButtonStyle() -> some View {
        self.modifier(FRButtonStyle())
    }
}
