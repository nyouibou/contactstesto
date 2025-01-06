// import 'package:flutter/material.dart';
// import '../model/contact.dart';
// import '../controllers/contact_controller.dart';
// import 'package:get/get.dart';

// class AddEditContactPage extends StatelessWidget {
//   final Contact? contact;

//   const AddEditContactPage({Key? key, this.contact}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ContactController contactController = Get.find<ContactController>();

//     // Controllers for Text Fields
//     TextEditingController nameController =
//         TextEditingController(text: contact?.name ?? '');
//     TextEditingController phoneController =
//         TextEditingController(text: contact?.phone ?? '');
//     TextEditingController emailController =
//         TextEditingController(text: contact?.email ?? '');
//     TextEditingController whatsappController =
//         TextEditingController(text: contact?.whatsapp ?? '');
//     TextEditingController facebookController =
//         TextEditingController(text: contact?.facebook ?? '');
//     TextEditingController instagramController =
//         TextEditingController(text: contact?.instagram ?? '');
//     TextEditingController youtubeController =
//         TextEditingController(text: contact?.youtube ?? '');

//     // Focus Nodes
//     final nameFocusNode = FocusNode();
//     final phoneFocusNode = FocusNode();
//     final emailFocusNode = FocusNode();
//     final whatsappFocusNode = FocusNode();
//     final facebookFocusNode = FocusNode();
//     final instagramFocusNode = FocusNode();
//     final youtubeFocusNode = FocusNode();

//     // Reactive custom fields list
//     RxList<Map<String, dynamic>> customFields = <Map<String, dynamic>>[].obs;

//     // Load custom fields if contact exists
//     if (contact?.customFields != null) {
//       contact!.customFields?.forEach((label, value) {
//         customFields.add({
//           'label': label,
//           'labelController': TextEditingController(text: label),
//           'valueController': TextEditingController(text: value),
//         });
//       });
//     }

//     // Method to save or update contact
//     void _saveContact() {
//       if (nameController.text.isEmpty || phoneController.text.isEmpty) {
//         Get.snackbar('Validation Error', 'Name, Phone are required fields.');
//         return;
//       }

//       // Collect custom fields data
//       Map<String, String> customFieldsMap = Map.fromEntries(
//         customFields.map((field) => MapEntry(
//               field['labelController']!.text,
//               field['valueController']!.text,
//             )),
//       );

//       if (contact == null) {
//         Contact newContact = Contact(
//           id: '',
//           name: nameController.text,
//           phone: phoneController.text,
//           email: emailController.text,
//           ownerId: 'ownerId',
//           customFields: customFieldsMap,
//           whatsapp: whatsappController.text,
//           facebook: facebookController.text,
//           instagram: instagramController.text,
//           youtube: youtubeController.text,
//         );
//         contactController.addContact(newContact);
//         Navigator.pop(context, newContact);
//       } else {
//         contact!.name = nameController.text;
//         contact!.phone = phoneController.text;
//         contact!.email = emailController.text;
//         contact!.customFields = customFieldsMap;
//         contact!.whatsapp = whatsappController.text;
//         contact!.facebook = facebookController.text;
//         contact!.instagram = instagramController.text;
//         contact!.youtube = youtubeController.text;

//         contactController.editContact(
//           contact: contact!,
//           name: nameController.text,
//           phone: phoneController.text,
//           email: emailController.text,
//           customFields: customFieldsMap,
//           whatsapp: whatsappController.text,
//           facebook: facebookController.text,
//           instagram: instagramController.text,
//           youtube: youtubeController.text,
//         );
//         Navigator.pop(context, contact);
//       }
//     }

//     // Add custom field
//     void _addCustomField() {
//       customFields.add({
//         'label': '',
//         'labelController': TextEditingController(),
//         'valueController': TextEditingController(),
//         'focusNode': FocusNode(),
//       });
//     }

