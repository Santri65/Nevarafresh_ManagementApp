/// Model representing a store location.
class Store {
  final String id;
  final String code;
  final String name;
  final String address;
  final String email;
  final String status;

  const Store({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.email,
    this.status = 'Activo',
  });

  Store copyWith({
    String? id,
    String? code,
    String? name,
    String? address,
    String? email,
    String? status,
  }) {
    return Store(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      address: address ?? this.address,
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }
}
