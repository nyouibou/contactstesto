import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';
import 'contact_detail.dart';

class AdminView extends StatelessWidget {
  final ContactController controller = Get.find<ContactController>();

  @override
  Widget build(BuildContext context) {
    controller.fetchContacts();

    return Scaffold(
      body: Obx(() => ListView.builder(
            itemCount: controller.contacts.length,
            itemBuilder: (context, index) {
              final contact = controller.contacts[index];
              return ListTile(
                leading:
                    CircleAvatar(child: Text(contact.name[0].toUpperCase())),
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactDetailView(contact: contact),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteContact(contact),
                ),
              );
            },
          )),
    );
  }
}
