import 'package:fetprojet/api/rommsapi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<Room> rooms = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";
      final RoomsApi api = RoomsApi();
      final roomsList = await api.getRooms(sessionId);
      setState(() {
        rooms = roomsList;
      });
    } catch (e) {
      print('Error loading rooms: $e');
    }
  }

  Future<void> _addRoom() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";

    if (_nameController.text.isEmpty ||
        _capacityController.text.isEmpty ||
        _typeController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Warning',
        text: 'Please fill in all fields!',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
      return;
    }

    final newRoom = Room(
      roomId: '',
      name: _nameController.text,
      capacity: int.parse(_capacityController.text),
      type: _typeController.text,
    );

    final api = RoomsApi();
    String result = await api.addRoom(sessionId, newRoom);

    if (result == 'Room added successfully') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Room added successfully!',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
      _loadRooms();
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Failed to add room. Please try again.',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
    }
  }

  Future<void> _deleteRoom(String roomId) async {
    if (roomId.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Room ID is missing.',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";
    final api = RoomsApi();
    String result = await api.deleteRoom(sessionId, roomId);
    if (result == 'Room deleted successfully') {
      _loadRooms();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Room deleted successfully!',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Failed to delete room.',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
    }
  }

  Future<void> _updateRoom(String roomId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";

    if (_nameController.text.isEmpty ||
        _capacityController.text.isEmpty ||
        _typeController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Warning',
        text: 'Please fill in all fields!',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
      return;
    }

    final updatedRoom = Room(
      roomId: roomId,
      name: _nameController.text,
      capacity: int.parse(_capacityController.text),
      type: _typeController.text,
    );

    final api = RoomsApi();
    String result = await api.updateRoom(sessionId, roomId, updatedRoom);

    if (result == 'Room updated successfully') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Room updated successfully!',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
      _loadRooms();
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Failed to update room. Please try again.',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rooms',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: rooms.isEmpty
          ? Center(
              child: Text(
                'No rooms available. Please add a room.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      room.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Capacity: ${room.capacity}, Type: ${room.type}',
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteRoom(room.roomId);
                      },
                    ),
                    onTap: () {
                      // Populate the form with the room data and show it
                      _nameController.text = room.name;
                      _capacityController.text = room.capacity.toString();
                      _typeController.text = room.type;

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Update Room'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Room Name',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: _capacityController,
                                    decoration: InputDecoration(
                                      labelText: 'Capacity',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: _typeController,
                                    decoration: InputDecoration(
                                      labelText: 'Type',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _updateRoom(room.roomId);
                                },
                                child: Text('Update'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add New Room'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Room Name',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _capacityController,
                        decoration: InputDecoration(
                          labelText: 'Capacity',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _typeController,
                        decoration: InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addRoom();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
