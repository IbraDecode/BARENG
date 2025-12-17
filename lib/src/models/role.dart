enum Role { ibra, sinta }

extension RoleLabel on Role {
  String get displayName => this == Role.ibra ? 'Ibra' : 'Sinta';
  String get greeting => this == Role.ibra ? 'Halo, Tuan.' : 'Halo, Sinta.';
  String get partnerName => this == Role.ibra ? 'Sinta' : 'Ibra';
  String get emoji => this == Role.ibra ? '🛠️' : '🤍';
}
