class UserProfile {
  final int userID;
  final String name;
  final String surname;
  final int roleID;
  final String cardID;
  final String email;
  final String password;
  final String username;

  UserProfile({
    required this.userID,
    required this.name,
    required this.surname,
    required this.roleID,
    required this.cardID,
    required this.email,
    required this.password,
    required this.username,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userID: json['UserID'],
      name: json['Name'],
      surname: json['Surname'],
      roleID: json['RoleID'],
      cardID: json['CardID'],
      email: json['Email'],
      password: json['Password'],
      username: json['Username'],
    );
  }
}
