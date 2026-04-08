import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var storeKit = StoreKitManager()

    var body: some View {
        TabView {
            RecipeListView()
                .tabItem { Label("Recipes", systemImage: "book.closed") }

            MealPlannerView()
                .tabItem { Label("Planner", systemImage: "calendar") }

            GroceryListView()
                .tabItem { Label("Groceries", systemImage: "cart") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .environment(storeKit)
        .tint(.orange)
    }
}
