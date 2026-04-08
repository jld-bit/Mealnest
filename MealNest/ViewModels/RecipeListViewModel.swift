import Foundation

@Observable
final class RecipeListViewModel {
    var searchText = ""
    var selectedTag: String = "All"
    var favoritesOnly = false

    func filtered(recipes: [Recipe]) -> [Recipe] {
        recipes.filter { recipe in
            let matchesSearch = searchText.isEmpty || recipe.title.localizedCaseInsensitiveContains(searchText)
            let matchesTag = selectedTag == "All" || recipe.tags.contains(selectedTag)
            let matchesFavorite = !favoritesOnly || recipe.isFavorite
            return matchesSearch && matchesTag && matchesFavorite
        }
    }

    var availableTags: [String] {
        ["All", "Breakfast", "Lunch", "Dinner", "Quick Meals", "Vegetarian", "High Protein"]
    }
}
