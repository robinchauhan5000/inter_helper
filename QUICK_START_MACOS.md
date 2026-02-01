# Quick Start Guide - macOS Microphone

## 🚀 Run the App

```bash
flutter run -d macos
```

## 🎤 Two Microphone Buttons

### Header Mic (Top) - Direct Send

- 🔴 Red = OFF
- 🟢 Green = ON
- Sends directly to AI after you stop speaking

### Input Mic (Bottom) - Edit First

- 🔴 Red = OFF
- 🟢 Green = ON
- Fills text field, you can edit before sending

## ✅ First Time Setup

1. Click any microphone button
2. Allow microphone access
3. Allow speech recognition
4. Start speaking!

## 🔧 If Something Goes Wrong

```bash
# Clean and rebuild
flutter clean
flutter pub get
cd macos && pod install && cd ..
flutter run -d macos
```

## 📋 Quick Test

1. Launch app
2. Click header mic (should turn green)
3. Say: "What is a goroutine?"
4. Wait 3 seconds
5. Message sends to AI automatically

## 🆘 Permissions Denied?

**System Settings** → **Privacy & Security** → **Microphone** → Enable "hexmac"

**System Settings** → **Privacy & Security** → **Speech Recognition** → Enable "hexmac"

Then restart the app.

## ✨ That's It!

You're ready to use voice input in your Interview Copilot app.
