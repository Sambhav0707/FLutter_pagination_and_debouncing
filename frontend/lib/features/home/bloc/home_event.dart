part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

/// Event to load the first page of players
final class LoadInitialPlayers extends HomeEvent {}

/// Event to load the next page of players
final class LoadMorePlayers extends HomeEvent {}

/// Event to refresh all players (reset pagination)
final class RefreshPlayers extends HomeEvent {}
