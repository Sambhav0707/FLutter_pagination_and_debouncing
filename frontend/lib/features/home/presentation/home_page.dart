import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/commons/models/player_model.dart';
import 'package:frontend/features/home/bloc/home_bloc.dart';
import 'package:frontend/features/search/presentation/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial players when page loads
    context.read<HomeBloc>().add(LoadInitialPlayers());

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200 pixels from bottom
      context.read<HomeBloc>().add(LoadMorePlayers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cricket Players'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeBloc>().add(RefreshPlayers());
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    return switch (state) {
      HomeInitial() => const Center(child: Text('Initializing...')),
      HomeLoading() => const Center(child: CircularProgressIndicator()),
      HomeLoadingMore() => _buildPlayerList(
        state.players,
        showLoadingMore: true,
      ),
      HomeLoaded() => _buildPlayerList(
        state.players,
        hasReachedMax: state.hasReachedMax,
      ),
      HomeError() => _buildErrorState(state),
    };
  }

  Widget _buildPlayerList(
    List<PlayerModel> players, {
    bool showLoadingMore = false,
    bool hasReachedMax = false,
  }) {
    if (players.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_cricket, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No players found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(RefreshPlayers());
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: players.length + (showLoadingMore || !hasReachedMax ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == players.length) {
            // Show loading indicator at bottom
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child:
                    showLoadingMore
                        ? const CircularProgressIndicator()
                        : const SizedBox.shrink(),
              ),
            );
          }

          final player = players[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getRoleColor(player.role),
                child: Text(
                  player.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                player.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                player.role,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRoleColor(player.role).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  player.role,
                  style: TextStyle(
                    color: _getRoleColor(player.role),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(HomeError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.red[700]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(LoadInitialPlayers());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'batsman':
        return Colors.orange;
      case 'bowler':
        return Colors.blue;
      case 'all-rounder':
        return Colors.purple;
      case 'wicket-keeper':
      case 'wicket keeper':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
