import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/core/commons/models/player_model.dart';
import 'package:http/http.dart' as http;

class SearchRepository {
  // ### CHANGE THIS #### - Use localhost for web development, IP address for mobile
  static const String baseUrl = 'http://localhost:8081';

  Future<List<PlayerModel>> searchPlayers({
    String? query,
    String? name,
    String? role,
  }) async {
    try {
      debugPrint('🔍 SearchRepository: Starting search with query: "$query"');
      debugPrint('🔍 SearchRepository: Stack trace: ${StackTrace.current}');

      // Build query parameters
      final Map<String, String> queryParams = {};

      if (query != null && query.isNotEmpty) {
        queryParams['q'] = query.trim();
      }
      if (name != null && name.isNotEmpty) {
        queryParams['name'] = name.trim();
      }
      if (role != null && role.isNotEmpty) {
        queryParams['role'] = role.trim();
      }

      // Build URL with query parameters
      final uri = Uri.parse(
        '$baseUrl/api/searchPlayers',
      ).replace(queryParameters: queryParams);

      debugPrint('🔍 SearchRepository: Making API call to: $uri');

      final response = await http.get(uri);

      debugPrint(
        '🔍 SearchRepository: Response status: ${response.statusCode}',
      );
      debugPrint('🔍 SearchRepository: Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Success - return list of players
        final List<dynamic> data = jsonDecode(response.body);
        final results =
            data.map((player) => PlayerModel.fromJson(player)).toList();
        debugPrint('🔍 SearchRepository: Found ${results.length} players');
        return results;
      } else {
        // Error - return empty list
        debugPrint(
          '❌ SearchRepository: Search failed: ${response.statusCode} - ${response.body}',
        );
        return [];
      }
    } catch (e, stackTrace) {
      debugPrint('❌ SearchRepository: Error in searchPlayers: $e');
      debugPrint('❌ SearchRepository: Stack trace: $stackTrace');
      return [];
    }
  }

  /// Convenience method for general search
  Future<List<PlayerModel>> searchPlayersByQuery(String query) async {
    return searchPlayers(query: query);
  }

  /// Convenience method for searching by name
  Future<List<PlayerModel>> searchPlayersByName(String name) async {
    return searchPlayers(name: name);
  }

  /// Convenience method for searching by role
  Future<List<PlayerModel>> searchPlayersByRole(String role) async {
    return searchPlayers(role: role);
  }
}
