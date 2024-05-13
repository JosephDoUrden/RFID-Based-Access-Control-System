class Profile {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String email;

  Profile({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['UserID'],
      username: json['Username'] ?? '',
      firstname: json['Name'] ?? '',
      lastname: json['Surname'] ?? '',
      email: json['Email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': id,
      'Username': username,
      'Name': firstname,
      'Surname': lastname,
      'Email': email,
    };
  }
}
