import Foundation
import SwiftData

enum SeedData {
    static func insertIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Recipe>()
        let existing = (try? context.fetchCount(descriptor)) ?? 0
        guard existing == 0 else { return }

        let recipes = [
            Recipe(
                title: "Sunrise Veggie Scramble",
                ingredients: ["4 eggs", "1 cup spinach", "1/2 bell pepper", "salt", "olive oil"],
                steps: ["Whisk eggs.", "Sauté veggies.", "Add eggs and stir until set."],
                prepTimeMinutes: 15,
                tags: ["Breakfast", "Quick Meals"],
                nutritionNotes: "Approx 280 kcal / 20g protein"
            ),
            Recipe(
                title: "Cozy Tomato Basil Pasta",
                ingredients: ["8 oz pasta", "2 cups tomato sauce", "2 garlic cloves", "fresh basil"],
                steps: ["Boil pasta.", "Simmer sauce with garlic.", "Toss pasta and garnish."],
                prepTimeMinutes: 25,
                tags: ["Dinner", "Vegetarian"],
                nutritionNotes: "Approx 510 kcal per serving"
            ),
            Recipe(
                title: "Citrus Chicken Grain Bowl",
                ingredients: ["1 chicken breast", "1 cup cooked rice", "1 cup kale", "1 orange"],
                steps: ["Pan-sear chicken.", "Massage kale with citrus.", "Assemble bowl."],
                prepTimeMinutes: 30,
                tags: ["Lunch", "High Protein"],
                nutritionNotes: "Approx 430 kcal / 34g protein"
            )
        ]

        recipes.forEach(context.insert)
        try? context.save()
    }
}
