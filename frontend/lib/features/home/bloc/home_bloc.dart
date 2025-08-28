import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:frontend/core/commons/models/player_model.dart';
import 'package:frontend/features/home/data/repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository = HomeRepository();
  static const int _pageSize =
      10; // ### CHANGE THIS #### - Number of players per page
  List<PlayerModel> _allPlayers = [];
  List<PlayerModel> _displayedPlayers = [];
  int _currentIndex = 0;
  bool _isLoadingMore = false;

  HomeBloc() : super(HomeInitial()) {
    on<LoadInitialPlayers>(_onLoadInitialPlayers);
    on<LoadMorePlayers>(_onLoadMorePlayers);
    on<RefreshPlayers>(_onRefreshPlayers);
  }

  Future<void> _onLoadInitialPlayers(
    LoadInitialPlayers event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoading());

      // Load all players from API
      _allPlayers = await _repository.getPlayers();
      _currentIndex = 0;
      _displayedPlayers = [];

      // Get first page (only 10 players)
      final firstPage = _getNextPage();
      _displayedPlayers.addAll(firstPage);

      emit(
        HomeLoaded(
          _displayedPlayers,
          hasReachedMax: _currentIndex >= _allPlayers.length,
        ),
      );
    } catch (e) {
      emit(HomeError('Failed to load players: $e'));
    }
  }

  Future<void> _onLoadMorePlayers(
    LoadMorePlayers event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Check if we've reached the end or already loading
      if (_currentIndex >= _allPlayers.length || _isLoadingMore) {
        return;
      }

      _isLoadingMore = true;

      // Emit loading more state with current players
      final currentState = state;
      if (currentState is HomeLoaded) {
        emit(HomeLoadingMore(currentState.players));
      }

      // Simulate network delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      // Get next page (only 10 more players)
      final nextPage = _getNextPage();
      _displayedPlayers.addAll(nextPage);

      _isLoadingMore = false;

      emit(
        HomeLoaded(
          _displayedPlayers,
          hasReachedMax: _currentIndex >= _allPlayers.length,
        ),
      );
    } catch (e) {
      _isLoadingMore = false;
      emit(HomeError('Failed to load more players: $e'));
    }
  }

  Future<void> _onRefreshPlayers(
    RefreshPlayers event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoading());

      // Reload all players
      _allPlayers = await _repository.getPlayers();
      _currentIndex = 0;
      _displayedPlayers = [];

      // Get first page (only 10 players)
      final firstPage = _getNextPage();
      _displayedPlayers.addAll(firstPage);

      emit(
        HomeLoaded(
          _displayedPlayers,
          hasReachedMax: _currentIndex >= _allPlayers.length,
        ),
      );
    } catch (e) {
      emit(HomeError('Failed to refresh players: $e'));
    }
  }

  /// Get the next page of players (only 10 players)
  List<PlayerModel> _getNextPage() {
    final endIndex = (_currentIndex + _pageSize).clamp(0, _allPlayers.length);
    final page = _allPlayers.sublist(_currentIndex, endIndex);
    _currentIndex = endIndex;
    return page;
  }
}
