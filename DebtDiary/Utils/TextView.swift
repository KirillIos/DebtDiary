
import SwiftUI
import Combine

struct TextViewFont {
    
    let fontType: FontType
    let fontSize: CGFloat
    
    var font: Font {
        return .custom(fontType, size: fontSize)
    }
    
    var uiFont: UIFont? {
        return UIFont.custom(fontType, size: fontSize)
    }
    
    static func custom(_ type: FontType, size: CGFloat) -> TextViewFont {
        return TextViewFont(
            fontType: type,
            fontSize: size
        )
    }
    
}

enum TextViewType {
    case singleline
    case multiline
}

struct TextView: View {
    
    @State var placeholder = ""
    @Binding var text: String
    @State var type = TextViewType.singleline
    @State var font: TextViewFont? = nil
    @State var minHeight: CGFloat
    @State var backgroundColor: Color
    @State var cornerRadius: CGFloat = 12
    
    @State private var _height: CGFloat = 0
    @State private var isPlaceholderVisible = true
    
    private var isMultiline: Bool {
        switch type {
        case .multiline:
            return true
        case .singleline:
            return false
        }
    }
    
    var body: some View {
        ZStack {
            switch type {
            case .multiline:
                VStack {
                    MultilineTextField(
                        text: $text,
                        minHeight: minHeight,
                        placeholder: placeholder,
                        font: font?.uiFont
                    )
                    .padding(.top, 6)
                    .placeholder(
                        when: isPlaceholderVisible,
                        insets: EdgeInsets(
                            top: 0,
                            leading: 4,
                            bottom: 0,
                            trailing: 0
                        )
                    ) {
                        Text(placeholder)
                            .font(font?.font)
                            .foregroundStyle(.white.opacity(0.25))
                    }
                }
                .onReceive(MultilineTextField.Coordinator.heightPublisher) { _height = $0 }
            case .singleline:
                GeometryReader { proxy in
                    VStack {
                        Spacer()
                        TextField("", text: $text)
                            .font(font?.font)
                            .placeholder(when: isPlaceholderVisible) {
                                Text(placeholder)
                                    .font(font?.font)
                                    .foregroundStyle(.white.opacity(0.15))
                            }
                        Spacer()
                    }
                    .frame(width: proxy.size.width)
                }
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 19)
        .frame(height: isMultiline ? max(minHeight, _height) : minHeight)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .onAppear {
            isPlaceholderVisible = text.isEmpty
        }
        .onChange(of: text) { newText in
            isPlaceholderVisible = newText.isEmpty
        }
    }
}

struct MultilineTextField: UIViewRepresentable {
    
    @Binding var text: String
    let minHeight: CGFloat
    let placeholder: String
    let font: UIFont?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(
            text: $text,
            minHeight: minHeight,
            parent: self
        )
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultilineTextField>) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.text = text
        textView.delegate = context.coordinator
        textView.font = font
        textView.textColor = .white
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        
        static var heightPublisher = PassthroughSubject<CGFloat, Never>()
        
        var parent: MultilineTextField
        
        let minHeight: CGFloat
        var height: CGFloat = 0 {
            didSet {
                Self.heightPublisher.send(height)
            }
        }
        
        weak var placeholderLabel: UILabel?
        
        init(
            text: Binding<String>,
            minHeight: CGFloat,
            parent: MultilineTextField
        ) {
            self._text = text
            self.minHeight = minHeight
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            height = textView.contentSize.height
            text = textView.text
        }
        
    }
    
}

fileprivate extension View {
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        insets: EdgeInsets = EdgeInsets(),
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0).padding(insets)
                self
            }
        }
    
}
