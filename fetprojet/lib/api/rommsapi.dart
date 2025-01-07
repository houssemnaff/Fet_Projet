import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class Room {
  final String roomId;  
  final String name;
  final int capacity;
  final String type;

  Room({
    required this.roomId,
    required this.name,
    required this.capacity,
    required this.type,
  });

  // Convert JSON to Room object
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'],
      name: json['nameRoom'],
      capacity: json['capacity'],
      type: json['type'],
    );
  }

  // Convert Room object to JSON
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'nameRoom': name,
      'capacity': capacity,
      'type': type,
    };
  }
}

class RoomsApi {
  final String baseUrl = 'http://10.0.2.2:8081'; // URL for local testing

  // Add a new room with JSON body
  Future<String> addRoom(String sessionId, Room room) async {
    try {
      var uri = Uri.parse('$baseUrl/admin/session/$sessionId/rooms');
      
      var response = await http.post(
        uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(room.toJson()),
      );

      if (response.statusCode == 200) {
        return 'Room added successfully';
      } else {
        return 'Failed to add room: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error adding room: $e';
    }
  }

  // Delete a room by roomId
  Future<String> deleteRoom(String sessionId, String roomId) async {
    try {
      var uri = Uri.parse('$baseUrl/admin/session/$sessionId/rooms/$roomId');
      
      var response = await http.delete(uri);

      if (response.statusCode == 200) {
        return 'Room deleted successfully';
      } else {
        return 'Failed to delete room: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error deleting room: $e';
    }
  }

  // Get all rooms for a sessionId
  Future<List<Room>> getRooms(String sessionId) async {
    try {
      var uri = Uri.parse('$baseUrl/admin/session/$sessionId/rooms');
      
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((room) => Room.fromJson(room)).toList();
      } else {
        throw Exception('Failed to load rooms');
      }
    } catch (e) {
      throw Exception('Error fetching rooms: $e');
    }
  }

  // Get a room by roomId
  Future<Room> getRoomById(String sessionId, String roomId) async {
    try {
      var uri = Uri.parse('$baseUrl/admin/session/$sessionId/rooms/$roomId');
      
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        return Room.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load room');
      }
    } catch (e) {
      throw Exception('Error fetching room: $e');
    }
  }

  // Update a room by roomId
  Future<String> updateRoom(String sessionId, String roomId, Room room) async {
    try {
      var uri = Uri.parse('$baseUrl/admin/session/$sessionId/rooms/$roomId');
      
      var response = await http.put(
        uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(room.toJson()),
      );

      if (response.statusCode == 200) {
        return 'Room updated successfully';
      } else {
        return 'Failed to update room: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error updating room: $e';
    }
  }
}
