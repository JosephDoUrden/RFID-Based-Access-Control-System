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
      id: json['id'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
    );
  }
}
