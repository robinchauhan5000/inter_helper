import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'services/permission_service.dart';
import 'theme/app_theme.dart';
import 'views/interview_copilot_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request permissions on macOS before starting the app
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.macOS) {
    debugPrint('=== Requesting macOS Permissions ===');
    final permissions = await PermissionService.requestAllPermissions();
    debugPrint('Microphone: ${permissions['microphone']}');
    debugPrint('Speech Recognition: ${permissions['speechRecognition']}');
    debugPrint('All Granted: ${permissions['allGranted']}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const ContentView(),
    );
  }
}

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  static const _channel = MethodChannel('interx/screen_capture');

  bool forceHideForShare = false;

  bool get _isMacOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  bool get isHiding => forceHideForShare;

  @override
  void initState() {
    super.initState();

    // Wait until the first frame so macOS channel is registered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncWindow();
    });
  }

  Future<void> _syncWindow() async {
    if (!_isMacOS) return;
    try {
      await _channel.invokeMethod('setHidden', isHiding);
    } on MissingPluginException {
      // Ignore if platform channel isn't ready (or not running on macOS).
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('interx'),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                forceHideForShare = !forceHideForShare;
              });
              await _syncWindow();
            },
            child: Text(
              isHiding ? 'Show' : 'Hide for Share',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isHiding ? _hiddenView() : _contentView(),
      ),
    );
  }

  Widget _hiddenView() {
    return const InterviewCopilotView(key: ValueKey('hidden'));
  }

  Widget _contentView() {
    return const Center(
      key: ValueKey('content'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.public, size: 48),
          SizedBox(height: 12),
          Text('Hello, world!'),
        ],
      ),
    );
  }
}
