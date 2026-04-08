import SwiftUI
import SwiftData

@main
struct MealNestApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(appState)
        }
        .modelContainer(for: [Recipe.self, MealPlan.self, MealPlanEntry.self, GroceryItem.self])
    }
}
