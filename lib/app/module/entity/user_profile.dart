class UserProfile {
  final int id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String nip;
  final String address;
  final String? profilePicture;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.nip,
    required this.address,
    this.profilePicture,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'] ?? '',
      nip: json['nip'] ?? '',
      address: json['address'] ?? '',
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'nip': nip,
      'address': address,
      'profile_picture': profilePicture,
    };
  }
}
