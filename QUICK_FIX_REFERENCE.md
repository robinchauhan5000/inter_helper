# Quick Fix Reference Card

## 🎯 What Was Fixed

App no longer crashes on first launch - permissions are now requested proactively!

## 🚀 Quick Start

```bash
flutter run -d macos
```

## ✅ What to Expect (TWO Permission Dialogs!)

1. App launches
2. **Dialog 1**: Microphone permission → Click "OK" 🎤
3. **Dialog 2**: Speech recognition permission → Click "OK" 🗣️
4. App works perfectly! 🎉

**Important**: You must grant BOTH permissions for speech-to-text to work!

## 🔧 If You Need to Rebuild

```bash
flutter clean
flutter pub get
cd macos && pod install && cd ..
flutter run -d macos
```

## 📋 What Changed

- ✨ New: `lib/services/permission_service.dart`
- 🔧 Updated: `macos/Runner/AppDelegate.swift` (native permission handling)
- 🔧 Updated: `lib/main.dart` (request permissions on startup)
- 🔧 Updated: `lib/views/interview_copilot_view.dart` (check before using mic)

## 🐛 Troubleshooting

**Still crashing?**

```bash
flutter clean && flutter run -d macos
```

**Need to reset permissions?**

```bash
tccutil reset Microphone com.example.hexmac
tccutil reset SpeechRecognition com.example.hexmac
```

**Check permissions manually:**
System Settings → Privacy & Security → Microphone/Speech Recognition

## 📚 More Info

- `PERMISSION_SOLUTION_SUMMARY.md` - Complete technical details
- `NEXT_STEPS.md` - Detailed testing guide
- `PERMISSION_FIX.md` - Implementation details

---

**That's it!** Your app now handles permissions correctly. 🎊
