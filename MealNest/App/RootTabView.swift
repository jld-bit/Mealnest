import SwiftUI

struct RootTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        if appState.didFinishOnboarding {
            MainTabView()
        } else {
            OnboardingFlowView()
        }
    }
}
