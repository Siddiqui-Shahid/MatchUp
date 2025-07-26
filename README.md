# Match Finder App

Match Finder App is an iOS application that allows users to view and match with potential partners. The app supports offline functionality by using Core Data for data persistence. The app fetches images using WDImage, makes API calls with URLSession, and uses the Combine framework to maintain data flow.

## Features

- Display a list of matches.
- Match with partners even when offline.
- Offline data is fetched from Core Data.
- Image display using WDImage.
- API calls with URLSession.
- Data flow management using Combine framework.

## Screenshots


## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+

## Installation

1. Clone the repo
   ```sh
   git clone https://github.com/yourusername/MatchFinderApp.git
2. Go to the project folder and install the SDWebImageSwiftUI pods
   ```sh
   pod install

## Usage

Upon launching the app, you will see a list of matches. You can swipe to match with partners. If you are offline, the app will fetch the data from Core Data to ensure you can continue matching without an internet connection.


## Technologies Used

- **Swift**: The programming language used for development.
- **WDImage**: Used for image display.
- **URLSession**: Used for making API calls.
- **Combine**: Used for managing data flow.
- **Core Data**: Used as the core database for data persistence.

## Screenshots

<p float="left">
  <img src="https://raw.githubusercontent.com/Siddiqui-Shahid/MatchUp/refs/heads/main/MatchUp/MatchUp/Screenshot/BaseUI.png" width="200">
  <img src="https://raw.githubusercontent.com/Siddiqui-Shahid/MatchUp/refs/heads/main/MatchUp/MatchUp/Screenshot/Search.png" width="200">
  <img src="https://raw.githubusercontent.com/Siddiqui-Shahid/MatchUp/refs/heads/main/MatchUp/MatchUp/Screenshot/AcceptedAndRejected.png" width="200">
</p>
