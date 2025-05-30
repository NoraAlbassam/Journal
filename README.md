# Journali - Your Thoughts, Your Story!

A simple, clean journaling app built with SwiftUI and SwiftData for iOS.

## Overview

Journali allows users to create, edit, and manage personal journal entries. Users can bookmark favorite entries, search through their journals, and sort entries by date. The app features a splash screen and smooth UI with SwiftUI components.

## Features

- Create and save journal entries with title, content, and date.
- Edit and delete existing journal entries.
- Bookmark important entries for easy access.
- Search journal entries by title or content.
- Sort entries by date or filter bookmarked entries.
- Splash screen with animated logo
- Persistent storage using SwiftData with `@Model` entities.

## Technologies

- Swift 5+
- SwiftUI for user interface.
- SwiftData for local data persistence.
- iOS 17+ (SwiftData requires iOS 17 or newer).

## Architecture

- MVVM (Model-View-ViewModel) design pattern.
- `JournalEntry`: SwiftData data model annotated with `@Model`
- `JournalViewModel`: Manages journal data operations and business logic.
- `JournalView` and `JournalEntryEditor`: SwiftUI views displaying and editing entries.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/journali.git
- Open `Journali.xcodeproj` in Xcode 15 or newer
- Build and run on a device or simulator running iOS 17+

## Usage

- Tap the **plus (+)** icon to add a new journal entry.
- Use the filter menu to sort or show bookmarked entries.
- Swipe left on an entry to delete or swipe right to edit.
- Tap the bookmark icon to toggle bookmarking on an entry.
- Use the search bar to quickly find journal entries by title or content.

- ## Screenshots

| Main Journal View | Adding a Journal Entry | Filtering and Searching | Edit/Delete |
|-------------------|-----------------------|-------------------------|-------------------|
| <img src="https://github.com/user-attachments/assets/b25be791-80f8-4dca-87c4-ffff8bea9f89" alt="Main Journal View" width="200"/> | <img src="https://github.com/user-attachments/assets/c825b4ba-57cf-4583-b3f7-aa258b91c8d4" alt="Adding a Journal Entry" width="200"/> | <img src="https://github.com/user-attachments/assets/01689e41-b217-40e8-b83c-acc87536dd11" alt="Filtering and Searching" width="200"/> | <img src="https://github.com/user-attachments/assets/cb3fe157-eb16-4ffc-af56-e189d5199173" alt="Edit/Delete Title" width="200"/> |

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests for improvements or bug fixes :)

## Credits and Acknowledgments
- **Project Developed by**: Nora Albassam
- **UI Design by**: Mentor Somayah

This project is intended for personal use only and may not be sold, redistributed, or shared publicly. All rights reserved.

