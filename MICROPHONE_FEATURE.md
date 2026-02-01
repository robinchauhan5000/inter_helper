# Microphone Feature Documentation

## Overview

The Interview Copilot now includes speech-to-text functionality with two microphone buttons that serve different purposes.

## Features

### 1. Header Microphone Button (Top)

**Location:** Top header bar, left side

**Behavior:**

- **Red Light (Default):** Microphone is OFF
- **Green Light:** Microphone is ON and listening
- **White Dot:** Appears when actively listening

**Functionality:**

- Press to start listening
- Converts speech to text automatically
- **Sends directly to AI** (OpenAI/Gemini) when you stop speaking
- Automatically stops after 3 seconds of silence
- Maximum listening duration: 30 seconds

**Use Case:** Quick questions or follow-ups that you want to send immediately to the AI assistant.

### 2. Input Bar Microphone Button (Bottom)

**Location:** Bottom input bar, left side

**Behavior:**

- **Red Light (Default):** Microphone is OFF
- **Green Light:** Microphone is ON and listening
- **White Dot:** Appears when actively listening

**Functionality:**

- Press to start listening
- Converts speech to text in real-time
- **Fills the text input field** instead of sending directly
- Shows partial results as you speak
- You can edit the text before sending
- Press send button when ready

**Use Case:** When you want to review or edit your message before sending it to the AI.

## Permissions

The app automatically requests the following permissions:

### Android

- `RECORD_AUDIO` - Required for microphone access
- `INTERNET` - Required for API calls
- `BLUETOOTH` - Optional for Bluetooth headsets
- `BLUETOOTH_CONNECT` - Optional for Bluetooth headsets

### iOS/macOS

- `NSMicrophoneUsageDescription` - Microphone access
- `NSSpeechRecognitionUsageDescription` - Speech recognition

## How to Use

### Quick Send (Header Mic)

1. Click the microphone button in the header
2. Button turns green with white dot
3. Speak your question
4. Stop speaking (3 seconds of silence triggers send)
5. Message is automatically sent to AI

### Edit Before Send (Input Mic)

1. Click the microphone button in the input bar
2. Button turns green with white dot
3. Speak your message
4. See text appear in the input field
5. Edit if needed
6. Click send button

## Technical Details

### Dependencies

- `speech_to_text: ^7.0.0` - Speech recognition
- `permission_handler: ^11.3.1` - Permission management

### Service

- `SpeechService` handles all speech-to-text operations
- Automatic initialization and permission requests
- Error handling and status updates
- Configurable listening duration and pause detection

### Visual Indicators

- **Red Button:** Microphone OFF
- **Green Button:** Microphone ON
- **White Dot:** Actively listening
- **No Dot:** Waiting for speech or processing

## Troubleshooting

### Permission Denied

If microphone permission is denied, a red snackbar will appear. Go to your device settings and enable microphone permission for the app.

### Not Recognizing Speech

- Ensure you're speaking clearly
- Check your device's microphone is working
- Try speaking closer to the microphone
- Check internet connection (required for speech recognition)

### Button Stays Green

If the button stays green after speaking:

- Click the button again to stop manually
- Check if there's background noise preventing auto-stop
- Restart the app if the issue persists

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ macOS
- ⚠️ Web (requires browser microphone support)
- ⚠️ Windows/Linux (requires additional setup)
