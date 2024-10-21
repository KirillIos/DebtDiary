
import SwiftUI
import Combine

extension Publishers {
    
    static var keyboardHeight: AnyPublisher<(CGFloat, TimeInterval), Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { ($0.keyboardHeight, $0.keyboardAnimationDuration) }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { (CGFloat(0),  $0.keyboardAnimationDuration) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
    
}

extension Notification {
    
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
    
    var keyboardAnimationDuration: TimeInterval {
        return (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval) ?? 0
    }
    
}

extension View {
    
    func adaptToKeyboard() -> some View {
        modifier(AdaptToSoftwareKeyboard())
    }
    
}

struct AdaptToSoftwareKeyboard: ViewModifier {
    
    @State var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onReceive(Publishers.keyboardHeight) { keyboardParams in
                withAnimation(.spring(duration: keyboardParams.1)) {
                    self.keyboardHeight = keyboardParams.0
                }
            }
    }
    
}
