import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/quiz_providers.dart';
import '../widgets/quiz_card.dart';

class QuizzesScreen extends ConsumerWidget {
  const QuizzesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzesAsync = ref.watch(quizzesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.quizzesTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMd,
              vertical: AppDimensions.spaceSm,
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: AppStrings.quizzesSearchHint,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => ref
                  .read(quizSearchProvider.notifier)
                  .setQuery(value.trim().isEmpty ? null : value.trim()),
            ),
          ),
          Expanded(
            child: quizzesAsync.when(
              data: (quizzes) => quizzes.isEmpty
                  ? const Center(child: Text(AppStrings.quizzesEmptyMessage))
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppDimensions.spaceMd),
                      itemCount: quizzes.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spaceMd,
                        ),
                        child: QuizCard(quiz: quizzes[index]),
                      ),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  const Center(child: Text(AppStrings.genericError)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('${AppRoutes.quizzes}/${AppRoutes.createQuiz}'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
