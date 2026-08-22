import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../providers/messaging_providers.dart';
import '../widgets/conversation_tile.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final currentUid = ref.watch(authServiceProvider).currentUser!.id;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.messagesTitle)),
      body: conversationsAsync.when(
        data: (conversations) => conversations.isEmpty
            ? const Center(child: Text(AppStrings.messagesEmptyMessage))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spaceSm,
                ),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return ConversationTile(
                    conversation: conversation,
                    currentUid: currentUid,
                    onTap: () => context.push(
                      '${AppRoutes.messages}/${conversation.id}',
                      extra: conversation.otherParticipantId(currentUid),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text(AppStrings.genericError)),
      ),
    );
  }
}
