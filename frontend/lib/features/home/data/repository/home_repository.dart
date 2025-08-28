import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/core/commons/models/player_model.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  // Base URL for the API
  // ### CHANGE THIS #### - Use localhost for web development, IP address for mobile
  static const String baseUrl = 'http://192.168.29.36:8081';

  Future<List<PlayerModel>> getPlayers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/players'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((player) => PlayerModel.fromJson(player)).toList();
      } else {
        debugPrint('Failed to load players');
        debugPrint(response.body);
        return [];
      }
    } catch (e) {
      debugPrint('Error in getPlayers: $e');
      debugPrint(e.toString());
      return [];
    }
  }

  Future<PlayerModel?> getPlayer(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/searchPlayers?$id'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return PlayerModel.fromJson(data);
      } else {
        debugPrint('Failed to load player with id: $id');
        debugPrint(response.body);
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// Search players with multiple parameters
  /// [query] - General search parameter (searches both name and role)
  /// [name] - Search by player name specifically
  /// [role] - Search by player role specifically
  
}
