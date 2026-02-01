import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Bottom input bar with voice controls, text input, and send actions.
class InterviewCopilotInputBar extends StatelessWidget {
  const InterviewCopilotInputBar({
    super.key,
    this.controller,
    this.onMicPressed,
    this.onSpeakerPressed,
    this.onSendPressed,
    this.onAttachmentPressed,
    this.placeholder = 'Ask for a hint, custom response, or pivot...',
  });

  final TextEditingController? controller;
  final VoidCallback? onMicPressed;
  final VoidCallback? onSpeakerPressed;
  final VoidCallback? onSendPressed;
  final VoidCallback? onAttachmentPressed;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(
          top: BorderSide(color: AppColors.backgroundTertiary, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _VoiceButton(
              icon: Icons.mic_rounded,
              onPressed: onMicPressed,
            ),
            const SizedBox(width: 12),
            _VoiceButton(
              icon: Icons.volume_up_rounded,
              onPressed: onSpeakerPressed,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.backgroundTertiary,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.backgroundTertiary,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline_rounded,
                      size: 24,
                      color: AppColors.textMuted.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: placeholder,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 0,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            _IconButton(
              icon: Icons.attach_file_rounded,
              onPressed: onAttachmentPressed,
            ),
            const SizedBox(width: 8),
            _IconButton(
              icon: Icons.send_rounded,
              onPressed: onSendPressed,
              backgroundColor: AppColors.accentPurple,
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceButton extends StatelessWidget {
  const _VoiceButton({
    required this.icon,
    this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accentPurple,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    this.onPressed,
    this.backgroundColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? AppColors.backgroundTertiary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}
