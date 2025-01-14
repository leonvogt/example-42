import SwiftUI
import HotwireNative

struct ConversationView: View {
    static let VIEW_NAME = "conversation"
    let proposal: VisitProposal

    var body: some View {
        VStack(spacing: 10) {
            Text("Conversation")
                .multilineTextAlignment(.center)
            Button(action: navigateToHotwireWebView, label: {
                Text("Continue with Hotwire Web View")
            })
        }
        .frame(maxWidth: 300)
    }
    
    func navigateToHotwireWebView() {
        HotwireCentral.instance.navigator.route(Endpoint.instance.postsNew)
    }
}
