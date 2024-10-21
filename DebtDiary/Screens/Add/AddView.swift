import SwiftUI

struct AddView: View {
    
    @Binding var isPresented: Bool
    @ObservedObject var viewModel : AddViewModel
    @State private var showDatePicker: Bool = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: getSafeAreaTopInset())
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Image(.arrowLeft)
                }
                Spacer()
                Text("Debts")
                    .foregroundColor(.green)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
            }
            Spacer().frame(height: 20)
            VStack(spacing: 16) {
                TextView(placeholder: "Debt Name", text: $viewModel.debtName, minHeight: 47, backgroundColor: .settingsCard)
                    .foregroundStyle(.white)
                
                TextView(placeholder: "Amount", text: $viewModel.amount, minHeight: 47, backgroundColor: .settingsCard)
                    .keyboardType(.numberPad)
                    .foregroundStyle(.white)
                
                Button(action: {
                    showDatePicker.toggle()
                }) {
                    HStack {
                        Text(viewModel.date == nil ? "No deadline" : formattedDate(viewModel.date ?? Date.now))
                            .foregroundColor(viewModel.date == nil ? Color.white.opacity(0.25) : Color.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(.settingsCard)
                    .cornerRadius(10)
                }
                
                TextView(placeholder: "Description", text: $viewModel.desc, type: .multiline ,minHeight: 100, backgroundColor: .settingsCard)
                    .foregroundColor(.white)
                    .foregroundStyle(.white)
                
            }
            Spacer()
            Button(action: {
                viewModel.saveModel()
                isPresented = false
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(viewModel.isContinueDisabled ? Color(hex: "#44A244").opacity(0.6) : Color(hex: "#44A244"))
                    .cornerRadius(13)
                    
            }
            .disabled(viewModel.isContinueDisabled)
            .padding(.bottom, 32)
            Spacer().frame(height: getSafeAreaBotInset())
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.settingsMain)
        .ignoresSafeArea()
        .bottomSheet(isPresented: $showDatePicker) {
                   DatePickerSheet(selectedDate: $viewModel.date) {
                       showDatePicker = false
                   }
               }
        .dismissKeyboardOnTap()
    }
    
    private func formattedDate(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateStyle = .short
           return formatter.string(from: date)
       }
    private func getSafeAreaTopInset() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.top
    }
    
    private func getSafeAreaBotInset() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
}
extension View {
    func bottomSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .background(
                BottomSheetHelper(isPresented: isPresented, content: content)
            )
    }
}
struct DatePickerSheet: View {
    @Binding var selectedDate: Date?
    var onDone: () -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Done") {
                    selectedDate = selectedDate ?? Date()
                    onDone()
                }
                .padding()
            }
            .background(Color.white)

            DatePicker(
                "Please choose",
                selection: Binding(
                    get: { selectedDate ?? Date() },
                    set: { selectedDate = $0 }
                ),
                displayedComponents: [.date]
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding()
    }
}

struct BottomSheetHelper<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let content: () -> Content

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, content: content)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            if context.coordinator.sheetViewController == nil {
                let sheetVC = UIHostingController(rootView: content())
                sheetVC.modalPresentationStyle = .pageSheet
                if let sheet = sheetVC.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                }
                uiViewController.present(sheetVC, animated: true)
                context.coordinator.sheetViewController = sheetVC
            }
        } else {
            if let sheetVC = context.coordinator.sheetViewController {
                sheetVC.dismiss(animated: true) {
                    context.coordinator.sheetViewController = nil
                }
            }
        }
    }

    class Coordinator: NSObject {
        @Binding var isPresented: Bool
        let content: () -> Content
        weak var sheetViewController: UIViewController?

        init(isPresented: Binding<Bool>, content: @escaping () -> Content) {
            _isPresented = isPresented
            self.content = content
        }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
