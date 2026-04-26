# 📍 EventFinder

A Flutter mobile application that helps users discover and explore nearby events such as concerts, sports events, and social gatherings — built as part of an internship assignment.

---

## 📲 Screens Implemented

### 1. Home Screen
- Displays a list of events fetched dynamically from a mock API
- Scrollable event cards showing image, title, date & time, and location
- Search bar UI
- Loading spinner, error state, and empty state handling

### 2. Event Detail Screen
- Navigate to this screen by tapping any event card on the Home Screen
- Shows full event details: banner image, title, category, date & time, location, and description
- "Get Tickets" CTA button

## 🌐 Mock API

Events are fetched via a custom GET endpoint created using **Mocky**.


**Sample JSON structure:**
```json
[
  {
    "id": "1",
    "title": "Karachi Music Fest",
    "category": "Music",
    "date": "2025-05-10",
    "time": "7:00 PM",
    "location": "Beach View Park, Karachi",
    "imageUrl": "https://...",
    "distance": "2.3 km",
    "description": "An evening of live music featuring local and international artists."
  }
]
```

---

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── di/
│   │   └── injection.dart
│   ├── network/
│   │   └── dio_client.dart
│   └── theme/
│       └── theme_cubit.dart
├── features/
│   └── events/
│       ├── data/
│       │   ├── models/
│       │   │   └── event_model.dart
│       │   └── services/
│       │       └── event_services.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── events_bloc.dart
│           │   ├── events_event.dart
│           │   └── events_state.dart
│           ├── screens/
│           │   ├── event_detail_screen.dart
│           │   ├── home_screen.dart
│           │   └── splash_screen.dart
│           └── widgets/
│               └── events_card.dart
└── main.dart

---

## ⚙️ Tech Stack & Packages

| Package | Purpose |
|---|---|
| `flutter_bloc` | State management (BLoC pattern) |
| `dio` | HTTP client for API calls |
| `get_it` | Dependency injection |
| `equatable` | Value equality for BLoC states |
| `cached_network_image` | Efficient image loading & caching |
| `flutter_card_swiper` | Swipeable event cards |
| `flutter_launcher_icons` | Custom app icon |

---

## ✨ Key Features

- Dynamic data fetching from mock REST API
- BLoC-based state management with loading / error / success states
- Smooth splash screen with sequential animations
- Cached network images for performance
- Clean navigation: Splash → Home → Event Detail
- Feature-first folder architecture
- Centralized dependency injection with GetIt and Dio

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.10.8)
- Dart SDK
- Android Studio / VS Code

### Run the app

```bash
git clone https://github.com/Sabeen-Ahmad/event_finder.git
cd event_finder
flutter pub get
flutter run
```

---

## 📤 Submission

- **GitHub:** https://github.com/Sabeen-Ahmad/event_finder
- **Mock API:** `(https://github.com/Sabeen-Ahmad/event_finder_api)`
- **APK / Screen Recording:** `https://canva.link/bh4covtzkyxbyqf](https://canva.link/yx72gbekpvxts14`

---

## 💬 About This Project

This app was developed as part of an internship assignment to demonstrate Flutter UI development, REST API integration, state management using BLoC, and clean project architecture. The two screens implemented are the Home Screen and Event Detail Screen, connected via standard Flutter navigation. A feature-first folder structure was used to keep concerns separated and the codebase scalable. Key challenges included setting up BLoC with GetIt dependency injection and handling all API states gracefully.
