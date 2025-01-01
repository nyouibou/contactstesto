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

  // Update the factory method to accept the document ID and data separately
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
}
