class User {
  final int? id;
  final String name;
  final String lastName;
  final String photo;
  final String role;
  final String cedula;
  final String phone;
  final String address;
  final String email;
  final String password;

  User({
    this.id,
    required this.name,
    required this.lastName,
    required this.photo,
    required this.role,
    required this.cedula,
    required this.phone,
    required this.address,
    required this.email,
    required this.password,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      lastName: map['lastName'],
      photo: map['photo'],
      role: map['role'],
      cedula: map['cedula'],
      phone: map['phone'],
      address: map['address'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'photo': photo,
      'role': role,
      'cedula': cedula,
      'phone': phone,
      'address': address,
      'email': email,
      'password': password,
    };
  }
}
