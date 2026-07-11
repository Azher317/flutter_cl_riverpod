// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserEntity {
  const UserEntity({
    required this.id,
    required this.role,
    required this.name,
    required this.phone,
    this.profileImg,
    required this.createdAt,
  });

  final String id;
  final int role;
  final String name;
  final String phone;
  final String? profileImg;
  final String createdAt;

  @override
  String toString() {
    return 'UserEntity(id: $id, role: $role, name: $name, phone: $phone, profileImg: $profileImg, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.role == role &&
        other.name == name &&
        other.phone == phone &&
        other.profileImg == profileImg &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        role.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        profileImg.hashCode ^
        createdAt.hashCode;
  }
}
