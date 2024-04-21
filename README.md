# CzasWolny

CzasWolny is a portable helper designed specifically for students at our university. It aims to make student life more organized and collaborative.

## Features

### Account Creation
Students can create their own accounts to personalize their experience. This feature allows students to have a personalized dashboard and settings.

![Simulator Screen Recording - iPhone 15 - 2024-04-21 at 18 41 56](https://github.com/viachaslauhryniuk/Czas-Wolny-Project/assets/43450673/dc9b04d3-f219-4d31-9caa-92a4734e5093)


### Schedule Viewing
Students can view their schedules at any time. This feature fetches data from the university database and presents it in a clean and organized manner.

![Simulator Screen Recording - iPhone 15 - 2024-04-21 at 18 44 47](https://github.com/viachaslauhryniuk/Czas-Wolny-Project/assets/43450673/57e72c4b-ee6a-47ef-93fc-345bd6e71beb)

### Deadline Tracking
Deadlines set by professors are displayed to ensure no important dates are missed. Each deadline is highlighted and students receive reminders as the date approaches.

![Simulator Screen Recording - iPhone 15 - 2024-04-21 at 18 45 33](https://github.com/viachaslauhryniuk/Czas-Wolny-Project/assets/43450673/f1ae2e07-37a1-414a-97c4-4d63c827ce3b)


### Chat Creation
Students can create chats to communicate and share files with their peers. This feature supports text messages, image messages, and file attachments.

![Simulator Screen Recording - iPhone 15 - 2024-04-21 at 18 46 49](https://github.com/viachaslauhryniuk/Czas-Wolny-Project/assets/43450673/9d18acdf-667c-497c-9482-35272f4ccaae)


## Technical Stack

- **Language**: Swift+ SwiftUI
- **Package Managers**: SwiftPM, CocoaPods
- **Architecture**: MVVM
- **Backend**: Firebase with useful JS functions added
- **Linting**: SwiftLint
Linting rules:
```
excluded:
  - Pods
  
disabled_rules:
  trailing_whitespace

line_length:
  warning: 150
  error: 200
  ignores_comments: true
  ignores_urls: true

identifier_name:
  min_length:
    warning: 1
    error: 1
```
- **Email APIs**: Several APIs are used for email sending and verification

## Installation

To try CzasWolny, clone the repository and run it in your Xcode environment.

## Contact

Viachaslau Hryniuk
hryniukviachaslau@gmail.com
+48793637669
