import SwiftUI
// modify them
struct SplashScreen: View {
    @State private var scale: CGFloat = 1.5
    @State private var journalTextOffset: CGFloat = -150
    @State private var thoughtsTextOffset: CGFloat = 150
    @State private var showJournalEntry = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 20/255, green: 20/255, blue: 32/255),
                    Color(red: 0, green: 0, blue: 0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Image("bookie")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .animation(Animation.easeInOut(duration: 1), value: scale)
                    .onAppear {
                        withAnimation {
                            scale = 1.1
                        }
                    }
                    .frame(width: 77.7, height: 101)

                Text("**Journali**")
                    .font(.system(size: 42, weight: .heavy))
                    .foregroundColor(.white)
                    .padding()
                    .offset(x: journalTextOffset)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1)) {
                            journalTextOffset = 0
                        }
                    }
                
                Text("Your thoughts, your story")
                    . font(. system(size: 18))
                    
                    .foregroundColor(.white)
                    .offset(x: thoughtsTextOffset)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1)) {
                            thoughtsTextOffset = 0
                        }
                    }
            }
            .padding()
            .onAppear {
                // transition to main page (journal entry) after 1.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showJournalEntry = true
                    }
                }
            }
            .fullScreenCover(isPresented: $showJournalEntry) {
                JournalView()
            }
        }
    }
}

#Preview {
    SplashScreen()
}

@main
struct JournalApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}
