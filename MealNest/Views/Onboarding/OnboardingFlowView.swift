import SwiftUI
import SwiftData

struct OnboardingFlowView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState
    @State private var index = 0

    private let pages: [(title: String, text: String, icon: String)] = [
        ("Welcome to MealNest", "Save recipes, plan your week, and generate grocery lists in minutes.", "sparkles"),
        ("Plan Smarter", "Drag your favorite dishes into a weekly planner built for busy home cooks.", "calendar.badge.clock"),
        ("Shop Faster", "Auto-build grocery lists from planned meals and check items off in-store.", "cart.fill.badge.plus")
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: pages[index].icon)
                .font(.system(size: 64))
                .foregroundStyle(.orange)
            Text(pages[index].title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            Text(pages[index].text)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()

            Button(index == pages.count - 1 ? "Get Cooking" : "Next") {
                if index == pages.count - 1 {
                    SeedData.insertIfNeeded(context: context)
                    appState.finishOnboarding()
                } else {
                    index += 1
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .padding(.bottom)
        }
        .padding()
        .background(
            LinearGradient(colors: [.yellow.opacity(0.18), .orange.opacity(0.1), .pink.opacity(0.12)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }
}
