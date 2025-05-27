import SwiftUI
import SwiftData

struct JournalView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.date, order: .reverse) private var journalEntries: [JournalEntry]
    
    @StateObject private var viewModel = JournalViewModel()
    
    private var filteredEntries: [JournalEntry] {
        let filtered = journalEntries.filter {
            viewModel.searchBar.isEmpty ||
            $0.title.localizedCaseInsensitiveContains(viewModel.searchBar) ||
            $0.content.localizedCaseInsensitiveContains(viewModel.searchBar)
        }
        
        switch viewModel.selectedFilter {
        case "Bookmarked":
            return filtered.filter { $0.isBookmarked }
        case "Sorted by Date":
            return filtered.sorted { $0.date > $1.date }
        default:
            return filtered
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if filteredEntries.isEmpty {
                    emptyJournalView
                } else {
                    entriesListView
                }
            }
            .navigationTitle("Journal")
            .navigationBarItems(trailing: navigationBarButtons)
            .sheet(isPresented: $viewModel.addingJournal) {
                JournalEntryEditor(
                    title: $viewModel.title,
                    content: $viewModel.content,
                    onSave: addEntry,
                    onCancel: viewModel.resetFields
                )
            }
            .sheet(item: $viewModel.editingJournal) { entry in
                JournalEntryEditor(
                    title: $viewModel.title,
                    content: $viewModel.content,
                    onSave: {
                        editEntry(entry: entry)
                    },
                    onCancel: viewModel.resetFields
                )
                .onAppear {
                    viewModel.title = entry.title
                    viewModel.content = entry.content
                }
            }
        }
    }
    
    private var emptyJournalView: some View {
        Group {
            Image("bookie")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            Text("**Begin Your Journal**")
                .font(.system(size: 24, weight: .heavy))
                .foregroundColor(.lvn)
                .padding()
            Text("Craft your personal diary, tap the \n plus icon to begin")
                .multilineTextAlignment(.center)
                .font(.subheadline)
        }
    }
    
    private var entriesListView: some View {
        List {
            ForEach(filteredEntries) { entry in
                VStack(alignment: .leading) {
                    HStack {
                        Text(entry.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.lvn)
                        
                        Spacer()
                        Button {
                            toggleBookmark(entry: entry)
                        } label: {
                            Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 24))
                                .foregroundColor(.lvn)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    Text(entry.date.formatted(date: .numeric, time: .omitted))
                        .font(.subheadline)
                    Text(entry.content)
                        .font(.body)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        viewModel.editingJournal = entry
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .tint(Color("7F"))
                }
                .swipeActions(edge: .trailing) {
                    Button {
                        deleteEntry(entry: entry)
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                    .tint(Color("FF4"))
                }
            }
        }
        .searchable(text: $viewModel.searchBar)
        .foregroundColor(.accentColor)
        .listRowSpacing(15)
    }
    
    private var navigationBarButtons: some View {
        HStack {
            Menu {
                Button("Bookmark") { viewModel.selectedFilter = "Bookmarked" }
                Button("Journal Date") { viewModel.selectedFilter = "Sorted by Date" }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color("1F"))
                        .frame(width: 30, height: 30)
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundColor(.lvn)
                }
            }
            
            Button {
                viewModel.title = ""
                viewModel.content = ""
                viewModel.addingJournal = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Color("1F"))
                        .frame(width: 30, height: 30)
                    Image(systemName: "plus")
                        .foregroundColor(.lvn)
                }
            }
        }
    }
        
    private func addEntry() {
        let newEntry = JournalEntry(
            title: viewModel.title,
            content: viewModel.content,
            date: Date(),
            isBookmarked: false
        )
        modelContext.insert(newEntry)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save new entry: \(error)")
        }
        
        viewModel.resetFields()
    }
    
    private func editEntry(entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries[index].title = viewModel.title
            journalEntries[index].content = viewModel.content
            
            do {
                try modelContext.save()
            } catch {
                print("Failed to save edited entry: \(error)")
            }
        }
        viewModel.resetFields()
    }
    
    private func deleteEntry(entry: JournalEntry) {
        modelContext.delete(entry)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete entry: \(error)")
        }
    }
    
    private func toggleBookmark(entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries[index].isBookmarked.toggle()
            do {
                try modelContext.save()
            } catch {
                print("Failed to toggle bookmark: \(error)")
            }
        }
    }
}
