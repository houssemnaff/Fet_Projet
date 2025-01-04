class User {
  String name;
  String email;
  String id;

  // Constructor
  User({required this.name, required this.email, required this.id});

  // Getters and Setters (optional, Dart allows direct property access)
  String getName() {
    return name;
  }

  void setName(String name) {
    this.name = name;
  }

  String getEmail() {
    return email;
  }

  void setEmail(String email) {
    this.email = email;
  }

  String getId() {
    return id;
  }

  void setId(String id) {
    this.id = id;
  }
}
