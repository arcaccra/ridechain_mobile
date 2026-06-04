# Ryde — Full Application Documentation

**App Name:** Ryde
**Version:** 1.0.2+4
**Platform:** Flutter (iOS & Android)
**Base API URL:** `https://app.arcaccra.com/`
**Bundle / App ID:** `app.arc.ridex`
**Firebase Project:** `ridechain-c7650`

---

## Table of Contents

1. [Application Overview](#1-application-overview)
2. [Design System & Theme](#2-design-system--theme)
3. [Project Structure](#3-project-structure)
4. [App Initialization](#4-app-initialization)
5. [User Roles](#5-user-roles)
6. [Complete User App Flow](#6-complete-user-app-flow)
   - 6.1 [First-Time User Flow](#61-first-time-user-flow)
   - 6.2 [Registration Flow](#62-registration-flow)
   - 6.3 [Login Flow](#63-login-flow)
   - 6.4 [Ride Booking Flow (Passenger)](#64-ride-booking-flow-passenger)
   - 6.5 [Driver Onboarding Flow](#65-driver-onboarding-flow)
   - 6.6 [QR Code Reward Flow](#66-qr-code-reward-flow)
   - 6.7 [Wallet Management Flow](#67-wallet-management-flow)
7. [Screen Reference](#7-screen-reference)
   - 7.1 [Splash Screen](#71-splash-screen)
   - 7.2 [Onboarding Screen](#72-onboarding-screen)
   - 7.3 [Landing Screen](#73-landing-screen)
   - 7.4 [Login Screen](#74-login-screen)
   - 7.5 [OTP Screen](#75-otp-screen)
   - 7.6 [Register Screen](#76-register-screen)
   - 7.7 [Password Screen](#77-password-screen)
   - 7.8 [Image Capture Screen](#78-image-capture-screen)
   - 7.9 [Wallet Information Screen](#79-wallet-information-screen)
   - 7.10 [Home Screen](#710-home-screen)
   - 7.11 [Show Available Cars Screen](#711-show-available-cars-screen)
   - 7.12 [Confirm Ride Screen](#712-confirm-ride-screen)
   - 7.13 [Ride Arrival Screen](#713-ride-arrival-screen)
   - 7.14 [Pay For Trip Screen](#714-pay-for-trip-screen)
   - 7.15 [Payment Success Screen](#715-payment-success-screen)
   - 7.16 [Rate Driver Screen](#716-rate-driver-screen)
   - 7.17 [Scan Screen](#717-scan-screen)
   - 7.18 [Trip History Screen](#718-trip-history-screen)
   - 7.19 [Profile Screen](#719-profile-screen)
   - 7.20 [Settings Screen](#720-settings-screen)
8. [Navigation Architecture](#8-navigation-architecture)
9. [State Management](#9-state-management)
10. [Data Models](#10-data-models)
11. [API Layer](#11-api-layer)
12. [Services](#12-services)
13. [Firebase Integration](#13-firebase-integration)
14. [Blockchain & Wallet Integration](#14-blockchain--wallet-integration)
15. [Push Notifications](#15-push-notifications)
16. [Local Cache](#16-local-cache)
17. [Shared UI Components](#17-shared-ui-components)
18. [Platform Configuration](#18-platform-configuration)
19. [Environment & Secrets](#19-environment--secrets)
20. [Dependencies](#20-dependencies)

---

## 1. Application Overview

**Ryde** is a decentralized ride-sharing application that connects passengers with drivers for carpooling. The app eliminates intermediaries by facilitating direct bookings and using the **Cardano blockchain (ADA)** for fare payments. It is designed for cost-conscious economies, offering affordable, reliable transportation.

### Core Feature Set

| Feature | Description |
|---|---|
| Ride Search | Passengers search available rides by destination |
| Ride Booking | Book a seat on any available ride |
| Real-Time Tracking | Live driver GPS updates during the trip |
| ADA Payments | Trip fares settled in Cardano's ADA cryptocurrency |
| QR Code Rewards | Scan physical ride QR codes to earn ADA |
| Firebase OTP Auth | Phone number verification via SMS during signup |
| Driver Onboarding | Users can register as drivers by uploading vehicle and ID documents |
| Trip History | Complete record of past and active rides |
| Wallet Integration | Cardano wallet address management and live ADA balance |
| Push Notifications | Real-time alerts at every stage of the trip lifecycle |

### App Identity

- **App Name (display):** Ryde
- **Version:** 1.0.2+4
- **iOS Bundle ID:** `app.arc.ridex`
- **Android App ID:** `app.arc.ridex`
- **Backend:** Django REST Framework at `https://app.arcaccra.com/`

---

## 2. Design System & Theme

The app uses a consistent design language defined in `lib/app/theme.dart` and `lib/core/core_constants/colors.dart`.

### Color Palette

| Token | Hex | Usage |
|---|---|---|
| `PRIMARY_COLOR` | `#101010` | Primary text, dark backgrounds |
| `SECONDARY_COLOR` / `PURPLE` | `#5500bf` | Buttons, active states, highlights |
| `BACKGROUND` | `#f8f8ff` | App background (off-white) |
| `LIGHT_ACCENT` | `#f4eff9` | Cards, input backgrounds |
| `SUCCESS_GREEN` | `#00c950` | Payment success, positive states |
| `ERROR_RED` | `#dc0436` | Errors, destructive actions |
| `WARNING_ORANGE` | `#fbbc05` | Warnings, pending states |
| `WHITE` | `#ffffff` | Surfaces, text on dark |
| `GREY` | `#6d7280` | Secondary text, labels |
| `GREY_LIGHT` | `#adadad` | Placeholders, disabled elements |
| `BORDER_COLOR` | `#ececec` | Input borders, dividers |

### Typography

**Default Font Family:** Inter

**Installed Font Families:**

| Font | Weights | Usage |
|---|---|---|
| Inter | 300, 400, 500 | Body text (default) |
| Outfit | 400, 600, 700 | Headings, feature text |
| BeauSans | 400, 500, 700, 800 | Display headings, brand moments |
| Zain | 400 | Decorative/secondary text |

**Predefined Text Styles (`lib/app/theme.dart`):**

| Style Name | Font | Size | Weight | Usage |
|---|---|---|---|---|
| `appOutFitSmallStyle` | Outfit | 12px | 400 | Small labels |
| `appOutFitSmallMedium` | Outfit | 16px | 400 | Body with Outfit |
| `appOutFitSmallLarge` | Outfit | 20px | 400 | Section titles |
| `appBeauSansSmall` | BeauSans | 12px | 400 | Small brand text |
| `appBeauSansMedium` | BeauSans | 16px | 400 | Medium brand text |
| `appBeauSansLarge` | BeauSans | 20px | 400 | Large brand headings |
| `appInterSmallStyle` | Inter | 12px | 400 | Small body |
| `appInterSmallMedium` | Inter | 16px | 400 | Standard body |
| `appInterSmallLarge` | Inter | 20px | 400 | Large body |

### Spacing & Shape

| Token | Value | Usage |
|---|---|---|
| Button Border Radius | 33.5px | All primary/secondary buttons |
| Card Border Radius | 20.52px | Ride cards, modal panels |
| Padding Small | 8px | Inner content spacing |
| Padding Medium | 12px | Component padding |
| Padding Large | 16px | Screen horizontal padding |

### ThemeData

```
AppThemes.darkTheme
  ├─ fontFamily: "Inter"
  ├─ primaryColor: white (#ffffff)
  ├─ secondaryColor: purple (#5500bf)
  └─ backgroundColor: off-white (#f8f8ff)
```

### Responsive Sizing

The app uses `flutter_screenutil` initialized with a design baseline of **393 × 852 px** (iPhone 14 Pro). All sizes defined with `.w`, `.h`, `.sp`, and `.r` extensions scale proportionally across all device sizes.

---

## 3. Project Structure

```
ridechain_mobile/
├── lib/
│   ├── main.dart                          # Entry point
│   ├── firebase_options.dart              # Firebase auto-generated config
│   ├── app/
│   │   ├── app.dart                       # MyApp root widget
│   │   ├── app_config.dart                # Flavor & base URL
│   │   └── theme.dart                     # ThemeData, text styles
│   ├── core/
│   │   ├── cache_helper.dart              # SharedPreferences wrapper
│   │   ├── utility.dart                   # Shared utility functions
│   │   ├── providers.dart                 # Provider registrations list
│   │   └── core_constants/
│   │       ├── colors.dart                # Color palette constants
│   │       ├── label.dart                 # UI string constants
│   │       └── media.dart                 # Asset path constants
│   ├── data/
│   │   ├── constants/
│   │   │   └── api_constants.dart         # API endpoint path strings
│   │   ├── models/
│   │   │   ├── user_model.dart            # AuthModel, UserModel
│   │   │   ├── ride_model.dart            # RideModel, Driver, Passenger, DropOff
│   │   │   ├── wallet.dart                # Wallet, Balance
│   │   │   ├── driver_model.dart          # DriverModel
│   │   │   ├── booked_model.dart          # BookedRideModel
│   │   │   ├── location_model.dart        # LocationModel
│   │   │   └── api_response.dart          # ApiResponse wrapper
│   │   └── locator.dart                   # GetIt service locator setup
│   ├── providers/
│   │   ├── auth_provider.dart             # AuthVm (auth + user state)
│   │   ├── rides_provider.dart            # RideProvider (ride lifecycle)
│   │   └── base_provider.dart             # BaseProvider (shared logic)
│   ├── services/
│   │   ├── http_service.dart              # Dio HTTP client
│   │   ├── login_service.dart             # Auth & user API calls
│   │   ├── rides_service.dart             # Ride API calls
│   │   ├── trip_firebase_service.dart     # Firestore trip operations
│   │   ├── fcm_service.dart               # FCM push notifications
│   │   ├── location_service.dart          # GPS & map navigation
│   │   ├── dialog_service.dart            # Dialogs, snackbars, modals
│   │   ├── connectivity_service.dart      # Network monitoring
│   │   ├── image_service.dart             # Camera / gallery image selection
│   │   ├── nav_service.dart               # Navigation helpers
│   │   └── widget_animations.dart         # Reusable animation utilities
│   └── ui/
│       ├── screens/
│       │   ├── splash/                    # SplashScreen
│       │   ├── onboarding/                # OnboardingScreen
│       │   ├── landing/                   # LandingScreen
│       │   ├── auth/                      # LoginScreen, RegisterScreen, OTPScreen,
│       │   │                              #   PasswordScreen, ImageCaptureScreen,
│       │   │                              #   WalletInformation
│       │   ├── navigation/                # AppNavigationScreen (tab shell)
│       │   ├── home/                      # HomePage, ShowAvailableCars
│       │   ├── ride_confirmation/         # ConfirmRide
│       │   ├── ride_arrival_estimation/   # RideArrivalScreen
│       │   ├── pay_for_trip/              # PayForTrip, PaymentSuccessScreen
│       │   ├── rate_driver/               # RateDriverScreen
│       │   ├── scan/                      # ScanScreen
│       │   ├── trip_history/              # TripHistory
│       │   ├── profile/                   # ProfileScreen
│       │   ├── user/                      # User settings
│       │   └── settings/                  # SettingsScreen
│       └── shared_widgets/                # Reusable UI components
├── assets/
│   ├── images/                            # PNG images (empty.png, wallet.png, etc.)
│   └── svgs/                              # SVG icons
├── secrets/
│   └── ridechain-key.json                 # Google service account (git-ignored)
├── .env                                   # Environment variables (git-ignored)
├── pubspec.yaml                           # Dependencies & assets
├── ios/                                   # iOS native project
└── android/                               # Android native project
```

---

## 4. App Initialization

**Entry Point:** `lib/main.dart`

The app runs through a sequential startup sequence before presenting any UI:

```
main() async
 │
 ├─ 1. WidgetsFlutterBinding.ensureInitialized()
 │       Ensures Flutter engine is ready before async operations
 │
 ├─ 2. Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
 │       Initializes all Firebase services (Auth, Firestore, FCM)
 │
 ├─ 3. setUpLocator()
 │       Registers services in GetIt dependency injection container
 │
 ├─ 4. SharedPreferences.getInstance() + CacheHelper.instance.init()
 │       Hydrates the local cache layer for auth & user data
 │
 ├─ 5. FCMService.instance.initialize()
 │       Requests notification permissions and registers FCM handlers
 │
 ├─ 6. AppConfig.create(appName: "Ryde", baseUrl: "...", flavor: Flavor.prod)
 │       Stores global app configuration (base URL, flavor, name)
 │
 ├─ 7. SystemChrome.setSystemUIOverlayStyle(...)
 │       Sets white status bar with dark icons
 │
 └─ 8. runApp(MyApp())
```

**Root Widget (`MyApp`):**

```
MyApp (StatefulWidget)
 ├─ initState: ConnectionService.instance.initialize()
 │             — starts network monitoring; shows NoInternetModal if offline
 │
 └─ build:
     ├─ ScreenUtilInit(designSize: 393 × 852)
     │   — enables responsive sizing
     │
     └─ MultiProvider([AuthVm, RideProvider])
         └─ GetMaterialApp
             ├─ theme: AppThemes.darkTheme
             └─ home: SplashScreen
```

---

## 5. User Roles

The app supports two user roles. Every user starts as a **Passenger** and can optionally upgrade to a **Driver**.

### Passenger (Default Role)

- Can search and book rides
- Tracks driver on live map
- Pays in ADA via wallet
- Rates drivers after trips
- Scans QR codes to earn rewards
- Views trip history

### Driver (Optional Role)

- Must complete driver onboarding (vehicle details + documents)
- Creates and manages trip listings
- Receives booking requests via push notification
- Accepts or declines ride requests
- Updates trip status (en route → arrived → started)
- Receives ADA payment on trip completion

**Role Field:** `UserModel.isDriver: bool`

A user transitions to the driver role via the **Profile Screen** by tapping "Become a Driver" and completing the vehicle/document upload flow.

---

## 6. Complete User App Flow

### 6.1 First-Time User Flow

```
App Launch
    │
    ▼
SplashScreen (2 seconds, animated gradient)
    │
    ├─ CacheHelper.get("first-timer-key") == null or false
    │   ▼
    │  OnboardingScreen
    │   (3 feature introduction slides, PageView with DotsIndicator)
    │   ▼
    │  LandingScreen
    │   (welcome screen with Login + Register buttons)
    │   │
    │   ├─── [Login] ──► LoginScreen ──► AppNavigationScreen
    │   └─── [Register] ──► RegisterScreen (multi-step)
    │
    └─ CacheHelper.get("first-timer-key") == true AND auth token present
        ▼
       AuthVm.fetchUserInfo()
        ▼
       AppNavigationScreen (Bottom Tab Navigator)
```

---

### 6.2 Registration Flow

Registration is a **4-step sequential flow**, each step collecting data that is assembled into a single API payload.

```
RegisterScreen
    │
    ├─ Step 1: ImageCaptureScreen
    │   ─ User taps "Camera" or "Gallery" via ImageService
    │   ─ Selected File stored in AuthVm.imageFile
    │   ─ AuthVm.addToRegisterMap("avatar", imageFile)
    │
    ├─ Step 2: User Details Form
    │   ─ Full Name (required)
    │   ─ Email Address (required, email validation)
    │   ─ Phone Number (required, country code picker)
    │   ─ Country (country picker widget)
    │   ─ AuthVm.addToRegisterMap("full_name", ...)
    │   ─ AuthVm.addToRegisterMap("email", ...)
    │   ─ AuthVm.addToRegisterMap("phone_number", "+{code}{number}")
    │   ─ AuthVm.addToRegisterMap("country", countryCode)
    │
    ├─ Step 3: PasswordScreen
    │   ─ Password (required, minimum complexity)
    │   ─ Confirm Password (must match)
    │   ─ AuthVm.addToRegisterMap("password1", ...)
    │   ─ AuthVm.addToRegisterMap("password2", ...)
    │   ─ AuthVm.register()
    │       POST /apis/accounts/register/  (multipart/form-data with avatar)
    │       On success → cache token & user → navigate to WalletInformation
    │
    └─ Step 4: WalletInformation Screen
        ─ Enter Cardano wallet address (can scan a QR code to fill)
        ─ Confirm wallet address
        ─ AuthVm.updateWalletAddress({"address": walletAddress})
            POST /apis/accounts/wallets/
        ─ On success → AppNavigationScreen
```

**OTP Verification (during registration):**

When a phone number is submitted, Firebase Phone Auth is triggered:

```
AuthVm.sendOTP(phoneNumber)
    └─ FirebaseAuth.verifyPhoneNumber()
        └─ SMS OTP sent to user

OTPScreen
    ─ User enters 6-digit code in PinCodeFields widget
    ─ AuthVm.verifyOTP(otp)
        └─ PhoneAuthCredential sign-in → proceed to next step
```

---

### 6.3 Login Flow

```
LoginScreen
    ─ Email or Phone Number input
    ─ Password input
    ─ AuthVm.login()
        POST /apis/accounts/login/
        On success:
            ├─ Cache: AuthModel (token + user) under "auth-key"
            ├─ Cache: UserModel under "user-key"
            ├─ AuthVm.getWalletAddress() → cache wallet
            └─ Navigate to AppNavigationScreen
        On failure:
            └─ DialogService.showSnackBar(errorMessage)
```

**Returning User (Auto-Login):**

```
SplashScreen → CacheHelper.get("auth-key") exists
    └─ AuthVm.fetchUserInfo()
        ├─ Restore AuthModel, UserModel, Wallet from cache
        └─ Navigate to AppNavigationScreen
```

---

### 6.4 Ride Booking Flow (Passenger)

This is the primary passenger journey from searching to rating.

```
Step 1 — Search
─────────────────
HomePage (map view)
    ─ LocationService.checkLocationPermission()
    ─ Google Map centers on device GPS position
    ─ User selects a destination from dropdown (pre-loaded LocationModel list)
    ─ RideProvider.fetchRides(destination)
        GET /apis/rides_apis/rides/search/?drop_off={destination}
        RideState → searchingCars
        On results → RideState → carsAvailable
        Navigate to ShowAvailableCars


Step 2 — Browse Rides
──────────────────────
ShowAvailableCars
    ─ Scrollable list of AvailableCarCard widgets
    ─ Each card shows:
        • Driver name and avatar
        • Vehicle type, color, and plate number
        • Price per seat in ADA
        • Seats available
        • Departure and estimated arrival time
    ─ User taps a card
        └─ RideProvider.setSelectedRide(ride)
        └─ Navigate to ConfirmRide


Step 3 — Confirm Booking
─────────────────────────
ConfirmRide
    ─ Full ride summary:
        • Pickup and drop-off location
        • Departure and arrival time
        • Driver details (name, vehicle, plate)
        • Price per seat (ADA)
        • Seats available
    ─ User taps "Book Ride"
        ├─ RideProvider.bookRide(rideId, userId)
        │   POST /apis/rides_apis/rides/{rideId}/book/
        ├─ TripFirebaseService.requestToJoinTrip(tripId, userId)
        │   Writes: trips/{tripId}/requests/{userId} = { status: "pending" }
        ├─ FCMService.sendTripRequestNotification(driverFcmToken)
        │   Notifies driver of new booking request
        └─ RideState → awaitingDriverResponse
           Navigate to RideArrivalScreen


Step 4 — Awaiting Driver / En Route
─────────────────────────────────────
RideArrivalScreen (Firebase real-time listener)
    ─ Shows driver details:
        • Name and avatar
        • Vehicle type, color, plate number
        • Estimated arrival time
        • Driver phone number (tap to call via tel:// URL)
    ─ Google Map shows driver's live location
    ─ Firestore listener on trips/{tripId}:

    [Driver Accepts]
        └─ FCM notification to passenger: "Driver accepted"
           RideState → riderEnRoute
           Map shows driver moving toward pickup point

    [Driver Arrives at Pickup]
        └─ FCM notification: "Driver has arrived"
           RideState → driverAtLocation
           UI shows "Your driver has arrived" banner

    [Driver Starts Trip]
        └─ RideState → tripStarted
           Trip timer/tracking begins


Step 5 — Payment
─────────────────
PayForTrip
    ─ Shows:
        • Trip cost in ADA
        • User's wallet address (truncated)
        • Current ADA wallet balance
    ─ User taps "Confirm Payment"
        ├─ TripFirebaseService.completePayment()
        │   Writes: payments/{paymentId} = { status: "completed" }
        ├─ FCMService.sendPaymentNotification(driverFcmToken)
        └─ Navigate to PaymentSuccessScreen


Step 6 — Payment Confirmed
───────────────────────────
PaymentSuccessScreen
    ─ Success animation and confirmation message
    ─ Shows transaction summary
    ─ "Rate Your Driver" button → Navigate to RateDriverScreen


Step 7 — Rate Driver
─────────────────────
RateDriverScreen
    ─ 1–5 star rating (flutter_rating widget)
    ─ Quick-select keyword chips:
        Friendly | Punctual | Safe Driver | Good Music | Comfortable | Clean Car
    ─ Optional free-text review
    ─ "Submit" taps:
        ├─ RideProvider.rateTrip(body)
        │   POST /apis/book_rate_apis/ratings/
        └─ RideProvider.resetRideState()
           Navigate to TripHistory (completed tab)
```

---

### 6.5 Driver Onboarding Flow

Any registered user can become a driver from the Profile screen.

```
ProfileScreen → "Become a Driver" card (visible when UserModel.isDriver == false)
    │
    ▼
Driver Registration Form
    ─ Vehicle photo (camera or gallery)
    ─ Vehicle type (e.g., Honda Civic, Toyota Corolla)
    ─ Vehicle color
    ─ Vehicle plate number
    ─ Driver's license image (camera or gallery)
    ─ ID type selection (National ID, Passport, etc.)
    ─ ID number
    ─ ID front image
    ─ ID back image
    ─ Insurance certificate image
    ▼
Submit to backend
    ─ API creates DriverModel linked to UserModel
    ─ UserModel.isDriver → true
    ─ UserModel.driver → DriverModel populated
    ─ "Become a Driver" card disappears from ProfileScreen
```

---

### 6.6 QR Code Reward Flow

```
AppNavigationScreen → Scan tab
    │
    ▼
ScanScreen
    ─ Full-screen camera via mobile_scanner
    ─ Instruction overlay: "Scan your ride QR code to earn ADA"
    ─ Camera scans QR code from physical ride ticket or screen

[Valid QR Code Detected]
    ─ QR value parsed (matches BookedRideModel.qrcodeUuid)
    ─ ADA reward transaction triggered
    ─ Success confirmation shown

[Invalid QR Code]
    ─ Error snackbar via DialogService.showSnackBar()
```

QR codes are generated per booking (`BookedRideModel.qrCode`) and tied to a unique `qrcodeUuid`. Scanning earns the passenger ADA as an incentive for trip verification.

---

### 6.7 Wallet Management Flow

```
Registration
    └─ WalletInformation screen → POST /apis/accounts/wallets/
       Wallet created and linked to user account

Login
    └─ AuthVm.getWalletAddress()
       GET /apis/accounts/wallets/
       Wallet cached under "wallet-info-key"

ProfileScreen
    └─ Displays wallet address (truncated) and ADA balance

PayForTrip
    └─ Displays full wallet address and current ADA balance

Update Wallet
    └─ User can update wallet address via WalletInformation screen
       POST /apis/accounts/wallets/ (update)
```

**ADA Balance:** Fetched from the wallet API and stored in `Wallet.balance.ada` (display) and `Wallet.balance.lovelace` (raw value: 1 ADA = 1,000,000 lovelace).

---

## 7. Screen Reference

### 7.1 Splash Screen

**Path:** `lib/ui/screens/splash/splash_screen.dart`

**Purpose:** App entry point. Displays an animated gradient logo for approximately 2 seconds while determining where to send the user.

**Logic:**
- If `first-timer-key` is absent or false → navigate to `OnboardingScreen`
- If `first-timer-key` is true and `auth-key` is present → call `AuthVm.fetchUserInfo()` → navigate to `AppNavigationScreen`
- If `first-timer-key` is true but no `auth-key` → navigate to `LandingScreen`

**UI Elements:** Animated gradient background, app logo/wordmark, fade-in animation.

---

### 7.2 Onboarding Screen

**Path:** `lib/ui/screens/onboarding/onboarding_screen.dart`

**Purpose:** Introduces new users to the app's core value propositions across 3 slides.

**Slides:**
1. Ride-sharing concept and app benefits
2. Blockchain payment explanation (ADA / Cardano)
3. Community and safety features

**UI Elements:** PageView, DotsIndicator (page position), "Skip" and "Next" buttons, "Get Started" on last slide.

**On Complete:** Sets `first-timer-key = true` in CacheHelper → navigates to `LandingScreen`.

---

### 7.3 Landing Screen

**Path:** `lib/ui/screens/landing/landing_screen.dart`

**Purpose:** Welcome/entry point for returning first-timers after onboarding, or when they logout.

**UI Elements:** App logo, tagline, "Login" button (outlined), "Register" button (filled purple).

**Actions:**
- Login → `LoginScreen`
- Register → `RegisterScreen`

---

### 7.4 Login Screen

**Path:** `lib/ui/screens/auth/login_screen.dart`

**Purpose:** Authenticate an existing user with email or phone number and password.

**Form Fields:**
- Email or phone number input
- Password input (obscured, toggle visibility)

**Validation:** Both fields required; email format validated if `@` present.

**Actions:**
- Submit → `AuthVm.login()` → on success → `AppNavigationScreen`
- "Don't have an account?" → `RegisterScreen`

**Error Handling:** API errors shown via `DialogService.showSnackBar()`.

---

### 7.5 OTP Screen

**Path:** `lib/ui/screens/auth/otp_screen.dart`

**Purpose:** Firebase phone number verification using a 6-digit SMS OTP.

**UI Elements:** 6-cell `PinCodeFields` widget, "Resend OTP" timer, explanatory text showing the masked phone number.

**Logic:**
- `AuthVm.sendOTP(phone)` triggers Firebase phone verification
- `AuthVm.verifyOTP(code)` verifies the entered code
- On success → proceeds to the next registration step
- Resend available after 60-second countdown

---

### 7.6 Register Screen

**Path:** `lib/ui/screens/auth/register_screen.dart`

**Purpose:** Multi-step user registration. Hosts a `PageView` that advances through sub-screens.

**Sub-steps (embedded or navigated):**
1. Image capture (profile picture)
2. Personal details form (name, email, phone, country)
3. Password form

Each step calls `AuthVm.addToRegisterMap(key, value)` to build the API payload incrementally.

**Final Submission:** `AuthVm.register()` sends `POST /apis/accounts/register/` as `multipart/form-data` including the profile image.

---

### 7.7 Password Screen

**Path:** `lib/ui/screens/auth/password_screen.dart`

**Purpose:** Step within registration to set and confirm account password.

**Form Fields:**
- Password (obscured, toggle visibility)
- Confirm password (must match)

**Validation:** Passwords must match; minimum length enforced.

---

### 7.8 Image Capture Screen

**Path:** `lib/ui/screens/auth/image_capture_screen.dart`

**Purpose:** Collect user profile photo during registration.

**Options:**
- Camera capture via `ImagePicker.pickImage(ImageSource.camera)`
- Gallery selection via `ImagePicker.pickImage(ImageSource.gallery)`

**Behaviour:** Selected image previewed on screen; stored in `AuthVm.imageFile`.

---

### 7.9 Wallet Information Screen

**Path:** `lib/ui/screens/auth/wallet_information.dart`

**Purpose:** Register or update the user's Cardano wallet address. Appears as the final step of registration and is accessible from the profile.

**Form Fields:**
- Wallet address input (long string, Cardano addr1... format)
- Confirm wallet address

**QR Support:** A QR scan button allows the user to scan their wallet address QR code to auto-fill the field.

**Submission:** `AuthVm.updateWalletAddress({"address": walletAddress})` → `POST /apis/accounts/wallets/`

---

### 7.10 Home Screen

**Path:** `lib/ui/screens/home/home_screen.dart`

**Purpose:** Main passenger hub. Displays a full-screen Google Map centered on the user's current GPS location and allows ride search.

**UI Elements:**
- Google Map (full screen) with user location marker
- Destination search dropdown populated from `AuthVm.allLocations`
- Search button / auto-trigger on selection
- Location permission prompt on first load

**Logic:**
1. `LocationService.checkLocationPermission()` → request if needed
2. `LocationService.getCurrentUserLocation()` → center map
3. User selects destination → `RideProvider.fetchRides(destination)`
4. `RideState → searchingCars` → shows `RideSearchingLoader`
5. On results → `RideState → carsAvailable` → navigate to `ShowAvailableCars`

---

### 7.11 Show Available Cars Screen

**Path:** `lib/ui/screens/home/show_available_cars.dart`

**Purpose:** Display all rides matching the selected destination.

**UI Elements:**
- Scrollable `ListView` of `AvailableCarCard` widgets
- Each card shows: driver avatar + name, vehicle details, price per seat (ADA), seats available, departure time, estimated trip duration
- Empty state if no rides found

**Actions:**
- Tap a card → `RideProvider.setSelectedRide(ride)` → navigate to `ConfirmRide`
- Back button → return to `HomePage`

---

### 7.12 Confirm Ride Screen

**Path:** `lib/ui/screens/ride_confirmation/confirm_ride.dart`

**Purpose:** Final review before booking. Presents all ride details for the passenger to confirm.

**UI Elements:**
- `PickupDestinationWidget` — pickup and drop-off locations with map pin icons
- Driver info card — name, vehicle, plate, rating
- Trip details — departure time, seats available, price per seat
- "Book Ride" primary button

**Actions:**
- "Book Ride" →
  1. `RideProvider.bookRide(rideId, userId)` → `POST /apis/rides_apis/rides/{rideId}/book/`
  2. `TripFirebaseService.requestToJoinTrip(tripId, userId)`
  3. `FCMService.sendTripRequestNotification(...)` — notifies driver
  4. `RideState → awaitingDriverResponse`
  5. Navigate to `RideArrivalScreen`

---

### 7.13 Ride Arrival Screen

**Path:** `lib/ui/screens/ride_arrival_estimation/ride_arrival_screen.dart`

**Purpose:** Real-time tracking screen while the driver travels to the passenger's pickup location.

**UI Elements:**
- Google Map showing driver's current location (live updates from Firestore)
- `DriverEnRouteCard` — driver name, vehicle, plate, live ETA
- `AcceptedTripDetailWidget` — trip summary (pickup, dropoff, price)
- Contact driver button (tap-to-call via `tel://` URL launcher)
- Status banner updating as ride state changes

**State Transitions (driven by Firestore + FCM):**

| RideState | UI Indicator |
|---|---|
| `awaitingDriverResponse` | "Waiting for driver to accept…" |
| `riderEnRoute` | "Driver is on the way" + live map |
| `driverAtLocation` | "Your driver has arrived!" banner |
| `tripStarted` | "Trip in progress" → transition to `PayForTrip` |

---

### 7.14 Pay For Trip Screen

**Path:** `lib/ui/screens/pay_for_trip/pay_for_trip.dart`

**Purpose:** Post-trip payment confirmation using the user's Cardano wallet.

**UI Elements:**
- Trip cost displayed in ADA (e.g., "2.5 ADA")
- User's wallet address (truncated with copy button)
- Current ADA balance
- "Confirm Payment" primary button

**Payment Logic:**
1. `TripFirebaseService.completePayment()` — marks payment as complete in Firestore
2. `FCMService.sendPaymentNotification(driverFcmToken)` — notifies driver
3. Navigate to `PaymentSuccessScreen`

---

### 7.15 Payment Success Screen

**Path:** `lib/ui/screens/pay_for_trip/payment_success_screen.dart`

**Purpose:** Post-payment confirmation with success animation.

**UI Elements:**
- Animated success icon (green checkmark)
- "Payment Successful" heading
- Transaction summary (amount paid, driver name)
- "Rate Your Driver" button → `RateDriverScreen`

---

### 7.16 Rate Driver Screen

**Path:** `lib/ui/screens/rate_driver/rate_driver_screen.dart`

**Purpose:** Collect passenger feedback on the completed trip.

**UI Elements:**
- Driver avatar and name
- 1–5 star rating widget (`flutter_rating`)
- Quick-select keyword chips:
  - Friendly
  - Punctual
  - Safe Driver
  - Good Music
  - Comfortable
  - Clean Car
- Optional free-text review input
- "Submit Rating" button

**Submission:**
- `RideProvider.rateTrip(body)` → `POST /apis/book_rate_apis/ratings/`
- `RideProvider.resetRideState()` clears all ride state
- Navigate to `TripHistory` (completed tab)

---

### 7.17 Scan Screen

**Path:** `lib/ui/screens/scan/scan_screen.dart`

**Purpose:** Full-screen QR code scanner to validate ride tickets and earn ADA rewards.

**UI Elements:**
- Full-screen camera view using `mobile_scanner`
- Scan target overlay (animated frame)
- Instruction text: "Scan your ride QR code to earn ADA"
- Flashlight toggle button

**Logic:**
- Scans QR code and parses the value
- Validates against `BookedRideModel.qrcodeUuid`
- Valid scan → ADA reward transaction + success dialog
- Invalid scan → error snackbar

---

### 7.18 Trip History Screen

**Path:** `lib/ui/screens/trip_history/trip_history.dart`

**Purpose:** View all past and active trips.

**UI Elements:**
- `TabBar` with two tabs:
  - **My Trips** — Active and upcoming bookings
  - **Completed Trips** — Finished rides with receipt-style cards
- Each trip card shows: driver name, vehicle, route, date/time, price paid, booking status
- Empty state illustration (`assets/images/empty.png`) when no trips

**Data Source:** `TripFirebaseService.getUserTrips(userId)` — real-time Firestore stream.

---

### 7.19 Profile Screen

**Path:** `lib/ui/screens/profile/profile_screen.dart`

**Purpose:** View and manage user account information.

**UI Elements:**
- Profile avatar (tappable to update)
- Full name
- Email address
- Phone number
- Country
- Wallet address (truncated with copy icon)
- ADA balance
- "Become a Driver" card (only shown when `UserModel.isDriver == false`)
- Logout button

**Actions:**
- Tap avatar → `ImageCaptureScreen` (profile photo update)
- "Become a Driver" → driver registration flow
- Wallet address → `WalletInformation` screen (update wallet)
- Logout → `AuthVm.logout()` clears all cached data → `LandingScreen`

---

### 7.20 Settings Screen

**Path:** `lib/ui/screens/settings/settings.dart`

**Purpose:** App-level preferences and configuration.

**Contents:** App settings and preferences (notifications, account, support links).

---

## 8. Navigation Architecture

**Navigation Package:** GetX (`get`)

All navigation uses `Get.to()`, `Get.off()`, and `Get.offAll()` from the GetX package.

**Bottom Navigation Shell:**

`AppNavigationScreen` hosts a `BottomNav` widget with 4 tabs:

| Index | Tab Label | Screen | Icon |
|---|---|---|---|
| 0 | Home | `HomePage` | Home icon |
| 1 | Scan | `ScanScreen` | QR scan icon |
| 2 | History | `TripHistory` | Clock/list icon |
| 3 | Profile | `ProfileScreen` | Person icon |

**Full Navigation Map:**

```
SplashScreen
    │
    ├─ [New user] ──► OnboardingScreen ──► LandingScreen
    │                                          │
    │                                ┌─────────┴──────────┐
    │                           LoginScreen          RegisterScreen
    │                                │                     │
    │                           [OTPScreen]         [ImageCaptureScreen]
    │                                │                     │
    │                                │               [PasswordScreen]
    │                                │                     │
    │                                │            [WalletInformation]
    │                                │                     │
    └─ [Returning user] ─────────────┴─────────────────────┘
                                     ▼
                          AppNavigationScreen (4 tabs)
                           │          │         │          │
                        HomePage  ScanScreen TripHistory ProfileScreen
                           │
              ┌────────────┴───────────┐
              │                    (empty state)
      ShowAvailableCars
              │
         ConfirmRide
              │
      RideArrivalScreen
              │
         PayForTrip
              │
     PaymentSuccessScreen
              │
      RateDriverScreen
              │
         TripHistory (completed tab)
```

**State-Driven Navigation:**

Navigation from `HomePage` through the booking flow is driven by `RideState` changes in `RideProvider` rather than direct button presses, ensuring the UI always reflects the true trip state.

---

## 9. State Management

**Framework:** Provider package (`ChangeNotifier` pattern)

**Registered Providers** (`lib/core/providers.dart`):
```dart
MultiProvider(providers: [
  ChangeNotifierProvider<AuthVm>(create: (_) => AuthVm()),
  ChangeNotifierProvider<RideProvider>(create: (_) => RideProvider()),
])
```

---

### AuthVm — Authentication Provider

**File:** `lib/providers/auth_provider.dart`

Manages all authentication state, user profile data, and registration flow.

**State Properties:**

| Property | Type | Description |
|---|---|---|
| `_currentUser` | `AuthModel` | Active auth session (token + user) |
| `userWallet` | `Wallet` | User's Cardano wallet |
| `_model` | `UserModel` | Full user profile |
| `allDrivers` | `List<DriverModel>` | All registered drivers |
| `allLocations` | `List<LocationModel>` | Available trip locations |
| `walletAddress` | `String?` | Wallet address string |
| `imageFile` | `File?` | Selected profile photo |
| `_authIsLoading` | `bool` | Loading state flag |
| `_errorMessage` | `String?` | Last error message |
| `body` | `Map<String, dynamic>` | Registration payload accumulator |

**Key Methods:**

| Method | Description |
|---|---|
| `login()` | POST email/phone + password; cache result |
| `register()` | POST FormData registration payload |
| `sendOTP(phone)` | Trigger Firebase phone OTP |
| `verifyOTP(otp)` | Verify Firebase SMS code |
| `logout()` | Clear all cache keys |
| `getWalletAddress()` | GET wallet from API and cache |
| `fetchUserInfo()` | Restore AuthModel/UserModel/Wallet from cache |
| `getUserById(id)` | GET user profile by ID |
| `getAllDrivers()` | GET all drivers list |
| `getLocations()` | GET available locations |
| `captureProfilePicture(context)` | Open image picker |
| `updateWalletAddress(body)` | POST/PUT wallet address |
| `addToRegisterMap(key, value)` | Append to registration payload |

---

### RideProvider — Ride State Management

**File:** `lib/providers/rides_provider.dart`

Manages the full ride lifecycle from search to rating.

**RideState Enum:**

```dart
enum RideState {
  idle,                   // Default; destination input visible
  searchingCars,          // API request in flight
  carsAvailable,          // Search results returned
  awaitingDriverResponse, // Booking sent, waiting for driver accept
  riderEnRoute,           // Driver accepted; traveling to pickup
  driverAtLocation,       // Driver arrived at pickup point
  tripStarted,            // Trip actively in progress
}
```

**State Properties:**

| Property | Type | Description |
|---|---|---|
| `rides` | `List<RideModel>` | Available rides from search |
| `selectedRide` | `RideModel?` | Ride chosen by passenger |
| `bookedRide` | `BookedRideModel?` | Active booking data + QR code |
| `currentRideState` | `RideState` | Current stage of the ride lifecycle |

**Key Methods:**

| Method | Description |
|---|---|
| `fetchRides(destination)` | GET rides by drop-off |
| `setSelectedRide(ride)` | Store chosen ride |
| `bookRide(rideId, userId)` | POST booking request |
| `cancelBooking(rideId, userId)` | POST cancellation |
| `rateTrip(body)` | POST driver rating |
| `fetchCurrentActiveRide(rideId)` | GET latest ride state |
| `updateRideState(state)` | Manually transition RideState |
| `resetRideState()` | Clear all ride data → `idle` |

---

## 10. Data Models

**Location:** `lib/data/models/`

### `AuthModel`
```
token     String    JWT token for API Authorization header
message   String    Server message (e.g., "Login successful")
user      UserModel The authenticated user's profile
```

### `UserModel`
```
id                int
fullName          String
email             String
avatar            String         URL to profile image
phoneNumber       String
walletAddress     String         Cardano wallet address
country           String         ISO country code
currentLocation   List<double>   [latitude, longitude]
isDriver          bool           true if user has driver profile
driver            DriverModel?   Populated when isDriver is true
userRides         List<RideModel>
```

### `RideModel`
```
uuid              String
driver            Driver         Embedded driver profile
passengers        List<Passenger>
pickUp            dynamic        LocationModel or raw object
dropOff           dynamic        LocationModel or raw object
departureTime     DateTime
arrivalTime       DateTime
seatsAvailable    int
pricePerSeat      String         ADA amount as string (e.g. "2.5")
status            String         active | completed | cancelled
createdAt         DateTime
updatedAt         DateTime
```

### `Driver` (embedded in RideModel)
```
id                int
user              Passenger      Driver's user profile
vehicleImage      String         URL to vehicle photo
vehicleType       String         e.g. "Honda Civic"
vehicleColor      String
vehiclePlateNumber String
licenceImage      String         URL to license scan
idType            String         e.g. "National ID"
idNumber          String
idFrontImage      String
idBackImage       String
insuranceCert     String         URL to insurance document
status            String         active | pending | suspended
dateCreated       DateTime
dateUpdated       DateTime
```

### `Passenger` (embedded in RideModel and Driver)
```
id                int
avatar            String
fullName          String
email             String
country           String
currentLocation   List<double>   [latitude, longitude]
phoneNumber       String
```

### `DropOff` / `PickUp` (location in ride)
```
id        int
name      String
latitude  double
longitude double
```

### `BookedRideModel`
```
id          int
passenger   Passenger
ride        RideModel
rideId      String
qrcodeUuid  String     Unique identifier for QR code
qrCode      String     QR code image/data for scanning
dateBooked  DateTime
createdAt   DateTime
updatedAt   DateTime
```

### `Wallet`
```
id        int
user      UserModel
address   String       Cardano wallet address
balance   Balance
  ├─ lovelace  num   Smallest unit (1 ADA = 1,000,000 lovelace)
  └─ ada       num   Human-readable ADA balance
```

### `LocationModel`
```
id        int
name      String      Display name (e.g., "Accra Mall", "Airport")
latitude  double
longitude double
```

### `DriverModel`
```
id                int
user              Passenger
vehicleImage      String
vehicleType       String
vehicleColor      String
vehiclePlateNumber String
licenceImage      String
idType            String
idNumber          String
idFrontImage      String
idBackImage       String
insuranceCert     String
status            String
```

### `ApiResponse`
Standard response wrapper for all API calls:
```
code     int      HTTP status code
status   String   Response status string
message  String   Human-readable message
body     dynamic  Raw response payload
errors   String   Error detail string

Getters:
  allGood           bool    true when code is 200–299
  data              List    body["data"] array
  mappedObjects     Map?    body cast as Map (single object response)
  listWithoutDataKey List   body as List when no "data" key
```

---

## 11. API Layer

**Base URL:** `https://app.arcaccra.com/`

**HTTP Client:** Dio with CookieJar (`lib/services/http_service.dart`)
- Auto-injects `Authorization: Token {token}` header from `CacheHelper.authKey`
- Timeouts: 120s connect, 120s receive
- Accepts all responses ≤ 500 (error handling done in service layer)
- `loginPost()` method skips token injection for unauthenticated endpoints

### Authentication & Users (`LoginService`)

| Method | Endpoint | Body | Description |
|---|---|---|---|
| POST | `apis/accounts/login/` | `{email, password}` | Login |
| POST | `apis/accounts/register/` | FormData (multipart) | Register new user |
| POST | `apis/accounts/logout/` | — | Logout (invalidate token) |
| GET | `apis/accounts/users/{id}/` | — | Get user by ID |
| GET | `apis/accounts/drivers/` | — | List all drivers |

### Rides (`RidesService`)

| Method | Endpoint | Body | Description |
|---|---|---|---|
| GET | `apis/rides_apis/rides/search/?drop_off={destination}` | — | Search rides by destination |
| GET | `apis/rides_apis/rides/{rideId}/` | — | Get single ride |
| POST | `apis/rides_apis/rides/{rideId}/book/` | `{userId}` | Book a ride |
| POST | `apis/rides_apis/cancel-booking/{userId}/{rideId}/` | — | Cancel booking |
| POST | `apis/book_rate_apis/ratings/` | `{rideId, rating, keywords, review}` | Submit rating |

### Locations & Wallets

| Method | Endpoint | Body | Description |
|---|---|---|---|
| GET | `apis/rides_apis/locations/` | — | Fetch all available locations |
| GET | `apis/accounts/wallets/` | — | Get current user's wallet |
| GET | `apis/accounts/wallets/{id}/` | — | Get wallet by ID |
| POST | `apis/accounts/wallets/` | `{address}` | Create or update wallet address |

---

## 12. Services

### `HttpService` — `lib/services/http_service.dart`

Singleton Dio-based HTTP client. All service classes use this for API calls.

- Configured with `BaseOptions`: 120s timeouts, accept all status ≤ 500
- Adds `CookieJar` interceptor for session cookies
- `get(path)` / `post(path, data)` — standard authenticated requests
- `loginPost(path, data)` — skips auth header (for login/register)

### `LoginService` — `lib/services/login_service.dart`

Wraps all authentication and user-related endpoints. Returns `ApiResponse` from every call.

### `RidesService` — `lib/services/rides_service.dart`

Wraps all ride and booking endpoints. Returns `ApiResponse` from every call.

### `TripFirebaseService` — `lib/services/trip_firebase_service.dart`

Manages Firestore document operations for real-time trip coordination.

**Firestore Schema:**
```
users/
  {userId}/
    userId: String
    name: String
    fcmToken: String
    platform: String        "ios" | "android"

trips/
  {tripId}/
    requests/
      {userId}/
        tripId: String
        userId: String
        status: String      "pending" | "accepted" | "declined"
        createdAt: Timestamp

payments/
  {paymentId}/
    status: String          "completed"
    completedAt: Timestamp
```

**Key Methods:**

| Method | Description |
|---|---|
| `createNewUser(userModel)` | Initialize user document in Firestore |
| `requestToJoinTrip(tripId, userId)` | Write pending join request |
| `completePayment()` | Mark payment as complete |
| `getTripDetails(tripId)` | One-time fetch of a trip document |
| `getUserTrips(userId)` | Real-time Stream of user's trips |

### `FCMService` — `lib/services/fcm_service.dart`

Singleton handling all Firebase Cloud Messaging operations.

**Notification Channels (Android):**

| Channel ID | Name | Purpose |
|---|---|---|
| `CHANNEL_TRIP_REQUEST` | Trip Requests | New booking to driver |
| `CHANNEL_TRIP_UPDATES` | Trip Updates | Status changes to passenger |
| `CHANNEL_PAYMENT` | Payments | Payment confirmation |

**Key Methods:**

| Method | Description |
|---|---|
| `initialize()` | Request permissions, setup foreground/background/terminated handlers |
| `saveAnActivateTokenRefresh(userId)` | Write FCM token to Firestore `users/{userId}` |
| `sendTripRequestNotification(...)` | Notify driver of new booking |
| `sendTripResponseNotification(...)` | Notify passenger of accept/decline |
| `sendTripStatusNotification(...)` | Notify passenger of status change (en route, arrived, started) |
| `sendPaymentNotification(...)` | Notify driver of payment |

Uses **FCM HTTP v1 API** with OAuth2 tokens generated from the Google service account JSON via `googleapis_auth`.

### `LocationService` — `lib/services/location_service.dart`

Manages all GPS and map navigation features.

**Key Methods:**

| Method | Description |
|---|---|
| `checkLocationPermission(context)` | Request location permission (caches result 5 min) |
| `getCurrentUserLocation()` | One-time GPS position fetch |
| `startListeningToPosition()` | Start continuous position stream |
| `stopListening()` | Cancel position stream |
| `launchGoogleMapsNavigation(lat, lng)` | Open Google Maps with directions |
| `showDirectionToDriver(lat, lng)` | Navigate to driver's coordinates |

### `DialogService` — `lib/services/dialog_service.dart`

Centralized UI feedback layer. Prevents dialogs from being scattered throughout screen files.

| Method | Description |
|---|---|
| `showAlertDialog(title, message, buttons)` | Modal dialog with custom buttons |
| `showSnackBar(message)` | Floating snackbar (purple background, top position) |
| `showCustomModal(widget)` | Bottom sheet with custom widget content |
| `showResponseDialog(apiResponse)` | Parses ApiResponse and shows appropriate error or success message |

### `ConnectionService` — `lib/services/connectivity_service.dart`

Monitors `connectivity_plus` stream. When device goes offline → shows `NoInternetModal` overlay. When reconnected → hides modal automatically.

### `ImageService` — `lib/services/image_service.dart`

Wrapper around `image_picker` for camera and gallery image selection. Handles compression and returns a `File` object.

### `NavService` — `lib/services/nav_service.dart`

Navigation helpers and convenience methods wrapping GetX navigation calls.

### `CacheHelper` — `lib/core/cache_helper.dart`

Wrapper around `SharedPreferences` providing typed get/set/clear operations for all app-level cached data.

---

## 13. Firebase Integration

**Firebase Project ID:** `ridechain-c7650`
**Storage Bucket:** `ridechain-c7650.firebasestorage.app`

### Firebase Authentication

Used exclusively for **phone OTP verification** during user registration.

Flow:
1. `FirebaseAuth.instance.verifyPhoneNumber(phoneNumber)` sends SMS
2. User enters 6-digit code in `OTPScreen`
3. `PhoneAuthCredential` created and signed in
4. On success → proceed to next registration step

### Cloud Firestore

Used as the real-time coordination layer for trip state (separate from the main REST API).

**Why Firestore (not REST):** Firestore's real-time listeners enable instant push of state changes (driver accepted, driver arrived, trip started) to the passenger app without polling.

### Firebase Cloud Messaging

All push notifications use FCM. The `FCMService` handles all 3 app states:
- **Foreground:** Flutter local notification displayed in-app
- **Background:** System notification tray
- **Terminated:** App launches from notification tap

---

## 14. Blockchain & Wallet Integration

**Blockchain:** Cardano
**Currency:** ADA (₳)
**Smallest Unit:** Lovelace (1 ADA = 1,000,000 lovelace)

### How It Works

1. **Wallet Registration:** During signup, the user enters their external Cardano wallet address. The app does not create or manage private keys — it records the public address only.
2. **Balance Display:** The API returns the wallet's ADA balance (fetched from the Cardano network via the backend).
3. **Trip Payment:** When a trip ends, the passenger confirms payment on the `PayForTrip` screen. The backend processes the ADA transfer between wallet addresses.
4. **QR Rewards:** Scanning a valid ride QR code triggers an ADA microtransaction reward to the passenger's wallet, incentivizing trip verification.

### Key Constants

```dart
1 ADA = 1,000,000 lovelace

Wallet.balance.ada      — display value (e.g., 45.5 ADA)
Wallet.balance.lovelace — raw value (e.g., 45500000)
```

### Secrets

- `secrets/ridechain-key.json` — Google service account (used for FCM v1 OAuth tokens; git-ignored)
- `.env` — `PATH_TO_SECRET` and `PROJECT_ID` environment variables

---

## 15. Push Notifications

Notification events and their triggers:

| Event | Triggered By | Sent To | Channel |
|---|---|---|---|
| Passenger books ride | Passenger app | Driver | `CHANNEL_TRIP_REQUEST` |
| Driver accepts booking | Driver app | Passenger | `CHANNEL_TRIP_UPDATES` |
| Driver declines booking | Driver app | Passenger | `CHANNEL_TRIP_UPDATES` |
| Driver en route to pickup | Driver app | Passenger | `CHANNEL_TRIP_UPDATES` |
| Driver arrived at pickup | Driver app | Passenger | `CHANNEL_TRIP_UPDATES` |
| Trip started | Driver app | Passenger | `CHANNEL_TRIP_UPDATES` |
| Trip completed / Payment due | System | Passenger | `CHANNEL_TRIP_UPDATES` |
| Payment confirmed | Passenger app | Driver | `CHANNEL_PAYMENT` |

**FCM Token Lifecycle:**
1. App initializes → `FCMService.initialize()` requests permission
2. On login → `saveAnActivateTokenRefresh(userId)` writes token to Firestore `users/{userId}.fcmToken`
3. Token refresh monitored — updates Firestore automatically

---

## 16. Local Cache

All persistent local data managed by `CacheHelper` (SharedPreferences wrapper).

| Key | Type | Cleared On Logout | Description |
|---|---|---|---|
| `first-timer-key` | bool | No | Whether user completed onboarding |
| `auth-key` | JSON (AuthModel) | Yes | Auth token + user profile |
| `user-key` | JSON (UserModel) | Yes | Full user model |
| `wallet-key` | String | Yes | Wallet address string |
| `wallet-info-key` | JSON (Wallet) | Yes | Full wallet model with balance |
| `locations-key` | JSON List | No | Available trip locations |
| `register-process-key` | String | Yes | Registration step progress |

**Auto-Login:** On app launch, if `auth-key` is present and valid, `AuthVm.fetchUserInfo()` restores all state from cache and skips the login screen.

---

## 17. Shared UI Components

**Location:** `lib/ui/shared_widgets/`

| Widget | File | Description |
|---|---|---|
| `DefaultButton` | `default_button.dart` | Primary CTA button — filled (purple) or outlined; full width; rounded (33.5px radius) |
| `CustomTextField` | `custom_text_field.dart` | Styled text input with label, placeholder, validation, obscure toggle |
| `CustomAppBar` | `custom_app_bar.dart` | Standard screen app bar with optional back button and title |
| `BottomNav` | `bottom_nav.dart` | 4-tab bottom navigation bar with active state indicators |
| `Loader` | `loader.dart` | Centered circular progress indicator (used during API calls) |
| `RideSearchingLoader` | `ride_searching_loader.dart` | Animated "Searching for rides…" state shown during `searchingCars` |
| `AvailableCarCard` | `available_car_card.dart` | Ride result card — driver info, vehicle, price, seats, time |
| `DriverEnRouteCard` | `driver_en_route_card.dart` | Live driver details card shown on `RideArrivalScreen` |
| `AcceptedTripDetailWidget` | `accepted_trip_detail.dart` | Compact trip summary shown after booking confirmation |
| `PickupDestinationWidget` | `pickup_destination_widget.dart` | Two-line row showing pickup and drop-off with pin icons |
| `DriverCarDetailCard` | `driver_car_detail_card.dart` | Vehicle detail card showing type, color, plate, and photo |
| `NoInternetModal` | `no_internet_modal.dart` | Full-screen offline indicator; auto-dismisses on reconnection |
| `CustomAlertDialog` | `custom_alert_dialog.dart` | Reusable dialog with title, message, and configurable buttons |
| `DefaultBackButton` | `default_back_button.dart` | Consistent back navigation button matching app style |
| `NavItem` | `nav_item.dart` | Individual bottom nav tab item (icon + label + active highlight) |
| `LightStatusBar` | `light_status_bar.dart` | Widget wrapper that enforces light status bar styling on its screen |
| `TopContainer` | `top_container.dart` | Consistent hero/header container used at top of auth screens |

---

## 18. Platform Configuration

### iOS

| Property | Value |
|---|---|
| Bundle ID | `app.arc.ridex` |
| Display Name | `Ryde` |
| Min Deployment Target | iOS 13+ |
| Version | 1.0.2 |
| Build | 4 |

**Required Permissions (Info.plist):**

| Key | Reason |
|---|---|
| `NSLocationAlwaysAndWhenInUseUsageDescription` | Background location tracking during active trips |
| `NSLocationWhenInUseUsageDescription` | Show user and driver positions on map |
| `NSPhotoLibraryUsageDescription` | Upload profile picture from gallery |
| `NSCameraUsageDescription` | Capture profile photo or scan QR codes |

**Background Modes:**
- `location` — Continuous GPS during trip
- `remote-notification` — Receive FCM messages when backgrounded
- `fetch` — Background data refresh
- `processing` — Background task scheduling via WorkManager

### Android

| Property | Value |
|---|---|
| Application ID | `app.arc.ridex` |
| Display Name | `Ryde` |
| Min SDK | 21 (Android 5.0) |
| Target SDK | 34 |
| Google Maps API Key | Configured in `AndroidManifest.xml` |

**Permissions (AndroidManifest.xml):**

| Permission | Purpose |
|---|---|
| `INTERNET` | All API and Firebase requests |
| `ACCESS_FINE_LOCATION` | Precise GPS for map and tracking |
| `ACCESS_COARSE_LOCATION` | Approximate location fallback |
| `ACCESS_BACKGROUND_LOCATION` | Location tracking when app is backgrounded |
| `CAMERA` | Profile photo and QR scanning |
| `POST_NOTIFICATIONS` | FCM notifications (required Android 13+) |
| `RECEIVE_BOOT_COMPLETED` | Restart notification services after device reboot |
| `WAKE_LOCK` | Keep CPU awake during active trip tracking |
| `SCHEDULE_EXACT_ALARM` | Exact notification scheduling |
| `USE_EXACT_ALARM` | Companion to exact alarm |
| `USE_FULL_SCREEN_INTENT` | Full-screen trip alerts |

**Registered Services/Receivers:**
- `ForegroundService` — Persistent trip tracking notification service
- `ScheduledNotificationReceiver` — Local notification trigger
- `ScheduledNotificationBootReceiver` — Re-register on boot
- `ActionBroadcastReceiver` — Notification action handling

---

## 19. Environment & Secrets

### `.env` (git-ignored)
```
PATH_TO_SECRET=secrets/ridechain-key.json
PROJECT_ID=ridechain-c7650
```

Loaded at startup via `flutter_dotenv`. `PROJECT_ID` is used when constructing the FCM v1 API endpoint URL. `PATH_TO_SECRET` points to the Google service account JSON used for OAuth2 token generation.

### `secrets/ridechain-key.json` (git-ignored)

Google service account credentials. Used by `FCMService` to authenticate against the FCM HTTP v1 API via `googleapis_auth`. This file **must not be committed** and should be stored securely (e.g., CI/CD secrets or a secrets manager).

---

## 20. Dependencies

### Core

| Package | Version | Purpose |
|---|---|---|
| `flutter_screenutil` | latest | Responsive sizing based on design baseline |
| `provider` | latest | State management (ChangeNotifier) |
| `get` | latest | Navigation routing |
| `dio` | latest | HTTP client |
| `cookie_jar` + `dio_cookie_manager` | latest | Cookie management for Dio |
| `shared_preferences` | latest | Local key-value storage |
| `flutter_dotenv` | latest | `.env` file loading |

### Firebase

| Package | Purpose |
|---|---|
| `firebase_core` | Firebase initialization |
| `firebase_auth` | Phone OTP authentication |
| `cloud_firestore` | Real-time trip coordination |
| `firebase_messaging` | Push notifications |
| `flutter_local_notifications` | Foreground notification display |

### Maps & Location

| Package | Purpose |
|---|---|
| `google_maps_flutter` | In-app Google Map widget |
| `geolocator` | Device GPS access |
| `map_launcher` | Launch external navigation apps |

### Media & UI

| Package | Purpose |
|---|---|
| `image_picker` | Camera and gallery image selection |
| `mobile_scanner` | QR code scanning |
| `flutter_animate` | Declarative animation utilities |
| `flutter_svg` | SVG asset rendering |
| `flutter_rating` | Star rating widget |
| `pin_code_fields` | OTP digit input widget |
| `dots_indicator` | Onboarding page progress dots |
| `google_fonts` | Google Fonts integration |
| `country_picker` | Country selection with phone codes |

### Utilities

| Package | Purpose |
|---|---|
| `googleapis_auth` | Google OAuth2 for FCM v1 API |
| `connectivity_plus` | Network status monitoring |
| `permission_handler` | Runtime permissions |
| `workmanager` | Background task scheduling |
| `intl` | Date/time formatting and localization |
| `uuid` | UUID generation for IDs |
| `get_it` | Dependency injection service locator |
