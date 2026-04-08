import SwiftUI
import SwiftData

struct RecipeListView: View {
    @Environment(\.modelContext) private var context
    @Environment(StoreKitManager.self) private var storeKit
    @Query(sort: [SortDescriptor(\Recipe.createdAt, order: .reverse)]) private var recipes: [Recipe]
    @State private var viewModel = RecipeListViewModel()
    @State private var showComposer = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    controls
                    ForEach(viewModel.filtered(recipes: recipes)) { recipe in
                        NavigationLink(value: recipe.id) {
                            RecipeCardView(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("MealNest")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showComposer = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.orange)
                    }
                }
            }
            .navigationDestination(for: UUID.self) { id in
                if let selected = recipes.first(where: { $0.id == id }) {
                    RecipeDetailView(recipe: selected)
                }
            }
            .sheet(isPresented: $showComposer) {
                RecipeEditorView()
            }
            .searchable(text: $viewModel.searchText, prompt: "Search recipes")
        }
    }

    private var controls: some View {
        VStack(spacing: 10) {
            Picker("Tags", selection: $viewModel.selectedTag) {
                ForEach(viewModel.availableTags, id: \.self) { tag in
                    Text(tag).tag(tag)
                }
            }
            .pickerStyle(.segmented)

            Toggle("Favorites only", isOn: $viewModel.favoritesOnly)
                .tint(.orange)
        }
    }
}

private struct RecipeCardView: View {
    let recipe: Recipe

    var body: some View {
        WarmCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(recipe.title).font(.headline)
                    Spacer()
                    if recipe.isFavorite {
                        Image(systemName: "heart.fill").foregroundStyle(.pink)
                    }
                }
                Text("Prep: \(recipe.prepTimeMinutes) min")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(recipe.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption.weight(.medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.orange.opacity(0.2), in: Capsule())
                        }
                    }
                }
            }
        }
    }
}
