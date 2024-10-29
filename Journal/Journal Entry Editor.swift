import SwiftUI

struct JournalEntryEditor: View {
    @Binding var title: String
    @Binding var content: String
    var onSave: () -> Void // closure to execute on save & cancel 👇
    var onCancel: () -> Void

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                TextField("**Title**", text: $title, axis: .vertical)
                    .font(.system(size: 34, weight: .heavy))
                    .accentColor(.A_4)
                    .padding()

                Text(Date.now.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray)
                    .padding()

                TextField("Type your Journal...", text: $content, axis: .vertical)
                    .font(.system(size: 20))
                    .accentColor(.A_4)
                    .padding()
                
                Spacer()
            } // here are self-contained actions that modify the state of the app or dismiss the editor PERIODTT
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel() // here im calling the onCancel closure (same w save down below)
                    }
                    .foregroundColor(Color("A4"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("**Save**") {
                        onSave()
                    }
                    .foregroundColor(Color("A4"))
                }
            }
        }
    }
}
