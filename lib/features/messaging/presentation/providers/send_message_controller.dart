import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/conversation_repository.dart';

class SendMessageController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String conversationId,
    required String texte,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authServiceProvider).currentUser!.id;
      await ref
          .read(conversationRepositoryProvider)
          .sendMessage(
            conversationId: conversationId,
            auteurId: uid,
            texte: texte,
          );
    });
  }
}

final sendMessageControllerProvider =
    AsyncNotifierProvider<SendMessageController, void>(
      SendMessageController.new,
    );
