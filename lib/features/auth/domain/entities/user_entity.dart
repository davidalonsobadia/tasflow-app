class UserEntity {
  final String id;
  final String name;
  final String email;
  final String password;
  final String deviceId;
  final String passCode;
  final String location;
  final bool collaboratingWorkshop;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.deviceId,
    required this.passCode,
    required this.location,
    this.collaboratingWorkshop = false,
  });
}
