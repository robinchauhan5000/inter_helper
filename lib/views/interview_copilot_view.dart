import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/interview_response.dart';
import '../services/interview_service.dart';
import '../services/speech_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/interview_copilot_chat_area.dart';
import '../widgets/interview_copilot_header.dart';
import '../widgets/interview_copilot_input_bar.dart';

/// Full Interview Copilot screen with header, chat area, and input bar.
class InterviewCopilotView extends StatefulWidget {
  const InterviewCopilotView({super.key});

  @override
  State<InterviewCopilotView> createState() => _InterviewCopilotViewState();
}

class _InterviewCopilotViewState extends State<InterviewCopilotView> {
  final _inputController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late InterviewService _interviewService;
  late SpeechService _speechService;
  bool _isLoading = false;
  bool _isHeaderMicListening = false;
  bool _isInputMicListening = false;
  AIProvider _currentProvider = AIProvider.openai;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _speechService = SpeechService();
    _initializeSpeech();
    _askDemoQuestion();
  }

  Future<void> _initializeSpeech() async {
    debugPrint('Initializing speech service...');
    final initialized = await _speechService.initialize();
    if (!initialized) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Microphone permission denied. Please enable in System Settings → Privacy & Security → Microphone',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Open Settings',
              textColor: Colors.white,
              onPressed: () {
                // On macOS, we can't directly open settings, but we can show instructions
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Enable Microphone Access'),
                    content: const Text(
                      '1. Open System Settings\n'
                      '2. Go to Privacy & Security\n'
                      '3. Click on Microphone\n'
                      '4. Enable access for "hexmac"\n'
                      '5. Restart the app',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    } else {
      debugPrint('✅ Speech service initialized successfully');
    }
  }

  void _initializeService() {
    try {
      _interviewService = InterviewService(provider: _currentProvider);
    } catch (e) {
      debugPrint('Failed to initialize InterviewService: $e');
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _speechService.dispose();
    super.dispose();
  }

  Future<void> _askDemoQuestion() async {
    const demoQuestion = 'What is goroutine in golang?';
    await _sendMessage(demoQuestion);
  }

  void _switchProvider(AIProvider provider) {
    if (_currentProvider == provider || _isLoading) return;

    setState(() {
      _currentProvider = provider;
      _messages.add(
        AssistantChatMessage(
          text: 'Switched to ${provider.name.toUpperCase()} AI',
        ),
      );
    });

    _initializeService();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    setState(() {
      _messages.add(UserChatMessage(text: text, showDetected: true));
      _isLoading = true;
    });

    _inputController.clear();

    try {
      final response = await _interviewService.askQuestion(text);
      setState(() {
        _messages.add(_buildResponseMessage(response));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(AssistantChatMessage(text: 'Error: ${e.toString()}'));
        _isLoading = false;
      });
    }
  }

  void _copyAllMessages() {
    final buffer = StringBuffer();
    buffer.writeln('=== INTERVIEW COPILOT CHAT TRANSCRIPT ===\n');

    for (final message in _messages) {
      if (message is UserChatMessage) {
        buffer.writeln('USER:');
        buffer.writeln(message.text);
        buffer.writeln();
      } else if (message is AssistantChatMessage) {
        buffer.writeln('ASSISTANT:');
        buffer.writeln(message.text);
        buffer.writeln();
      }
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All messages copied to clipboard'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.accentPurple,
      ),
    );
  }

  /// Toggle header microphone (sends directly to AI)
  Future<void> _toggleHeaderMic() async {
    if (_isLoading) return;

    if (_isHeaderMicListening) {
      // Stop listening
      await _speechService.stopListening();
      setState(() => _isHeaderMicListening = false);
    } else {
      // Start listening
      setState(() => _isHeaderMicListening = true);
      await _speechService.startListening(
        onResult: (text) {
          setState(() => _isHeaderMicListening = false);
          if (text.isNotEmpty) {
            _sendMessage(text);
          }
        },
        onPartialResult: (text) {
          // Show partial results in a temporary message
          debugPrint('Partial: $text');
        },
      );
    }
  }

  /// Toggle input microphone (fills text field)
  Future<void> _toggleInputMic() async {
    if (_isInputMicListening) {
      // Stop listening
      await _speechService.stopListening();
      setState(() => _isInputMicListening = false);
    } else {
      // Start listening
      setState(() => _isInputMicListening = true);
      await _speechService.startListening(
        onResult: (text) {
          setState(() {
            _isInputMicListening = false;
            _inputController.text = text;
          });
        },
        onPartialResult: (text) {
          // Update text field with partial results
          setState(() {
            _inputController.text = text;
          });
        },
      );
    }
  }

  ChatMessage _buildResponseMessage(InterviewResponse response) {
    final buffer = StringBuffer();

    for (final section in response.sections) {
      switch (section.type) {
        case SectionType.shortAnswer:
          buffer.writeln(section.content);
          buffer.writeln();
          break;
        case SectionType.details:
          final details = section.content as List;
          for (final detail in details) {
            buffer.writeln('- $detail');
          }
          buffer.writeln();
          break;
        case SectionType.code:
          buffer.writeln('```${section.language ?? ''}');
          buffer.writeln(section.content);
          buffer.writeln('```');
          buffer.writeln();
          break;
      }
    }

    return AssistantChatMessage(text: buffer.toString().trim());
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundPrimary,
              AppColors.backgroundPrimary.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: Column(
          children: [
            InterviewCopilotHeader(
              isMicListening: _isHeaderMicListening,
              onMicPressed: _toggleHeaderMic,
              onAnalysePressed: () {},
              onClearPressed: () {
                setState(() {
                  _messages.clear();
                });
              },
              onCopyAllPressed: _copyAllMessages,
            ),
            _buildProviderSelector(),
            InterviewCopilotChatArea(
              sessionStartTime: '10:30 AM',
              messages: _messages,
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.accentPurple,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Asking ${_currentProvider.name.toUpperCase()}...',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            InterviewCopilotInputBar(
              controller: _inputController,
              placeholder: 'Ask for a hint, custom response, or pivot...',
              isMicListening: _isInputMicListening,
              onMicPressed: _toggleInputMic,
              onSendPressed: () {
                final text = _inputController.text;
                _sendMessage(text);
              },
              onAttachmentPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          const Text(
            'AI Provider:',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          _buildProviderChip(AIProvider.openai, 'OpenAI'),
          const SizedBox(width: 8),
          _buildProviderChip(AIProvider.gemini, 'Gemini'),
        ],
      ),
    );
  }

  Widget _buildProviderChip(AIProvider provider, String label) {
    final isSelected = _currentProvider == provider;
    return Material(
      color: isSelected ? AppColors.accentPurple : AppColors.backgroundTertiary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => _switchProvider(provider),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textMuted,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
