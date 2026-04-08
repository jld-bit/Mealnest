import Foundation
import SwiftData

@Model
final class GroceryItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var isChecked: Bool
    var sourceRecipeTitle: String
    var createdAt: Date
    var listBatchID: UUID

    init(
        id: UUID = UUID(),
        name: String,
        isChecked: Bool = false,
        sourceRecipeTitle: String,
        createdAt: Date = .now,
        listBatchID: UUID
    ) {
        self.id = id
        self.name = name
        self.isChecked = isChecked
        self.sourceRecipeTitle = sourceRecipeTitle
        self.createdAt = createdAt
        self.listBatchID = listBatchID
    }
}
