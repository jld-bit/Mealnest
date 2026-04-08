import SwiftUI

struct SettingsView: View {
    @Environment(StoreKitManager.self) private var storeKit
    @State private var purchaseError = false

    var body: some View {
        NavigationStack {
            List {
                Section("Plan") {
                    HStack {
                        Text("Current Plan")
                        Spacer()
                        Text(storeKit.plan == .premium ? "Premium" : "Free")
                            .foregroundStyle(storeKit.plan == .premium ? .green : .secondary)
                    }

                    if storeKit.plan == .free {
                        Text("Free includes up to 20 saved recipes and 1 weekly plan.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Button("Upgrade to Premium") {
                            Task {
                                do {
                                    try await storeKit.purchasePremium()
                                } catch {
                                    purchaseError = true
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                    } else {
                        Text("Premium unlocks unlimited recipes, unlimited plans, grocery history, and premium themes.")
                            .font(.subheadline)
                    }
                }

                Section("Theme") {
                    if storeKit.plan == .premium {
                        Text("Premium themes unlocked. Add theme controls here.")
                    } else {
                        Text("Premium required for theme packs.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Purchase failed", isPresented: $purchaseError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please try again.")
            }
        }
    }
}
