import SwiftUI

// vm for managing journal entries
class JournalViewModel: ObservableObject {
    @Published var journalEntries: [JournalEntry] = []
    @Published var selectedFilter: String = "All"
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var addingJournal: Bool = false
    @Published var editingJournal: JournalEntry?
    @Published var searchBar: String = ""

    // computed property for filtered entries
    var filteredEntries: [JournalEntry] {
        let filtered = journalEntries.filter {
            searchBar.isEmpty || $0.title.localizedCaseInsensitiveContains(searchBar) || $0.content.localizedCaseInsensitiveContains(searchBar)
        }

        switch selectedFilter {
        case "Bookmarked":
            return filtered.filter { $0.isBookmarked }
        case "Sorted by Date":
            return filtered.sorted { $0.date > $1.date }
        default:
            return filtered
        }
    }

    func addEntry() {
        let newEntry = JournalEntry(title: title, date: Date(), content: content)
        journalEntries.append(newEntry)
        resetFields()
    }

    func editEntry(entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries[index].title = title
            journalEntries[index].content = content
        }
        resetFields()
    }

    func deleteEntry(entry: JournalEntry) {
        journalEntries.removeAll { $0.id == entry.id }
    }

    func resetFields() {
        addingJournal = false
        editingJournal = nil
        title = ""
        content = ""
    }
}

