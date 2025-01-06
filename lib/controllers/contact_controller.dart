
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/contact.dart';
import 'auth_controller.dart';

class ContactController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find<AuthController>();
  RxList<Contact> contacts = <Contact>[].obs;
  RxList<Contact> filteredContacts = <Contact>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContacts(); // Fetch contacts when the controller is initialized
  }

  // Future<void> fetchContacts() async {
  //   try {
  //     final role = authController.userRole.value;
  //     QuerySnapshot<Map<String, dynamic>> snapshot;

  //     if (role == 'admin') {
  //       snapshot = await firestore.collection('contacts').get();
  //     } else {
  //       snapshot = await firestore
  //           .collection('contacts')
  //           .where('ownerId', isEqualTo: authController.firebaseUser.value!.uid)
  //           .get();
  //     }

  //     contacts.value = snapshot.docs
  //         .map((doc) => Contact.fromMap(doc.id, doc.data()))
  //         .toList();

  //     filterContacts(); // Call filtering after fetching
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to fetch contacts: $e');
  //   }
  // }

//   Future<void> fetchContacts() async {
//   try {
//     final role = authController.userRole.value;
//     QuerySnapshot<Map<String, dynamic>> snapshot;

//     // Admins can see all contacts
//     if (role == 'admin') {
//       snapshot = await firestore.collection('contacts').get();
//     } else {
//       // Regular users can see their own contacts and admin contacts
//       snapshot = await firestore
//           .collection('contacts')
//           .where('ownerId', whereIn: [authController.firebaseUser.value!.uid, 'admin'])
//           .get();
//     }

//     // Mapping Firestore documents to Contact model
//     contacts.value = snapshot.docs
//         .map((doc) => Contact.fromMap(doc.id, doc.data()))
//         .toList();

//     // Filter contacts based on search query
//     filterContacts();
//   } catch (e) {
//     Get.snackbar('Error', 'Failed to fetch contacts: $e');
//   }
// }


Future<void> fetchContacts() async {
  try {
    final role = authController.userRole.value;
    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (role == 'admin') {
      // Admins can see all contacts
      snapshot = await firestore.collection('contacts').get();
    } else {
      // Fetch contacts where the owner is the current user or an admin
      snapshot = await firestore
          .collection('contacts')
          .where('ownerId', whereIn: [authController.firebaseUser.value!.uid, 'admin'])
          .get();
    }

    // Map Firestore documents to the Contact model
    contacts.value = snapshot.docs
        .map((doc) => Contact.fromMap(doc.id, doc.data()))
        .toList();

    // Apply search filter after fetching contacts
    filterContacts();
  } catch (e) {
    Get.snackbar('Error', 'Failed to fetch contacts: $e');
  }
}



  // Future<void> addContact(Contact contact) async {
  //   try {
  //     final docRef =
  //         await firestore.collection('contacts').add(contact.toMap());
  //     contact.id = docRef.id; // Assign the Firestore ID to the contact
  //     contacts.add(contact); // Add it locally for immediate display
  //     Get.snackbar('Success', 'Contact added successfully!');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to add contact: $e');
  //   }
  // }

  Future<void> addContact(Contact contact) async {
  try {
    // Set the ownerId based on user role
    final ownerId = authController.userRole.value == 'admin'
        ? 'admin' // Admin can add contacts with 'admin' as ownerId
        : authController.firebaseUser.value!.uid; // Regular users add contacts with their own UID

    // Update the contact's ownerId
    final updatedContact = contact.copyWith(ownerId: ownerId);

    // Add the contact to Firestore
    final docRef = await firestore.collection('contacts').add(updatedContact.toMap());
    updatedContact.id = docRef.id; // Assign the Firestore ID to the contact

    // Add it locally for immediate display
    contacts.add(updatedContact);
    Get.snackbar('Success', 'Contact added successfully!');
  } catch (e) {
    Get.snackbar('Error', 'Failed to add contact: $e');
  }
}



  Future<void> toggleFavorite(Contact contact) async {
  try {
    // Toggle favorite status
    final updatedStatus = !contact.isFavorite;

    // Update Firestore
    await firestore.collection('contacts').doc(contact.id).update({
      'isFavorite': updatedStatus,
    });

    // Update local list
    final index = contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      contacts[index] = contacts[index].copyWith(isFavorite: updatedStatus);
      updateSearchQuery(searchQuery.value); // Update filteredContacts
    }

    // Notify user
    Get.snackbar(
      'Success',
      updatedStatus
          ? '${contact.name} added to favorites!'
          : '${contact.name} removed from favorites!',
    );
  } catch (e) {
    Get.snackbar('Error', 'Failed to update favorite status: $e');
  }
}


  // Future<void> deleteContact(Contact contact) async {
  //   final role = authController.userRole.value;
  //   if (role == 'admin') {
  //     await firestore.collection('contacts').doc(contact.id).delete();
  //     await fetchContacts(); // Re-fetch contacts after delete
  //   } else {
  //     Get.snackbar('Permission Denied', 'Only admins can delete contacts.');
  //   }
  // }

