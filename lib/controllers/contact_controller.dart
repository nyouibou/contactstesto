
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

  Future<void> fetchContacts() async {
    try {
      final role = authController.userRole.value;
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (role == 'admin') {
        snapshot = await firestore.collection('contacts').get();
      } else {
        snapshot = await firestore
            .collection('contacts')
            .where('ownerId', isEqualTo: authController.firebaseUser.value!.uid)
            .get();
      }

      contacts.value = snapshot.docs
          .map((doc) => Contact.fromMap(doc.id, doc.data()))
          .toList();

      filterContacts(); // Call filtering after fetching
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch contacts: $e');
    }
  }

  Future<void> addContact(Contact contact) async {
    try {
      final docRef =
          await firestore.collection('contacts').add(contact.toMap());
      contact.id = docRef.id; // Assign the Firestore ID to the contact
      contacts.add(contact); // Add it locally for immediate display
      Get.snackbar('Success', 'Contact added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add contact: $e');
    }
  }

  Future<void> toggleFavorite(Contact contact) async {
    try {
      contact.isFavorite = !contact.isFavorite; // Toggle favorite status
      await firestore.collection('contacts').doc(contact.id).update({
        'isFavorite': contact.isFavorite,
      });
      Get.snackbar(
        'Success',
        contact.isFavorite
            ? '${contact.name} added to favorites!'
            : '${contact.name} removed from favorites!',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite status: $e');
    }
  }

  Future<void> deleteContact(Contact contact) async {
    final role = authController.userRole.value;
    if (role == 'admin') {
      await firestore.collection('contacts').doc(contact.id).delete();
      await fetchContacts(); // Re-fetch contacts after delete
    } else {
      Get.snackbar('Permission Denied', 'Only admins can delete contacts.');
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
    Map<String, String>? customFields,
  }) async {
    try {
      // Update the contact's fields locally
      contact.name = name;
      contact.phone = phone;
      contact.email = email;

      // Update custom fields if provided
      if (customFields != null) {
        contact.customFields = customFields;
      }

      // Prepare the Firestore update map
      final updateData = <String, dynamic>{
        'name': contact.name,
        'phone': contact.phone,
        'email': contact.email,
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
