import SwiftUI
import UIKit

struct RecipeDetailView: View {
    @Environment(\.modelContext) private var context
    @Bindable var recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                WarmCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(recipe.title).font(.title.bold())
                        Text("Prep time: \(recipe.prepTimeMinutes) min")
                            .foregroundStyle(.secondary)
                    }
                }

                WarmCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ingredients").font(.headline)
                        ForEach(recipe.ingredients, id: \.self) { item in
                            Label(item, systemImage: "checkmark.circle")
                        }
                    }
                }

                WarmCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Steps").font(.headline)
                        ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                            Text("\(index + 1). \(step)")
                        }
                    }
                }

                if let nutrition = recipe.nutritionNotes, !nutrition.isEmpty {
                    WarmCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nutrition").font(.headline)
                            Text(nutrition)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    recipe.isFavorite.toggle()
                    try? context.save()
                } label: {
                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(.pink)
                }

                ShareLink(item: formattedRecipe) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

    private var formattedRecipe: String {
        """
        \(recipe.title)

        Prep: \(recipe.prepTimeMinutes) min
        Tags: \(recipe.tags.joined(separator: ", "))

        Ingredients:
        \(recipe.ingredients.map { "- \($0)" }.joined(separator: "\n"))

        Steps:
        \(recipe.steps.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n"))

        Nutrition:
        \(recipe.nutritionNotes ?? "Not provided")
        """
    }
}
