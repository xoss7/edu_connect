import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/conversation.dart';
import '../domain/message.dart';
import 'conversation_model.dart';

class ConversationRepository {
  ConversationRepository(this._supabase);

  final SupabaseClient _supabase;

  // Supabase Realtime's .stream() only supports a single equality filter —
  // no .or(), no array .contains() — so "where I'm participant_one OR
  // participant_two" can't be expressed server-side here. Streaming
  // unfiltered and filtering client-side (see messaging_providers.dart)
  // mirrors the pattern already used by watchFeed()/watchResources()
  // elsewhere in this app. The RLS select policy still restricts which
  // rows actually come back, so no data leaks despite the missing
  // server-side filter.
  Stream<List<Conversation>> watchConversations() {
    return _supabase
        .from('conversations')
        .stream(primaryKey: ['id'])
        .order('last_message_at', ascending: false)
        .map((data) => data.map(conversationFromMap).toList());
  }

  Stream<List<Message>> watchMessages(String conversationId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((data) => data.map(messageFromMap).toList());
  }

  // One-shot query (not .stream()), so .or() is fully supported here —
  // unlike the realtime stream builder above.
  Future<String> getOrCreateConversation({
    required String uidA,
    required String uidB,
  }) async {
    final existing = await _supabase
        .from('conversations')
        .select('id')
        .or(
          'and(participant_one_id.eq.$uidA,participant_two_id.eq.$uidB),'
          'and(participant_one_id.eq.$uidB,participant_two_id.eq.$uidA)',
        )
        .maybeSingle();

    if (existing != null) return existing['id'] as String;

    final created = await _supabase
        .from('conversations')
        .insert({'participant_one_id': uidA, 'participant_two_id': uidB})
        .select('id')
        .single();
    return created['id'] as String;
  }

  Future<void> sendMessage({
    required String conversationId,
    required String auteurId,
    required String texte,
  }) async {
    await _supabase.from('messages').insert({
      'conversation_id': conversationId,
      'auteur_id': auteurId,
      'texte': texte,
    });

    await _supabase
        .from('conversations')
        .update({
          'last_message': texte,
          'last_message_at': DateTime.now().toIso8601String(),
        })
        .eq('id', conversationId);
  }
}

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  return ConversationRepository(Supabase.instance.client);
});
