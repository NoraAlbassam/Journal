import SwiftUI

// now this struct represents the main content of the app's UI (view)
struct JournalView: View {
    @StateObject private var viewModel = JournalViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.journalEntries.isEmpty {
                    emptyJournalView
                } else {
                    entriesListView
                }
            }
            .navigationTitle("Journal")
            .navigationBarItems(trailing: navigationBarButtons)
            .sheet(isPresented: $viewModel.addingJournal) {
                JournalEntryEditor(title: $viewModel.title, content: $viewModel.content, onSave: {
                    viewModel.addEntry()
                }, onCancel: {
                    viewModel.resetFields()
                })
            }
            .sheet(item: $viewModel.editingJournal) { entry in
                JournalEntryEditor(title: $viewModel.title, content: $viewModel.content, onSave: {
                    viewModel.editEntry(entry: entry)
                }, onCancel: {
                    viewModel.resetFields()
                })
                .onAppear {
                    if let originalEntry = viewModel.editingJournal {
                        viewModel.title = originalEntry.title
                        viewModel.content = originalEntry.content
                    }
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
            ForEach(viewModel.filteredEntries) { entry in
                VStack(alignment: .leading) {
                    HStack {
                        Text(entry.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.lvn)

                        Spacer()
                        Button(action: {
                            if let index = viewModel.journalEntries.firstIndex(where: { $0.id == entry.id }) {
                                viewModel.journalEntries[index].isBookmarked.toggle()
                            }
                        }) {
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
                    Button(action: {
                        viewModel.editingJournal = entry
                    }) {
                        Image(systemName: "pencil")
                    }
                    .tint(Color("7F"))
                }
                .swipeActions(edge: .trailing) {
                    Button(action: {
                        viewModel.deleteEntry(entry: entry)
                    }) {
                        Image(systemName: "trash.fill")
                    }
                    .tint(Color("FF4"))
                }
            }
        }
        .searchable(text: $viewModel.searchBar)
        .accentColor(.A_4)
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

            Button(action: {
                // this reset fields before presenting the sheet
                viewModel.title = ""
                viewModel.content = ""
                viewModel.addingJournal = true
            }) {
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
}
