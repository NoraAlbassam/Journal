import SwiftUI

// now this struct represents the main content of the app's UI
struct JournalView: View {
    @State private var journalEntries: [JournalEntry] = []
    @State private var addingJournal = false
    @State private var editingJournal: JournalEntry? // this declares an optional variable editingJournal of type JournalEntry. it will hold the entry that the user is currently editing or nil if no entry is being edited or when user cancels
    @State private var selectedFilter: String = "All"
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var searchBar: String = ""
    // 👆changes to these variables will automatically update the UI les go

    /*
     filteredEntries returns an array of JournalEntry objects that meet specific conditions.
     is computed property
     */
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

    var body: some View {
        NavigationView {
            VStack {
                if journalEntries.isEmpty {
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
                } else {
                    List {
                        ForEach(filteredEntries) { entry in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(entry.title)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.lvn)

                                    Spacer()
                                    Button(action: {
                                        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
                                            journalEntries[index].isBookmarked.toggle()
                                        }
                                    }) {
                                        Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                                            .font(.system(size: 24))
                                            .foregroundColor(.lvn)
                                    }
                                }
                                Text(entry.date.formatted(date: .numeric, time: .omitted))
                                    .font(.subheadline)
                                Text(entry.content)
                                    .font(.body)
                            }
                            .swipeActions(edge: .leading) {
                                Button(action: {
                                    onEdit(entry: entry)
                                }) {
                                    Image(systemName: "pencil")
                                }
                                .tint(Color("7F"))
                            }
                            .swipeActions(edge: .trailing) {
                                Button(action: {
                                    onDelete(entry: entry)
                                }) {
                                    Image(systemName: "trash.fill")
                                }
                                .tint(Color("FF4"))
                            }
                        }
                    }
                    .searchable(text: $searchBar)
                    .listRowSpacing(15)
                }
            }
            .navigationTitle("Journal")
            .navigationBarItems(trailing: HStack {
                Menu {
                    Button("Bookmark") { selectedFilter = "Bookmarked" }
                    Button("Journal Date") { selectedFilter = "Sorted by Date" }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color("1F"))
                            .frame(width: 30, height: 30)
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundColor(.lvn)
                    }
                }

                Button(action: {
                    // this reset fields before presenting the sheet
                    title = ""
                    content = ""
                    addingJournal = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color("1F"))
                            .frame(width: 30, height: 30)
                        Image(systemName: "plus")
                            .foregroundColor(.lvn)
                    }
                }
            })
            .sheet(isPresented: $addingJournal) {
                JournalEntryEditor(title: $title, content: $content, onSave: {
                    let newEntry = JournalEntry(title: title, date: Date(), content: content) // to create a new entry
                    journalEntries.append(newEntry) // to add the new entry to the list
                    resetFields() // reset fields after saving
                }, onCancel: {
                    resetFields() // reset fields if canceled
                })
            }
            .sheet(item: $editingJournal) { entry in
                JournalEntryEditor(title: $title, content: $content, onSave: {
                    if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
                        journalEntries[index].title = title
                        journalEntries[index].content = content
                    }
                    resetFields() // reset fields after saving
                }, onCancel: {
                    // here it restores original title and content when canceling edit
                    if let originalEntry = editingJournal {
                        title = originalEntry.title
                        content = originalEntry.content
                    }
                    resetFields() // reset fields if canceled
                })
                .onAppear {
                    title = entry.title // populate fields with the existing entry
                    content = entry.content
                }
            }
        }
    }

    private func onEdit(entry: JournalEntry) {
        editingJournal = entry
    }

    private func onDelete(entry: JournalEntry) {
        journalEntries.removeAll { $0.id == entry.id }
    }

    private func resetFields() {
        addingJournal = false
        editingJournal = nil
        title = ""
        content = "" 
    }
}

#Preview {
    JournalView()
}
