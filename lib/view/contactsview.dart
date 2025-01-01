import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';
import '../model/contact.dart';
import 'contact_detail.dart';

class ContactsView extends StatelessWidget {
  final ContactController controller = Get.find<ContactController>();

  @override
  Widget build(BuildContext context) {
    // Initiating contact fetching when the widget is built
    controller.fetchContacts();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => controller.updateSearchQuery(value),
          decoration: InputDecoration(
            hintText: 'Search contacts...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        final filteredContacts = controller.filteredContacts;
        if (filteredContacts.isEmpty) {
          return Center(child: Text('No contacts found.'));
        }

        // Group contacts by the first letter of the name
        final Map<String, List<Contact>> groupedContacts = {};
        for (var contact in filteredContacts) {
          final firstLetter = contact.name[0].toUpperCase();
          groupedContacts.putIfAbsent(firstLetter, () => []).add(contact);
        }

        return ListView.builder(
          itemCount: groupedContacts.keys.length,
          itemBuilder: (context, index) {
            final letter = groupedContacts.keys.elementAt(index);
            final contacts = groupedContacts[letter]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header (Alphabet)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    letter,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // List of Contacts under this letter
                ...contacts.map((contact) => ListTile(
                      leading: CircleAvatar(
                          child: Text(contact.name[0].toUpperCase())),
                      title: Text(contact.name),
                      subtitle: Text(contact.phone),
                      trailing: IconButton(
                        icon: Icon(
                          contact.isFavorite ? Icons.star : Icons.star_border,
                          color: contact.isFavorite ? Colors.yellow : null,
                        ),
                        onPressed: () {
                          controller.toggleFavorite(contact);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ContactDetailView(contact: contact),
                          ),
                        );
                      },
                    )),
              ],
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name')),
            TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone')),
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final contact = Contact(
                id: '',
                name: nameController.text,
                phone: phoneController.text,
                email: emailController.text,
                ownerId: controller.authController.firebaseUser.value!.uid,
                isFavorite: false, // New contacts are not favorite by default
              );
              controller.addContact(contact);
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
