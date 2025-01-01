import 'package:flutter/material.dart';
import '../model/contact.dart';
import '../controllers/contact_controller.dart';
import 'package:get/get.dart';

class AddEditContactPage extends StatelessWidget {
  final Contact? contact;

  const AddEditContactPage({Key? key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContactController contactController = Get.find<ContactController>();

    // Controllers for Text Fields
    TextEditingController nameController =
        TextEditingController(text: contact?.name ?? '');
    TextEditingController phoneController =
        TextEditingController(text: contact?.phone ?? '');
    TextEditingController emailController =
        TextEditingController(text: contact?.email ?? '');

    // Reactive custom fields list
    RxList<Map<String, dynamic>> customFields = <Map<String, dynamic>>[].obs;

    // Load custom fields if contact exists
    if (contact?.customFields != null) {
      contact!.customFields?.forEach((label, value) {
        customFields.add({
          'label': label,
          'labelController': TextEditingController(text: label),
          'valueController': TextEditingController(text: value),
        });
      });
    }

    // Method to save or update contact
    void _saveContact() {
      if (nameController.text.isEmpty || phoneController.text.isEmpty) {
        Get.snackbar('Validation Error', 'Name, Phone are required fields.');
        return;
      }

      // Collect custom fields data
      Map<String, String> customFieldsMap = Map.fromEntries(
        customFields.map((field) => MapEntry(
              field['labelController']!
                  .text, // Store the label from the TextEditingController
              field['valueController']!.text,
            )),
      );

      if (contact == null) {
        Contact newContact = Contact(
          id: '',
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
          ownerId: 'ownerId', // Replace with actual ownerId from AuthController
          customFields: customFieldsMap,
        );
        contactController.addContact(newContact);
        Navigator.pop(context, newContact);
      } else {
        contact!.name = nameController.text;
        contact!.phone = phoneController.text;
        contact!.email = emailController.text;
        contact!.customFields = customFieldsMap;

        contactController.editContact(
          contact: contact!,
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
          customFields: customFieldsMap,
        );
        Navigator.pop(context, contact);
      }
    }

    // Add custom field
    void _addCustomField() {
      customFields.add({
        'label': '', // Allow user to type the label
        'labelController': TextEditingController(),
        'valueController': TextEditingController(),
      });
    }

    // Remove custom field
    void _removeCustomField(int index) {
      customFields.removeAt(index);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(contact == null ? 'New Contact' : 'Edit Contact'),
        actions: [
          TextButton(
            onPressed: _saveContact,
            child: Text(
              'Done',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(nameController, 'Full Name', Icons.person),
            _buildTextField(phoneController, 'Phone Number', Icons.phone),
            _buildTextField(emailController, 'Email Address', Icons.email),
            SizedBox(height: 20),
            // Dynamically add custom fields
            Obx(() {
              return Column(
                children: customFields.asMap().entries.map((entry) {
                  int index = entry.key;
                  var field = entry.value;
                  return Column(
                    children: [
                      Row(
                        children: [
                          // TextField for label entry
                          Expanded(
                            child: TextField(
                              controller: field['labelController'],
                              decoration: InputDecoration(
                                labelText: 'Field Label',
                                prefixIcon:
                                    Icon(Icons.label, color: Colors.blue),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildTextField(
                              field['valueController']!,
                              'Field Value',
                              Icons.edit,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _removeCustomField(index),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              );
            }),
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: _addCustomField,
              icon: Icon(Icons.add, color: Colors.blue),
              label: Text('Add Custom Field'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveContact,
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
