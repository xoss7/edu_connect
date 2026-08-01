import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/resource_repository.dart';
import '../../domain/resource.dart';

class ResourceFilters {
  const ResourceFilters({this.matiere, this.ecole, this.niveau, this.query});

  final String? matiere;
  final String? ecole;
  final String? niveau;
  final String? query;

  bool get isEmpty =>
      matiere == null && ecole == null && niveau == null && query == null;
}

class ResourceFiltersNotifier extends Notifier<ResourceFilters> {
  @override
  ResourceFilters build() => const ResourceFilters();

  void setMatiere(String? value) {
    state = ResourceFilters(
      matiere: value,
      ecole: state.ecole,
      niveau: state.niveau,
      query: state.query,
    );
  }

  void setEcole(String? value) {
    state = ResourceFilters(
      matiere: state.matiere,
      ecole: value,
      niveau: state.niveau,
      query: state.query,
    );
  }

  void setNiveau(String? value) {
    state = ResourceFilters(
      matiere: state.matiere,
      ecole: state.ecole,
      niveau: value,
      query: state.query,
    );
  }

  void setQuery(String? value) {
    state = ResourceFilters(
      matiere: state.matiere,
      ecole: state.ecole,
      niveau: state.niveau,
      query: value,
    );
  }

  void clear() => state = const ResourceFilters();
}

final resourceFiltersProvider =
    NotifierProvider<ResourceFiltersNotifier, ResourceFilters>(
      ResourceFiltersNotifier.new,
    );

// Matière/école/titre match case-insensitively via `contains` (matière and
// école are free text, so an exact match would silently miss "ESP" vs
// "esp"); niveau matches exactly since it's a fixed dropdown. See
// resource_repository.dart for why this filtering happens here instead of
// as a Firestore `where` clause.
final resourcesProvider = StreamProvider<List<Resource>>((ref) {
  final filters = ref.watch(resourceFiltersProvider);
  return ref
      .watch(resourceRepositoryProvider)
      .watchResources()
      .map(
        (resources) => resources.where((resource) {
          if (filters.matiere != null &&
              !resource.matiere.toLowerCase().contains(
                filters.matiere!.toLowerCase(),
              )) {
            return false;
          }
          if (filters.ecole != null &&
              !resource.ecole.toLowerCase().contains(
                filters.ecole!.toLowerCase(),
              )) {
            return false;
          }
          if (filters.niveau != null && resource.niveau != filters.niveau) {
            return false;
          }
          if (filters.query != null &&
              !resource.titre.toLowerCase().contains(
                filters.query!.toLowerCase(),
              )) {
            return false;
          }
          return true;
        }).toList(),
      );
});
