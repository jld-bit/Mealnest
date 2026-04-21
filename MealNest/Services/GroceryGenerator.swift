import Foundation

struct GroceryGenerator {
    static func mergedIngredients(from recipes: [Recipe]) -> [String] {
        let allIngredients = recipes.flatMap(\.ingredients)
        let normalized = allIngredients.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        let unique = Array(Set(normalized)).sorted()
        return unique.map { $0.capitalized }
    }
}