//     // Remove custom field
//     void _removeCustomField(int index) {
//       customFields.removeAt(index);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(contact == null ? 'New Contact' : 'Edit Contact'),
//         actions: [
//           TextButton(
//             onPressed: _saveContact,
//             child: Text(
//               'Done',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildTextField(
//               controller: nameController,
//               labelText: 'Full Name',
//               icon: Icons.person,
//               focusNode: nameFocusNode,
//               nextFocusNode: phoneFocusNode,
//             ),
//             _buildTextField(
//               controller: phoneController,
//               labelText: 'Phone Number',
//               icon: Icons.phone,
//               focusNode: phoneFocusNode,
//               nextFocusNode: emailFocusNode,
//             ),
//             _buildTextField(
//               controller: emailController,
//               labelText: 'Email Address',
//               icon: Icons.email,
//               focusNode: emailFocusNode,
//             ),
//             _buildTextField(
//               controller: whatsappController,
//               labelText: 'WhatsApp',
//               icon: Icons.chat,
//               focusNode: whatsappFocusNode,
//             ),
//             _buildTextField(
//               controller: facebookController,
//               labelText: 'Facebook',
//               icon: Icons.facebook,
//               focusNode: facebookFocusNode,
//             ),
//             _buildTextField(
//               controller: instagramController,
//               labelText: 'Instagram',
//               icon: Icons.camera_alt,
//               focusNode: instagramFocusNode,
//             ),
//             _buildTextField(
//               controller: youtubeController,
//               labelText: 'YouTube',
//               icon: Icons.video_call,
//               focusNode: youtubeFocusNode,
//             ),
//             SizedBox(height: 20),
//             Obx(() {
//               return Column(
//                 children: customFields.asMap().entries.map((entry) {
//                   int index = entry.key;
//                   var field = entry.value;
//                   return Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: field['labelController'],
//                           focusNode: field['focusNode'],
//                           decoration: InputDecoration(
//                             labelText: 'Field Label',
//                             prefixIcon: Icon(Icons.label, color: Colors.blue),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onSubmitted: (_) => _addCustomField(),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: _buildTextField(
//                           controller: field['valueController'],
//                           labelText: 'Field Value',
//                           icon: Icons.edit,
//                           focusNode: field['focusNode'],
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.remove_circle, color: Colors.red),
//                         onPressed: () => _removeCustomField(index),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               );
//             }),
//             SizedBox(height: 10),
//             TextButton.icon(
//               onPressed: _addCustomField,
//               icon: Icon(Icons.add, color: Colors.blue),
//               label: Text('Add Custom Field'),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(color: Colors.redAccent),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _saveContact,
//                   child: Text('Save'),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     required IconData icon,
//     FocusNode? focusNode,
//     FocusNode? nextFocusNode,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         controller: controller,
//         focusNode: focusNode,
//         decoration: InputDecoration(
//           labelText: labelText,
//           prefixIcon: Icon(icon, color: Colors.blue),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         textInputAction: nextFocusNode != null
//             ? TextInputAction.next
//             : TextInputAction.done,
//         onSubmitted: (_) {
//           if (nextFocusNode != null) {
//             FocusScope.of(focusNode!.context!).requestFocus(nextFocusNode);
//           }
//         },
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // Added for Clipboard access
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
    TextEditingController whatsappController =
        TextEditingController(text: contact?.whatsapp ?? '');
    TextEditingController facebookController =
        TextEditingController(text: contact?.facebook ?? '');
    TextEditingController instagramController =
        TextEditingController(text: contact?.instagram ?? '');
    TextEditingController youtubeController =
        TextEditingController(text: contact?.youtube ?? '');

    // Focus Nodes
    final nameFocusNode = FocusNode();
    final phoneFocusNode = FocusNode();
    final emailFocusNode = FocusNode();
    final whatsappFocusNode = FocusNode();
    final facebookFocusNode = FocusNode();
    final instagramFocusNode = FocusNode();
    final youtubeFocusNode = FocusNode();

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
              field['labelController']!.text,
              field['valueController']!.text,
            )),
      );

      if (contact == null) {
        Contact newContact = Contact(
          id: '',
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
          ownerId: 'ownerId',
          customFields: customFieldsMap,
          whatsapp: whatsappController.text,
          facebook: facebookController.text,
          instagram: instagramController.text,
          youtube: youtubeController.text,
        );
        contactController.addContact(newContact);
        Navigator.pop(context, newContact);
      } else {
        contact!.name = nameController.text;
        contact!.phone = phoneController.text;
        contact!.email = emailController.text;
        contact!.customFields = customFieldsMap;
        contact!.whatsapp = whatsappController.text;
        contact!.facebook = facebookController.text;
        contact!.instagram = instagramController.text;
        contact!.youtube = youtubeController.text;

        contactController.editContact(
          contact: contact!,
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
          customFields: customFieldsMap,
          whatsapp: whatsappController.text,
          facebook: facebookController.text,
          instagram: instagramController.text,
          youtube: youtubeController.text,
        );
        Navigator.pop(context, contact);
      }
    }

    // Add custom field
    void _addCustomField() {
      customFields.add({
        'label': '',
        'labelController': TextEditingController(),
        'valueController': TextEditingController(),
        'focusNode': FocusNode(),
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(
              controller: nameController,
              labelText: 'Full Name',
              icon: Icons.person,
              focusNode: nameFocusNode,
              nextFocusNode: phoneFocusNode,
            ),
            _buildTextField(
              controller: phoneController,
              labelText: 'Phone Number',
              icon: Icons.phone,
              focusNode: phoneFocusNode,
              nextFocusNode: emailFocusNode,
            ),
            _buildTextField(
              controller: emailController,
              labelText: 'Email Address',
              icon: Icons.email,
              focusNode: emailFocusNode,
            ),
            _buildTextField(
              controller: whatsappController,
              labelText: 'WhatsApp',
              icon: Icons.chat,
              focusNode: whatsappFocusNode,
            ),
            _buildTextField(
              controller: facebookController,
              labelText: 'Facebook',
              icon: Icons.facebook,
              focusNode: facebookFocusNode,
            ),
            _buildTextField(
              controller: instagramController,
              labelText: 'Instagram',
              icon: Icons.camera_alt,
              focusNode: instagramFocusNode,
            ),
            _buildTextField(
              controller: youtubeController,
              labelText: 'YouTube',
              icon: Icons.video_call,
              focusNode: youtubeFocusNode,
            ),
            SizedBox(height: 20),
            Obx(() {
              return Column(
                children: customFields.asMap().entries.map((entry) {
                  int index = entry.key;
                  var field = entry.value;
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: field['labelController'],
                          focusNode: field['focusNode'],
                          decoration: InputDecoration(
                            labelText: 'Field Label',
                            prefixIcon: Icon(Icons.label, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onSubmitted: (_) => _addCustomField(),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          controller: field['valueController'],
                          labelText: 'Field Value',
                          icon: Icons.edit,
                          focusNode: field['focusNode'],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeCustomField(index),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textInputAction: nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        onSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(focusNode!.context!).requestFocus(nextFocusNode);
          }
        },
        // Enable copy-paste from the keyboard using Clipboard API
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: controller.text));
        },
      ),
    );
  }
}
