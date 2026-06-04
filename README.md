# Ryde — Decentralized Ride-Sharing Mobile App

**Ryde** is a cross-platform mobile application that connects passengers with drivers for carpooling and uses the **Cardano blockchain (ADA)** for secure, transparent fare payments. Built with Flutter for iOS and Android.

---

## Features

- **Ride Search & Booking** — Search rides by destination, browse available options, and book in seconds
- **Real-Time Trip Tracking** — Live driver location updates and status changes via Firebase
- **Blockchain Payments** — Trip fares paid in ADA (Cardano cryptocurrency)
- **QR Code Rewards** — Scan ride QR codes to earn ADA
- **Push Notifications** — FCM-based alerts for every trip lifecycle event
- **OTP Authentication** — Firebase phone verification at signup
- **Driver Onboarding** — Any user can register as a driver with vehicle and document upload
- **Trip History** — Full log of active and completed rides
- **Wallet Integration** — Cardano wallet balance and address management

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Provider (ChangeNotifier) |
| Navigation | GetX |
| HTTP Client | Dio + CookieJar |
| Local Storage | SharedPreferences |
| Backend | Django REST Framework (`https://app.arcaccra.com/`) |
| Real-time | Firebase Firestore |
| Auth | Firebase Auth (Phone OTP) |
| Push Notifications | Firebase Cloud Messaging (FCM v1) |
| Maps | Google Maps Flutter |
| Location | Geolocator |
| Blockchain | Cardano (ADA) |
| QR Scanning | mobile_scanner |

---

## Project Structure

```
ridechain_mobile/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── app/                      # Root widget, theme, flavor config
│   ├── core/                     # Cache, utilities, constants, providers
│   ├── data/                     # Models, API constants, DI locator
│   ├── providers/                # AuthVm, RideProvider (ChangeNotifier)
│   ├── services/                 # HTTP, auth, rides, Firebase, FCM, location
│   └── ui/
│       ├── screens/              # All app screens by feature
│       └── shared_widgets/       # Reusable UI components
├── assets/
│   ├── images/                   # PNG assets
│   └── svgs/                     # SVG icons
├── secrets/                      # Service account keys (git-ignored)
├── .env                          # Environment variables (git-ignored)
├── ios/                          # iOS native project
└── android/                      # Android native project
```

---

## Installation & Setup

**Prerequisites:** Flutter SDK, Dart, Android Studio / Xcode

```bash
# Clone
git clone https://github.com/your-username/ridechain-mobile.git
cd ridechain-mobile

# Install dependencies
flutter pub get

# Run (ensure a device/simulator is connected)
flutter run

# Build for production
flutter build apk          # Android
flutter build ios          # iOS
```

**Environment setup:**

Create a `.env` file at the project root:
```
PATH_TO_SECRET=secrets/ridechain-key.json
PROJECT_ID=ridechain-c7650
```

Place the Google service account JSON at `secrets/ridechain-key.json` (used for FCM v1 API OAuth token generation).

---

## Documentation

See [DOCUMENTATION.md](./DOCUMENTATION.md) for the full technical reference including:
- Complete screen inventory and navigation flow
- All API endpoints
- Data models
- State management details
- Firebase integration
- Theme and design system
- Platform permissions

---

## Platform Info

| Property | Value |
|---|---|
| App Name | Ryde |
| Bundle / App ID | `app.arc.ridex` |
| Version | 1.0.2+4 |
| Min iOS | 13+ |
| Min Android SDK | 21+ |
| Firebase Project | `ridechain-c7650` |
| Base API URL | `https://app.arcaccra.com/` |

---

## License

MIT License
