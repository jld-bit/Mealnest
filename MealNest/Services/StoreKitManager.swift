import Foundation
import StoreKit

@MainActor
@Observable
final class StoreKitManager {
    enum Plan {
        case free
        case premium
    }

    private(set) var plan: Plan = .free
    private(set) var products: [Product] = []
    private let premiumProductID = "com.mealnest.premium.monthly"

    var recipeLimit: Int? { plan == .free ? 20 : nil }
    var mealPlanLimit: Int? { plan == .free ? 1 : nil }

    init() {
        Task {
            await loadProducts()
            await refreshEntitlements()
        }
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: [premiumProductID])
        } catch {
            products = []
        }
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == premiumProductID {
                plan = .premium
                return
            }
        }
        plan = .free
    }

    func purchasePremium() async throws {
        guard let product = products.first else { return }
        let result = try await product.purchase()
        if case .success(let verification) = result,
           case .verified = verification {
            plan = .premium
        }
    }
}
