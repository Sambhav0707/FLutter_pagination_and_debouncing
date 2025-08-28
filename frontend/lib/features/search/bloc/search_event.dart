part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

/// Event when search query changes
final class SearchQueryChanged extends SearchEvent {
  final String query;

  SearchQueryChanged(this.query);
}

/// Event to clear search
final class ClearSearch extends SearchEvent {}
