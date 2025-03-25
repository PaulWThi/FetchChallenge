import SwiftUI

enum ToastState: Equatable {
    case none
    case error(String)
    case success(String)

    var message: String {
        switch self {
        case .none:
            return ""
        case .success(let message), .error(let message):
            return message
        }
    }

    var backgroundColor: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .none: return .clear
        }
    }
}

struct ToastView: View {
    let message: String
    let background: Color

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .frame(maxWidth: .infinity)
                .padding()
                .background(background)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 1.0), value: message)
        }
    }
}
