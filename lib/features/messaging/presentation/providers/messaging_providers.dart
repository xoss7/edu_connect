import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/conversation_repository.dart';
import '../../domain/conversation.dart';
import '../../domain/message.dart';

// watchConversations() streams every conversation row (see
// conversation_repository.dart for why), so this provider keeps only the
// ones the current user actually participates in. RLS is what makes this
// safe even before this filter runs — see the plan's SQL.
final conversationsProvider = StreamProvider<List<Conversation>>((ref) {
  final uid = ref.watch(authServiceProvider).currentUser?.id;
  if (uid == null) return Stream.value(const []);
  return ref
      .watch(conversationRepositoryProvider)
      .watchConversations()
      .map(
        (conversations) =>
            conversations.where((c) => c.hasParticipant(uid)).toList(),
      );
});

final messagesProvider = StreamProvider.family<List<Message>, String>((
  ref,
  conversationId,
) {
  return ref
      .watch(conversationRepositoryProvider)
      .watchMessages(conversationId);
});
