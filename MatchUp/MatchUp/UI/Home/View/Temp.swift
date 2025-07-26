import SwiftUI

struct SwipeModifier: ViewModifier {
    @Binding var items: [String]
    let item: String
    let onSwipe: (SwipeDirection) -> Void
    @State private var offset: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        if offset.width > 100 {
                            print("Right")
                            swipe(.right)
                        } else if offset.width < -100 {
                            print("Left")
                            swipe(.left)
                        } else {
                            offset = .zero
                        }
                    }
            )
    }

    private func swipe(_ direction: SwipeDirection) {
        withAnimation {
            offset = CGSize(width: direction == .right ? 500 : -500, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let index = items.firstIndex(of: item) {
                items.remove(at: index)
            }
            onSwipe(direction)
        }
    }
}

enum SwipeDirection {
    case left, right
}

extension View {
    func swipeable(item: String, items: Binding<[String]>, onSwipe: @escaping (SwipeDirection) -> Void) -> some View {
        self.modifier(SwipeModifier(items: items, item: item, onSwipe: onSwipe))
    }
}

struct SwipeCard: View {
    let user: String
    @Binding var users: [String]

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.orange)
            .frame(height: 400)
            .overlay(
                Text(user)
                    .font(.largeTitle)
                    .foregroundColor(.white)
            )
            .swipeable(item: user, items: $users) { direction in
                // Handle swipe direction here if needed
            }
    }
}

struct SwipeStackView: View {
    @State private var users = ["Alice", "Bob", "Charlie", "Diana"]

    var body: some View {
        ZStack {
            ForEach(users.reversed(), id: \.self) { user in
                SwipeCard(user: user, users: $users)
            }
        }
        .padding()
    }
}
