import SwiftUI
import Combine

extension View {
    func keyboardToolbar<V: View>(view: @escaping () -> V) -> some View {
        modifier(KeyboardToolbar(toolbar: view))
    }

    func keyboardDoneButton() -> some View {
        modifier(KeyboardToolbar {
            HStack {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .padding(.horizontal)
            }
            .frame(height: 49)
            .background(.bar)
        })
    }
}

@Observable
private final class KeyboardToolbarViewModel {
    var isKeyboardVisible = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in
                withAnimation(.easeIn.delay(0.15)) {
                    self?.isKeyboardVisible = true
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.isKeyboardVisible = false
            }
            .store(in: &cancellables)
    }
}

private struct KeyboardToolbar<V: View>: ViewModifier {
    @State private var viewModel: KeyboardToolbarViewModel = .init()
    private let toolbar: V

    init(@ViewBuilder toolbar: () -> V) {
        self.toolbar = toolbar()
    }

    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom) {
                if viewModel.isKeyboardVisible {
                    toolbar
                }
            }
    }
}
