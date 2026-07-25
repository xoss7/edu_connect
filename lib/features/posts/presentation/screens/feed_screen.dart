import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/feed_providers.dart';
import '../widgets/feed_filters_sheet.dart';
import '../widgets/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.feedTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const FeedFiltersSheet(),
            ),
          ),
        ],
      ),
      body: postsAsync.when(
        data: (posts) => posts.isEmpty
            ? const Center(child: Text(AppStrings.feedEmptyMessage))
            : ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                itemCount: posts.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
                  child: PostCard(post: posts[index]),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text(AppStrings.genericError)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('${AppRoutes.feed}/${AppRoutes.createPost}'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
