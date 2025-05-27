import Foundation
import SwiftData

@Model
final class JournalEntry: Identifiable {
    var title: String
    var content: String
    var date: Date
    var isBookmarked: Bool

    init(
        title: String = "",
        content: String = "",
        date: Date = .now,
        isBookmarked: Bool = false
    ) {
        self.title = title
        self.content = content
        self.date = date
        self.isBookmarked = isBookmarked
    }
}
