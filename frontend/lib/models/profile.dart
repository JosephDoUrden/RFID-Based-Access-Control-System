class Profile {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final int roleId;

  Profile({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.roleId,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['UserID'],
      username: json['Username'] ?? '',
      firstname: json['Name'] ?? '',
      lastname: json['Surname'] ?? '',
      email: json['Email'] ?? '',
      roleId: json['RoleID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': id,
      'Username': username,
      'Name': firstname,
      'Surname': lastname,
      'Email': email,
      'RoleID': roleId,
    };
  }
}
