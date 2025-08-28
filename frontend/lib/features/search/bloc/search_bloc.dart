import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:frontend/core/commons/models/player_model.dart';
import 'package:frontend/features/search/data/repository/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository = SearchRepository();
  Timer? _debounceTimer;
  String _currentQuery = '';

  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ClearSearch>(_onClearSearch);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // If query is empty, show initial state
    if (event.query.trim().isEmpty) {
      _currentQuery = '';
      emit(SearchInitial());
      return;
    }

    // Store current query
    _currentQuery = event.query;

    // Show loading state immediately
    await Future.delayed(const Duration(milliseconds: 1000), () {
      emit(SearchLoading());
    });

    // // Wait for 1 second before performing search
    // await Future.delayed(const Duration(milliseconds: 1500));

    // Check if query has changed during the delay
    if (_currentQuery != event.query) {
      return; // Query changed, don't search
    }

    try {
      debugPrint(
        '🔍 SearchBloc: Debounce completed, searching for: "${event.query}"',
      );
      final results = await _repository.searchPlayers(query: event.query);

      // Check if the bloc is still active and query hasn't changed
      if (!isClosed && _currentQuery == event.query) {
        debugPrint(
          '🔍 SearchBloc: Emitting SearchLoaded with ${results.length} results',
        );
        emit(SearchLoaded(results));
      }
    } catch (e) {
      debugPrint('❌ SearchBloc: Error during search: $e');
      // Check if the bloc is still active and query hasn't changed
      if (!isClosed && _currentQuery == event.query) {
        emit(SearchError('Failed to search: $e'));
      }
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    debugPrint('🔍 SearchBloc: Clearing search');
    _debounceTimer?.cancel();
    _currentQuery = '';
    emit(SearchInitial());
  }
}
