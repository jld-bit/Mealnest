import Foundation
import SwiftData

@Model
final class Recipe {
    @Attribute(.unique) var id: UUID
    var title: String
    var photoData: Data?
    var ingredients: [String]
    var steps: [String]
    var prepTimeMinutes: Int
    var tags: [String]
    var isFavorite: Bool
    var nutritionNotes: String?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        photoData: Data? = nil,
        ingredients: [String],
        steps: [String],
        prepTimeMinutes: Int,
        tags: [String],
        isFavorite: Bool = false,
        nutritionNotes: String? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.photoData = photoData
        self.ingredients = ingredients
        self.steps = steps
        self.prepTimeMinutes = prepTimeMinutes
        self.tags = tags
        self.isFavorite = isFavorite
        self.nutritionNotes = nutritionNotes
        self.createdAt = createdAt
    }
}
