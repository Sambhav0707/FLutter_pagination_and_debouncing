part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

/// Initial state when no search is performed
final class SearchInitial extends SearchState {}

/// State when search is loading
final class SearchLoading extends SearchState {}

/// State when search results are loaded
final class SearchLoaded extends SearchState {
  final List<PlayerModel> results;

  SearchLoaded(this.results);
}

/// State when search encounters an error
final class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
