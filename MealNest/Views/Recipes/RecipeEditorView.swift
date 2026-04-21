import SwiftUI
import PhotosUI
import SwiftData

struct RecipeEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(StoreKitManager.self) private var storeKit
    @Query private var recipes: [Recipe]

    @State private var title = ""
    @State private var ingredientsText = ""
    @State private var stepsText = ""
    @State private var prepTime = 20
    @State private var tagsText = "Dinner, Quick Meals"
    @State private var nutrition = ""
    @State private var photoSelection: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var showLimitAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Title", text: $title)
                    Stepper("Prep time: \(prepTime) min", value: $prepTime, in: 5...240, step: 5)
                    PhotosPicker("Select Photo", selection: $photoSelection, matching: .images)
                }

                Section("Ingredients (one per line)") {
                    TextEditor(text: $ingredientsText).frame(minHeight: 120)
                }

                Section("Steps (one per line)") {
                    TextEditor(text: $stepsText).frame(minHeight: 140)
                }

                Section("Tags (comma separated)") {
                    TextField("Breakfast, Dinner, Quick Meals", text: $tagsText)
                }

                Section("Nutrition (optional)") {
                    TextField("e.g. 420 kcal / 28g protein", text: $nutrition)
                }
            }
            .navigationTitle("New Recipe")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { saveRecipe() }
                }
            }
            .alert("Free plan limit reached", isPresented: $showLimitAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Upgrade to Premium for unlimited recipes.")
            }
            .task(id: photoSelection) {
                photoData = try? await photoSelection?.loadTransferable(type: Data.self)
            }
        }
    }

    private func saveRecipe() {
        if let recipeLimit = storeKit.recipeLimit, recipes.count >= recipeLimit {
            showLimitAlert = true
            return
        }

        let ingredientLines = ingredientsText.split(separator: "\n").map { String($0) }.filter { !$0.isEmpty }
        let stepLines = stepsText.split(separator: "\n").map { String($0) }.filter { !$0.isEmpty }
        let tags = tagsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }

        let recipe = Recipe(
            title: title,
            photoData: photoData,
            ingredients: ingredientLines,
            steps: stepLines,
            prepTimeMinutes: prepTime,
            tags: tags,
            nutritionNotes: nutrition.isEmpty ? nil : nutrition
        )
        context.insert(recipe)
        try? context.save()
        dismiss()
    }
}
