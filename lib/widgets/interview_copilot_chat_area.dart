import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'chat_message_bubble.dart';
import 'recommended_strategy_block.dart';

/// Central chat area displaying conversation history.
class InterviewCopilotChatArea extends StatelessWidget {
  const InterviewCopilotChatArea({
    super.key,
    this.sessionStartTime = '10:30 AM',
    this.messages = const [],
  });

  final String sessionStartTime;
  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundPrimary,
              Color(0xFF1A1C24),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            _SessionStartIndicator(time: sessionStartTime),
            const SizedBox(height: 24),
            ...messages.map((m) => m.build(context)),
          ],
        ),
      ),
    );
  }
}

class _SessionStartIndicator extends StatelessWidget {
  const _SessionStartIndicator({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'SESSION STARTED $time',
        style: TextStyle(
          color: AppColors.textMuted.withValues(alpha: 0.8),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

/// Represents a chat message (user, assistant, or strategy block).
abstract class ChatMessage {
  const ChatMessage();
  Widget build(BuildContext context);
}

/// User message in the chat.
class UserChatMessage extends ChatMessage {
  const UserChatMessage({
    required this.text,
    this.timestamp,
    this.showDetected = true,
  });

  final String text;
  final String? timestamp;
  final bool showDetected;

  @override
  Widget build(BuildContext context) {
    return ChatMessageBubble(
      message: text,
      type: ChatMessageType.user,
      timestamp: timestamp,
      showDetected: showDetected,
    );
  }
}

/// Assistant message in the chat.
class AssistantChatMessage extends ChatMessage {
  const AssistantChatMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ChatMessageBubble(
      message: text,
      type: ChatMessageType.assistant,
    );
  }
}

/// Assistant message with recommended strategy block.
class StrategyChatMessage extends ChatMessage {
  const StrategyChatMessage({
    required this.assistantText,
    required this.strategyText,
    this.keyConceptText,
    this.boldSpans = const [],
  });

  final String assistantText;
  final String strategyText;
  final String? keyConceptText;
  final List<String> boldSpans;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accentPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ASSISTANT',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.assistantBubble,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.backgroundTertiary,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    assistantText,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
                RecommendedStrategyBlock(
                  strategyText: strategyText,
                  keyConceptText: keyConceptText,
                  boldSpans: boldSpans,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
