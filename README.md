# Automated Package Integration in a Flutter Project

## 📹 Demo Video
![Demo Video](./output.gif)

## Overview
This project automates the integration of the `google_maps_flutter` package into any Flutter project. It streamlines package installation, API key management, and platform-specific configurations for both Android and iOS.

## Features
- **Project Selection**: Allows users to pick a Flutter project directory.
- **Automated Package Integration**: Adds `google_maps_flutter` to `pubspec.yaml` and runs `flutter pub get`.
- **API Key Management**: Prompts users to enter a Google Maps API key.
- **Platform Configuration**: Updates `AndroidManifest.xml` and `Info.plist` automatically.
- **Google Maps Demo**: Implements a simple Google Maps widget using Bloc or Riverpod.

## Getting Started
1. Clone the repository:
   ```sh
   git clone https://github.com/Taber1/automated-package-integration.git
   cd automated-package-integration
   ```
2. Run the tool to integrate Google Maps:
   ```sh
   flutter run
   ```
3. Enter the Google Maps API key when prompted (or skip if already configured).
4. Navigate to your Flutter project and run:
   ```sh
   flutter run
   ```

