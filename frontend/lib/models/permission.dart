class Permission {
  final int permissionID;
  final int userID;
  final int gateID;
  late final String permissionLevel;
  final String username;

  Permission({
    required this.permissionID,
    required this.userID,
    required this.gateID,
    required this.permissionLevel,
    required this.username,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      permissionID: json['PermissionID'],
      userID: json['UserID'],
      gateID: json['GateID'],
      permissionLevel: json['Permission_level'],
      username: json['Username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PermissionID': permissionID,
      'UserID': userID,
      'GateID': gateID,
      'Permission_level': permissionLevel,
      'Username': username,
    };
  }
}
