# My E-commerce App

A full-featured e-commerce application built with Flutter featuring role-based access control for users and administrators.

## Overview

This is a complete E-commerce application that supports:
- **Registration/Login** with Admin and User role management
- **Product Management** (add, edit, delete - for Admin)
- **Shopping Cart and Ordering** with multiple payment methods
- **Product Favorites** and **Order History**
- **Personal Payment Method Management**

## Technologies Used

- **Flutter** ^3.7.2 - Cross-platform app development framework
- **Firebase Core** ^3.8.1 - Backend platform
- **Firebase Auth** ^5.3.4 - User authentication
- **Cloud Firestore** ^5.1.1 - NoSQL database
- **Firebase Storage** ^12.3.7 - Image storage
- **Flutter Riverpod** ^2.6.1 - State management
- **Cached Network Image** ^3.4.1 - Optimized image display
- **Google Fonts** ^6.2.1 - Beautiful fonts
- **Image Picker** ^1.1.2 - Device image selection

## Installation Guide

### 1. Clone the project
```bash
git clone <repository-url>
cd MyEcommerceApp
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Firebase Configuration
- Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
- Enable Authentication, Firestore Database, and Storage
- Download `google-services.json` and place it in `android/app/` directory
- Configure Firebase for iOS if needed

### 4. Run the application
```bash
# Run on Android device/emulator
flutter run

# Or run on specific device
flutter run -d <device-id>
```

### 5. Build APK (optional)
```bash
flutter build apk --release
```

## Key Features

### For Users:
- Browse and search products
- Add products to cart and favorites
- Place orders with multiple payment methods
- Manage personal information and order history

### For Admin:
- Manage categories and products
- View and process orders
- Sales analytics

## Project Structure

```
lib/
├── Core/               # Core components
│   ├── Common/         # Common utilities
│   ├── Model/          # Data models
│   └── Provider/       # State providers
├── Services/           # Services (Authentication, API)
├── Views/              # User interfaces
│   └── Role_based_login/  # Login and role management
├── Widgets/            # Reusable components
└── main.dart           # Entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (^3.7.2)
- Android Studio / Xcode
- Firebase account

### Default Login Credentials
After setting up Firebase, you can create admin and user accounts through the app's registration feature.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is for educational purposes.
