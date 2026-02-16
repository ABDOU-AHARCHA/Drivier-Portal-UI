# Driver Portal — Flutter UI

A driver-facing mobile app UI built with Flutter.
Clean, modern design with smooth animations and a polished feel.

---

## Demo

![App Demo](https://raw.githubusercontent.com/ABDOU-AHARCHA/Drivier-Portal-UI/main/screenshots/app_video.mp4)

---

## Screenshots

| Home (Offline) | Home (Online) | Active Trip | Settings | Side Drawer |
|:-:|:-:|:-:|:-:|:-:|
| ![Home Offline](https://raw.githubusercontent.com/ABDOU-AHARCHA/Drivier-Portal-UI/main/screenshots/homescreen_offline.jpeg) | ![Home Online](https://raw.githubusercontent.com/ABDOU-AHARCHA/Drivier-Portal-UI/main/screenshots/home_screen.jpeg) | ![Active Trip](https://raw.githubusercontent.com/ABDOU-AHARCHA/Drivier-Portal-UI/main/screenshots/active_trip.jpeg) | ![Settings](https://raw.githubusercontent.com/ABDOU-AHARCHA/Drivier-Portal-UI/main/screenshots/setting.jpeg) | ![Drawer](https://raw.githubusercontent.com/ABDOU-AHARCHA/Drivier-Portal-UI/main/screenshots/side_drawer.jpg) |

---

## Features

- Shopify-style floating bottom navigation bar
- Online / Offline toggle with smooth animation
- Ride request card that slides up with Accept / Decline
- Route screen with visual A → B map and trip info
- Dark-themed side drawer with Settings and History
- Settings screen with adjustable price configuration
- Smooth page transitions and haptic feedback
- Responsive across all Android screen sizes

---

## Tech Stack

- **Flutter & Dart**
- **Google Fonts** — Inter typography
- **Material 3** — Design system
- **CustomPainter** — Map and route drawing

---

## Project Structure

```
lib/
├── main.dart
├── constants/
│   └── app_constants.dart       # Colors & mock data
├── screens/
│   ├── home_screen.dart         # Main map screen
│   ├── route_screen.dart        # Active trip screen
│   └── settings_screen.dart     # Price configuration
└── widgets/
    ├── ride_offer_card.dart      # Ride request card
    └── shopify_bottom_nav.dart   # Custom bottom navbar
```

---

## Getting Started

```bash
# Clone the repo
git clone https://github.com/ABDOU-AHARCHA/Drivier-Portal-UI.git

# Install dependencies
flutter pub get

# Run the app
flutter run

# Build APK
flutter build apk --release --split-per-abi
```

---

## Note

This is a **front-end only** project. All data is mocked.
No backend, no real map integration — built purely to demonstrate UI and navigation skills.

---

**Abdelilah Aharcha**
