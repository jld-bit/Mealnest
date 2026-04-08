import SwiftUI
import SwiftData

struct MealPlannerView: View {
    @Environment(\.modelContext) private var context
    @Environment(StoreKitManager.self) private var storeKit
    @Query(sort: [SortDescriptor(\Recipe.createdAt, order: .reverse)]) private var recipes: [Recipe]
    @Query(sort: [SortDescriptor(\MealPlan.weekStart, order: .reverse)]) private var mealPlans: [MealPlan]

    @State private var viewModel = PlannerViewModel()
    @State private var selectedWeek: Date = .now
    @State private var selectedRecipeID: UUID?
    @State private var selectedMealType: String = "Dinner"
    @State private var selectedDate: Date = .now
    @State private var showLimitAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    WarmCard {
                        DatePicker("Week", selection: $selectedWeek, displayedComponents: .date)
                            .onChange(of: selectedWeek) { _, newValue in
                                selectedWeek = viewModel.startOfWeek(for: newValue)
                            }
                    }

                    WarmCard {
                        VStack(alignment: .leading) {
                            Text("Add Meal").font(.headline)
                            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                            Picker("Meal Type", selection: $selectedMealType) {
                                ForEach(viewModel.mealTypes, id: \.self, content: Text.init)
                            }
                            Picker("Recipe", selection: $selectedRecipeID) {
                                Text("Select a recipe").tag(UUID?.none)
                                ForEach(recipes) { recipe in
                                    Text(recipe.title).tag(Optional.some(recipe.id))
                                }
                            }
                            Button("Save to Week") { saveEntry() }
                                .buttonStyle(.borderedProminent)
                                .tint(.orange)
                        }
                    }

                    ForEach(currentEntries, id: \.id) { entry in
                        if let recipe = recipes.first(where: { $0.id == entry.recipeID }) {
                            WarmCard {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(recipe.title).font(.headline)
                                        Text("\(entry.mealType) • \(entry.date.formatted(date: .abbreviated, time: .omitted))")
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Meal Planner")
            .alert("Free plan limit reached", isPresented: $showLimitAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Upgrade to Premium for unlimited meal plans.")
            }
        }
    }

    private var currentPlan: MealPlan? {
        let start = viewModel.startOfWeek(for: selectedWeek)
        return mealPlans.first { Calendar.current.isDate($0.weekStart, inSameDayAs: start) }
    }

    private var currentEntries: [MealPlanEntry] {
        currentPlan?.entries.sorted(by: { $0.date < $1.date }) ?? []
    }

    private func saveEntry() {
        guard let recipeID = selectedRecipeID else { return }

        if currentPlan == nil,
           let planLimit = storeKit.mealPlanLimit,
           mealPlans.count >= planLimit {
            showLimitAlert = true
            return
        }

        let weekStart = viewModel.startOfWeek(for: selectedWeek)
        let plan = currentPlan ?? {
            let newPlan = MealPlan(title: "Week of \(weekStart.formatted(date: .abbreviated, time: .omitted))", weekStart: weekStart)
            context.insert(newPlan)
            return newPlan
        }()

        let entry = MealPlanEntry(date: selectedDate, mealType: selectedMealType, recipeID: recipeID)
        plan.entries.append(entry)
        try? context.save()
    }
}
