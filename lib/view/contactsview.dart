import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import '../controllers/contact_controller.dart';
import '../model/contact.dart';
import 'contact_detail.dart';
import 'dart:async'; // Import the dart:async package for Timer

class ContactsView extends StatefulWidget {
  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final ContactController controller = Get.find<ContactController>();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Fetch contacts initially when the page is accessed
    controller.fetchContacts();
    // Start a timer to refresh the contacts every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      controller.fetchContacts();  // Trigger the fetchContacts method every 5 seconds
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          return Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                    title: Container(
                      height: 10,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      height: 10,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          );
        }

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    letter,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...contacts.map((contact) => ListTile(
                  leading: CircleAvatar(child: Text(contact.name[0].toUpperCase())),
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                  trailing: IconButton(
                    icon: Icon(
                      contact.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: contact.isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      controller.toggleFavorite(contact);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactDetailView(contact: contact),
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
  final _formKey = GlobalKey<FormState>(); // Create a form key for validation

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for the dialog
      ),
      title: Text(
        'Add Contact',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      content: Form(
        key: _formKey, // Attach the form key to the Form widget
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null; // No error
                  },
                ),
                SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              // Only add the contact if the form is valid
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
            }
          },
          child: Text('Add'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    ),
  );
}

}