Future<void> deleteContact(Contact contact) async {
  final role = authController.userRole.value;
  
  try {
    if (role == 'admin') {
      // Admins can delete any contact
      await firestore.collection('contacts').doc(contact.id).delete();
      await fetchContacts(); // Re-fetch contacts after delete
      Get.snackbar('Success', 'Contact deleted successfully!');
    } else if (role == 'user' && contact.ownerId == authController.firebaseUser.value!.uid) {
      // Regular users can only delete their own contacts
      await firestore.collection('contacts').doc(contact.id).delete();
      await fetchContacts(); // Re-fetch contacts after delete
      Get.snackbar('Success', 'Contact deleted successfully!');
    } else {
      Get.snackbar('Permission Denied', 'You can only delete your own contacts.');
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to delete contact: $e');
  }
}


  void filterContacts() {
    if (searchQuery.value.isEmpty) {
      filteredContacts.value =
          contacts; // Show all contacts when query is empty
    } else {
      filteredContacts.value = contacts.where((contact) {
        final lowerCaseQuery = searchQuery.value.toLowerCase();
        return contact.name.toLowerCase().contains(lowerCaseQuery) ||
            contact.phone.contains(lowerCaseQuery);
      }).toList();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterContacts();
  }

  Future<void> editContact({
    required Contact contact,
    required String name,
    required String phone,
    required String email,
    Map<String, String>? customFields,required String? whatsapp,required String? facebook,required String? instagram,required String? youtube,
  }) async {
    try {
      // Update the contact's fields locally
      contact.name = name;
      contact.phone = phone;
      contact.email = email;
      contact.facebook=facebook;
      contact.whatsapp=whatsapp;
      contact.instagram=instagram;
      contact.youtube=youtube;

      // Update custom fields if provided
      if (customFields != null) {
        contact.customFields = customFields;
      }

      // Prepare the Firestore update map
      final updateData = <String, dynamic>{
        'name': contact.name,
        'phone': contact.phone,
        'email': contact.email,
        'facebook': contact.facebook,
        'youtube': contact.youtube,
        'whatsapp': contact.whatsapp,
        'instagram': contact.instagram,
        'isFavorite': contact.isFavorite,
        'ownerId': contact.ownerId,
      };

      if (customFields != null) {
        updateData['customFields'] = customFields;
      }

      // Update the contact in Firestore
      await firestore.collection('contacts').doc(contact.id).update(updateData);

      // Update locally using GetX state management
      updateContact(contact);

      // Notify the user of success
      Get.snackbar('Success', 'Contact updated successfully!');
    } catch (e) {
      // Handle any errors
      Get.snackbar('Error', 'Failed to update contact: $e');
    }
  }

  void updateContact(Contact updatedContact) {
    final index =
        contacts.indexWhere((contact) => contact.id == updatedContact.id);
    if (index != -1) {
      contacts[index] = updatedContact; // Update the contact locally
      update(); // Notify GetX listeners of the update
      Get.snackbar('Success', 'Contact updated successfully!');
    } else {
      Get.snackbar('Error', 'Contact not found');
    }
  }
}
