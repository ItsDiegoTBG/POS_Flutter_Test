enum UserType { normal, admin }

class User {
  final int? id;
  final String username;
  final String password;
  final UserType userType;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.userType,
  });

  UserType getUserType(){
    return this.userType;
  }
 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
       'userType': userType.toString().split('.').last, 
    };
  }


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      userType: UserType.values.firstWhere((e) => e.toString().split('.').last == map['userType']),
    );
  }
}
