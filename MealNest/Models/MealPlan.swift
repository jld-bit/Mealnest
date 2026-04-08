import Foundation
import SwiftData

@Model
final class MealPlan {
    @Attribute(.unique) var id: UUID
    var title: String
    var weekStart: Date
    @Relationship(deleteRule: .cascade) var entries: [MealPlanEntry]
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        weekStart: Date,
        entries: [MealPlanEntry] = [],
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.weekStart = weekStart
        self.entries = entries
        self.createdAt = createdAt
    }
}

@Model
final class MealPlanEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var mealType: String
    var recipeID: UUID

    init(id: UUID = UUID(), date: Date, mealType: String, recipeID: UUID) {
        self.id = id
        self.date = date
        self.mealType = mealType
        self.recipeID = recipeID
    }
}
