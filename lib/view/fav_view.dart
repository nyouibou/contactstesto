import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';
import 'contact_detail.dart';

class FavoriteContactsPage extends StatelessWidget {
  final ContactController controller = Get.find<ContactController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final favoriteContacts =
          controller.contacts.where((contact) => contact.isFavorite).toList();

      if (favoriteContacts.isEmpty) {
        return Center(
          child: Text('No favorite contacts found.'),
        );
      }

      return ListView.builder(
        itemCount: favoriteContacts.length,
        itemBuilder: (context, index) {
          final contact = favoriteContacts[index];
          return ListTile(
            leading: CircleAvatar(child: Text(contact.name[0].toUpperCase())),
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: IconButton(
              icon: Icon(Icons.star),
              onPressed: () => controller.toggleFavorite(contact),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactDetailView(contact: contact),
                ),
              );
            },
          );
        },
      );
    });
  }
}
