import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/auth_service.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../providers/messaging_providers.dart';
import '../providers/send_message_controller.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    required this.conversationId,
    this.otherParticipantId,
    super.key,
  });

  final String conversationId;

  // Passed via go_router's `extra` when pushed from ConversationsScreen or
  // ProjectDetailScreen, so the AppBar title doesn't need an extra
  // round-trip just to show the other participant's name. Falls back to
  // AppStrings.messagesTitle if absent (e.g. deep link).
  final String? otherParticipantId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() {
    final texte = _messageController.text.trim();
    if (texte.isEmpty) return;
    ref
        .read(sendMessageControllerProvider.notifier)
        .submit(conversationId: widget.conversationId, texte: texte);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = ref.watch(authServiceProvider).currentUser!.id;
    final messagesAsync = ref.watch(messagesProvider(widget.conversationId));
    final otherName = widget.otherParticipantId != null
        ? ref.watch(studentProvider(widget.otherParticipantId!)).value?.nom
        : null;

    ref.listen<AsyncValue<void>>(sendMessageControllerProvider, (
      previous,
      next,
    ) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.genericError)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(otherName ?? AppStrings.messagesTitle)),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                // messagesProvider streams oldest-first (created_at
                // ascending). Reversing here + reverse: true anchors the
                // list to the bottom, so the newest message is always
                // visible without manual scrolling — the standard chat
                // idiom, since a plain top-anchored ListView would open
                // showing the oldest messages instead.
                final reversedMessages = messages.reversed.toList();
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(AppDimensions.spaceMd),
                  itemCount: reversedMessages.length,
                  itemBuilder: (context, index) => MessageBubble(
                    message: reversedMessages[index],
                    isOwnMessage:
                        reversedMessages[index].auteurId == currentUid,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  const Center(child: Text(AppStrings.genericError)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: AppStrings.messageInputHint,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _submitMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
