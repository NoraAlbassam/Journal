import Foundation // the model

// the Identifiable protocol is conformed to (meaning each instance of JournalEntry must have a unique identifier)
struct JournalEntry: Identifiable {
    let id = UUID() // unique identifier for each journal entry
    var title: String
    var date: Date // its of type Date, which will store when the journal entry was created :D
    var content: String
    var isBookmarked: Bool = false 
}
