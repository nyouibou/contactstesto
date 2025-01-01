import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/contact_controller.dart';
import '../../model/contact.dart';
import '../contact_detail.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;

  ContactTile({required this.contact});

  final ContactController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.name),
      subtitle: Text(contact.phone),
      trailing: IconButton(
        icon: Icon(contact.isFavorite ? Icons.star : Icons.star_border),
        onPressed: () => controller.toggleFavorite(contact),
      ),
      onTap: () => Get.to(ContactDetailView(contact: contact)),
    );
  }
}
