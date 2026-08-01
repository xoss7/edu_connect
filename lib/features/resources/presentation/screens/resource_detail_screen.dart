import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/resource.dart';
import '../providers/download_resource_controller.dart';
import '../providers/resource_providers.dart';

class ResourceDetailScreen extends ConsumerWidget {
  const ResourceDetailScreen({required this.resourceId, super.key});

  final String resourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(downloadResourceControllerProvider, (
      previous,
      next,
    ) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.genericError)));
        return;
      }
      if (previous?.isLoading == true && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.resourceDownloadSuccess)),
        );
      }
    });

    final resourceAsync = ref.watch(resourceProvider(resourceId));

    return Scaffold(
      appBar: AppBar(
        title: Text(resourceAsync.value?.titre ?? AppStrings.resourcesTitle),
      ),
      body: resourceAsync.when(
        data: (resource) => _ResourceDetailBody(resource: resource),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text(AppStrings.genericError)),
      ),
    );
  }
}

class _ResourceDetailBody extends ConsumerWidget {
  const _ResourceDetailBody({required this.resource});

  final Resource resource;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDownloading = ref
        .watch(downloadResourceControllerProvider)
        .isLoading;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${resource.matiere}'
                '${AppStrings.profileFieldSeparator}'
                '${resource.ecole}'
                '${AppStrings.profileFieldSeparator}'
                '${resource.niveau}',
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              Row(
                children: [
                  const Icon(Icons.download_outlined, size: 18),
                  const SizedBox(width: AppDimensions.spaceXs),
                  Text(
                    '${resource.downloads} ${AppStrings.resourceDownloadsLabel}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              ElevatedButton.icon(
                onPressed: isDownloading
                    ? null
                    : () => ref
                          .read(downloadResourceControllerProvider.notifier)
                          .download(resource),
                icon: isDownloading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: const Text(AppStrings.resourceDownloadButton),
              ),
            ],
          ),
        ),
        Expanded(child: SfPdfViewer.network(resource.fileUrl)),
      ],
    );
  }
}
