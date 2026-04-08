# MealNest (Original Concept SwiftUI App)

MealNest is an original iPhone app concept and codebase for:
- saving recipes,
- planning weekly meals,
- generating grocery lists.

## Important IP / originality note
This project uses original naming, copy, visual direction, and UX structure. It intentionally does **not** copy protected branding, copyrighted assets, trade dress, screenshots, or exact user flows from existing apps.

## Stack
- SwiftUI + MVVM
- SwiftData local persistence
- StoreKit 2 monetization gates (free vs premium)

## Feature coverage
- Onboarding with sample seeded recipes
- Recipe manager: title, photo, ingredients, steps, prep time, tags, optional manual nutrition notes
- Favorites, search, and tag filtering
- Weekly planner
- Grocery generation from meal plan recipes
- Share recipe as formatted text
- Free vs Premium limits:
  - Free: limited recipes + one weekly plan
  - Premium: unlimited recipes/plans, grocery history, premium themes

## Suggested next ship steps
1. Create an Xcode iOS App project named `MealNest` and add these files.
2. Set deployment target to iOS 17+ (SwiftData + Observation macros).
3. Configure StoreKit product IDs in App Store Connect.
4. Add app icon + launch screen assets.
5. Add unit tests for view model filtering and grocery generation.
