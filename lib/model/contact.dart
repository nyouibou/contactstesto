


class Contact {
  String id;
  String name;
  String phone;
  String email;
  bool isFavorite;
  String ownerId;
  Map<String, String>? customFields;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.isFavorite = false,
    required this.ownerId,
    this.customFields,
  });

  // Factory method to create a Contact from a map
  factory Contact.fromMap(String id, Map<String, dynamic> map) {
    return Contact(
      id: id,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      isFavorite: map['isFavorite'] as bool? ?? false,
      ownerId: map['ownerId'] as String,
      customFields: map['customFields'] != null
          ? Map<String, String>.from(map['customFields'])
          : null,
    );
  }

  // Convert Contact to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'isFavorite': isFavorite,
      'ownerId': ownerId,
      'customFields': customFields,
    };
  }

  // CopyWith method for creating a modified copy of the Contact
  Contact copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    bool? isFavorite,
    String? ownerId,
    Map<String, String>? customFields,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isFavorite: isFavorite ?? this.isFavorite,
      ownerId: ownerId ?? this.ownerId,
      customFields: customFields ?? this.customFields,
    );
  }
}
