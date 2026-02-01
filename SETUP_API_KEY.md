# API Key Setup Instructions

## Step 1: Get Your OpenAI API Key

1. Go to [OpenAI Platform](https://platform.openai.com/api-keys)
2. Sign in or create an account
3. Navigate to API Keys section
4. Click "Create new secret key"
5. Copy your API key (it starts with `sk-`)

## Step 2: Configure Your API Key

### Option 1: Using the constants file (Recommended for development)

1. Navigate to `lib/constants/`
2. Copy `api_keys.example.dart` to `api_keys.dart`:
   ```bash
   cp lib/constants/api_keys.example.dart lib/constants/api_keys.dart
   ```
3. Open `lib/constants/api_keys.dart`
4. Replace `'your-openai-api-key-here'` with your actual API key:
   ```dart
   static const String openAiApiKey = 'sk-your-actual-key-here';
   ```

### Option 2: Using environment variables (Recommended for production)

Run your app with:

```bash
flutter run --dart-define=OPENAI_API_KEY=sk-your-actual-key-here
```

## Step 3: Verify Setup

The API key file is already added to `.gitignore` to prevent accidental commits.

## Security Best Practices

⚠️ **NEVER commit your API key to version control!**

- ✅ Use `api_keys.dart` for local development (already in .gitignore)
- ✅ Use environment variables for production
- ✅ Rotate your API keys regularly
- ✅ Set usage limits in OpenAI dashboard
- ❌ Don't share your API key
- ❌ Don't commit `api_keys.dart` to git

## Usage in Code

```dart
import 'package:hexmac/services/services.dart';

// API key is automatically loaded from constants
final service = InterviewService();

// Or pass explicitly if needed
final service = InterviewService(apiKey: 'your-key');
```

## Troubleshooting

**Error: "OpenAI API key not configured"**

- Make sure you created `api_keys.dart` from the example file
- Verify your API key is correct and not the placeholder text
- Check that your API key starts with `sk-`

**Error: "API request failed with status 401"**

- Your API key is invalid or expired
- Generate a new key from OpenAI dashboard

**Error: "API request failed with status 429"**

- You've exceeded your rate limit
- Check your usage in OpenAI dashboard
- Consider upgrading your plan
