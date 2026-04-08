import SwiftUI
import SwiftData

struct GroceryListView: View {
    @Environment(\.modelContext) private var context
    @Environment(StoreKitManager.self) private var storeKit
    @Query(sort: [SortDescriptor(\MealPlan.weekStart, order: .reverse)]) private var mealPlans: [MealPlan]
    @Query(sort: [SortDescriptor(\Recipe.createdAt, order: .reverse)]) private var recipes: [Recipe]
    @Query(sort: [SortDescriptor(\GroceryItem.createdAt, order: .reverse)]) private var groceryItems: [GroceryItem]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("Generate from Latest Meal Plan") {
                        generateList()
                    }
                    .foregroundStyle(.orange)
                }

                Section("Current Grocery List") {
                    ForEach(groceryItems.filter { $0.listBatchID == currentBatchID }) { item in
                        Button {
                            item.isChecked.toggle()
                            try? context.save()
                        } label: {
                            HStack {
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                Text(item.name)
                            }
                        }
                    }
                }

                if storeKit.plan == .premium {
                    Section("History") {
                        ForEach(uniqueHistoricalBatchIDs, id: \.self) { batchID in
                            Text("List \(batchID.uuidString.prefix(6)) • \(countForBatch(batchID)) items")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Grocery")
        }
    }

    private var currentBatchID: UUID {
        groceryItems.first?.listBatchID ?? UUID()
    }

    private var uniqueHistoricalBatchIDs: [UUID] {
        Array(Set(groceryItems.map(\.listBatchID))).sorted { $0.uuidString > $1.uuidString }
    }

    private func countForBatch(_ batchID: UUID) -> Int {
        groceryItems.filter { $0.listBatchID == batchID }.count
    }

    private func generateList() {
        guard let latestPlan = mealPlans.first else { return }
        let plannedRecipes = latestPlan.entries.compactMap { entry in
            recipes.first(where: { $0.id == entry.recipeID })
        }

        let ingredients = GroceryGenerator.mergedIngredients(from: plannedRecipes)
        let newBatchID = UUID()
        ingredients.forEach { ingredient in
            context.insert(GroceryItem(name: ingredient, sourceRecipeTitle: "Meal Plan", listBatchID: newBatchID))
        }
        try? context.save()
    }
}
