import Foundation

@Observable
final class AppState {
    var didFinishOnboarding: Bool = UserDefaults.standard.bool(forKey: "did_finish_onboarding")

    func finishOnboarding() {
        didFinishOnboarding = true
        UserDefaults.standard.set(true, forKey: "did_finish_onboarding")
    }
}
