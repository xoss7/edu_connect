import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/post_repository.dart';
import '../../domain/post.dart';

class FeedFilters {
  const FeedFilters({this.ecole, this.filiere, this.niveau});

  final String? ecole;
  final String? filiere;
  final String? niveau;

  bool get isEmpty => ecole == null && filiere == null && niveau == null;
}

class FeedFiltersNotifier extends Notifier<FeedFilters> {
  @override
  FeedFilters build() => const FeedFilters();

  void setEcole(String? value) {
    state = FeedFilters(
      ecole: value,
      filiere: state.filiere,
      niveau: state.niveau,
    );
  }

  void setFiliere(String? value) {
    state = FeedFilters(
      ecole: state.ecole,
      filiere: value,
      niveau: state.niveau,
    );
  }

  void setNiveau(String? value) {
    state = FeedFilters(
      ecole: state.ecole,
      filiere: state.filiere,
      niveau: value,
    );
  }

  void clear() => state = const FeedFilters();
}

final feedFiltersProvider = NotifierProvider<FeedFiltersNotifier, FeedFilters>(
  FeedFiltersNotifier.new,
);

// École/filière match case-insensitively via `contains` (they're free text,
// so an exact match would silently miss "ESP" vs "esp"); niveau matches
// exactly since it's a fixed dropdown. See post_repository.dart for why
// this filtering happens here instead of as a Firestore `where` clause.
final feedProvider = StreamProvider<List<Post>>((ref) {
  final filters = ref.watch(feedFiltersProvider);
  return ref
      .watch(postRepositoryProvider)
      .watchFeed()
      .map(
        (posts) => posts.where((post) {
          if (filters.ecole != null &&
              !post.ecole.toLowerCase().contains(
                filters.ecole!.toLowerCase(),
              )) {
            return false;
          }
          if (filters.filiere != null &&
              !post.filiere.toLowerCase().contains(
                filters.filiere!.toLowerCase(),
              )) {
            return false;
          }
          if (filters.niveau != null && post.niveau != filters.niveau) {
            return false;
          }
          return true;
        }).toList(),
      );
});

// Single-post live stream — used by the detail screen (and reusable by any
// future feature that needs to display one post), separate from the list
// stream feedProvider maintains.
final postProvider = StreamProvider.family<Post, String>((ref, postId) {
  return ref.watch(postRepositoryProvider).watchPost(postId);
});
