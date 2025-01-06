// // ignore_for_file: unused_local_variable

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/contact_controller.dart';
// import '../controllers/contact_import.dart';

// class ContactImportView extends StatelessWidget {
//   final ContactImportController importController =
//       Get.put(ContactImportController());
//   final ContactController contactController = Get.find<ContactController>();

//   // Set to hold the selected contact indices
//   final RxSet<int> selectedContacts = <int>{}.obs;

//   @override
//   Widget build(BuildContext context) {
//     importController.fetchDeviceContacts();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Import Contacts'),
//         actions: [
//           Obx(() {
//             // Show the bulk import button only if contacts are selected
//             return selectedContacts.isNotEmpty
//                 ? IconButton(
//                     icon: Icon(Icons.check),
//                     onPressed: () {
//                       // Import all selected contacts
//                       for (final index in selectedContacts) {
//                         final contact = importController.deviceContacts[index];
//                         contact.ownerId = contactController
//                             .authController.firebaseUser.value!.uid;
//                         contactController.addContact(contact);
//                       }
//                       // Clear the selection and show success message
//                       selectedContacts.clear();
//                       Get.snackbar(
//                           'Success', 'Contacts imported successfully.');
//                     },
//                   )
//                 : SizedBox.shrink();
//           }),
//         ],
//       ),
//       body: Obx(() {
//         if (importController.deviceContacts.isEmpty) {
//           return Center(child: CircularProgressIndicator());
//         }

//         return ListView.builder(
//           itemCount: importController.deviceContacts.length,
//           itemBuilder: (context, index) {
//             final contact = importController.deviceContacts[index];
//             final isSelected = selectedContacts.contains(index);

//             return ListTile(
//   leading: CircleAvatar(child: Text(contact.name[0].toUpperCase())),
//   title: Text(contact.name),
//   subtitle: Text(
//       contact.phone.isNotEmpty ? contact.phone : 'No phone number'),
//   trailing: Obx(() {
//     final isSelected = selectedContacts.contains(index);
//     return Checkbox(
//       value: isSelected,
//       onChanged: (bool? value) {
//         if (value == true) {
//           selectedContacts.add(index);
//         } else {
//           selectedContacts.remove(index);
//         }
//       },
//     );
//   }),
// );

//           },
//         );
//       }),
//     );
//   }
// }



// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contact_controller.dart';
import '../controllers/contact_import.dart';

class ContactImportView extends StatelessWidget {
  final ContactImportController importController =
      Get.put(ContactImportController());
  final ContactController contactController = Get.find<ContactController>();

  // Set to hold the selected contact indices
  final RxSet<int> selectedContacts = <int>{}.obs;

  @override
  Widget build(BuildContext context) {
    importController.fetchDeviceContacts();

    return Scaffold(
      appBar: AppBar(
        actions: [
          // "Select All" checkbox
          Obx(() {
            return importController.deviceContacts.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      children: [
                        Checkbox(
                          value: selectedContacts.length ==
                              importController.deviceContacts.length,
                          onChanged: (bool? value) {
                            if (value == true) {
                              // Select all contacts
                              selectedContacts.addAll(
                                List.generate(
                                    importController.deviceContacts.length,
                                    (index) => index),
                              );
                            } else {
                              // Deselect all contacts
                              selectedContacts.clear();
                            }
                          },
                        ),
                      ],
                    ),
                )
                : SizedBox.shrink();
          }),

          // Import TextButton
          Obx(() {
            return selectedContacts.isNotEmpty
                ? TextButton(
                    onPressed: () {
                      // Import all selected contacts
                      for (final index in selectedContacts) {
                        final contact = importController.deviceContacts[index];
                        contact.ownerId = contactController
                            .authController.firebaseUser.value!.uid;
                        contactController.addContact(contact);
                      }
                      // Clear the selection and show success message
                      selectedContacts.clear();
                      Get.snackbar(
                          'Success', 'Contacts imported successfully.');
                    },
                    child: Text(
                      'Import',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : SizedBox.shrink();
          }),
        ],
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
              leading: CircleAvatar(
                  child: Text(contact.name[0].toUpperCase())),
              title: Text(contact.name),
              subtitle: Text(contact.phone.isNotEmpty
                  ? contact.phone
                  : 'No phone number'),
              trailing: Obx(() {
                final isSelected = selectedContacts.contains(index);
                return Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    if (value == true) {
                      selectedContacts.add(index);
                    } else {
                      selectedContacts.remove(index);
                    }
                  },
                );
              }),
            );
          },
        );
      }),
    );
  }
}
