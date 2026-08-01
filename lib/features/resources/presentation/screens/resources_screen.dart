import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/resource_providers.dart';
import '../widgets/resource_card.dart';
import '../widgets/resource_filters_sheet.dart';

class ResourcesScreen extends ConsumerWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(resourcesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.resourcesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const ResourceFiltersSheet(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMd,
              vertical: AppDimensions.spaceSm,
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: AppStrings.resourcesSearchHint,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => ref
                  .read(resourceFiltersProvider.notifier)
                  .setQuery(value.trim().isEmpty ? null : value.trim()),
            ),
          ),
          Expanded(
            child: resourcesAsync.when(
              data: (resources) => resources.isEmpty
                  ? const Center(child: Text(AppStrings.resourcesEmptyMessage))
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppDimensions.spaceMd),
                      itemCount: resources.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spaceMd,
                        ),
                        child: ResourceCard(resource: resources[index]),
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
            context.push('${AppRoutes.resources}/${AppRoutes.uploadResource}'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
