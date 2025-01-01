import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';
import '../controllers/contact_import.dart';

class ContactImportView extends StatelessWidget {
  final ContactImportController importController =
      Get.put(ContactImportController());
  final ContactController contactController = Get.find<ContactController>();

  @override
  Widget build(BuildContext context) {
    importController.fetchDeviceContacts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Import Contacts'),
      ),
      body: Obx(() {
        if (importController.deviceContacts.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: importController.deviceContacts.length,
          itemBuilder: (context, index) {
            final contact = importController.deviceContacts[index];
            return ListTile(
              leading: CircleAvatar(child: Text(contact.name[0].toUpperCase())),
              title: Text(contact.name),
              subtitle: Text(
                  contact.phone.isNotEmpty ? contact.phone : 'No phone number'),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Save the imported contact to Firestore
                  contact.ownerId =
                      contactController.authController.firebaseUser.value!.uid;
                  contactController.addContact(contact);
                  Get.snackbar(
                      'Success', '${contact.name} imported successfully.');
                },
              ),
            );
          },
        );
      }),
    );
  }
}
