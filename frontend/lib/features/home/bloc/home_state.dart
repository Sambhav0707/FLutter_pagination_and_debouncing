part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

/// Initial state when the app starts
final class HomeInitial extends HomeState {}

/// State when loading the first page
final class HomeLoading extends HomeState {}

/// State when loading more players (pagination)
final class HomeLoadingMore extends HomeState {
  final List<PlayerModel> players;

  HomeLoadingMore(this.players);
}

/// State when players are loaded successfully
final class HomeLoaded extends HomeState {
  final List<PlayerModel> players;
  final bool hasReachedMax;

  HomeLoaded(this.players, {this.hasReachedMax = false});
}

/// State when there's an error
final class HomeError extends HomeState {
  final String message;
  final List<PlayerModel>? players; // Keep existing players if available

  HomeError(this.message, {this.players});
}
