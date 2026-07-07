import Foundation

struct LogEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var primaryText: String
    var secondaryText: String = ""
    var numericValue: Double?
    var tag: String = ""
    var isDone: Bool = false

}
