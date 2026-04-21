import Foundation

@Observable
final class PlannerViewModel {
    let mealTypes = ["Breakfast", "Lunch", "Dinner"]

    func datesForWeek(from weekStart: Date) -> [Date] {
        (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: weekStart) }
    }

    func startOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components) ?? date
    }
}
