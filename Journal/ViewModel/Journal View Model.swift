import SwiftUI
import SwiftData

@MainActor
class JournalViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var addingJournal: Bool = false
    @Published var editingJournal: JournalEntry? = nil
    @Published var searchBar: String = ""
    @Published var selectedFilter: String = "All"
    @Published var isDateDescending: Bool = true
    
    func resetFields() {
        addingJournal = false
        editingJournal = nil
        title = ""
        content = ""
    }
}
