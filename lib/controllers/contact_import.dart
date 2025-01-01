// import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart'
    hide Contact; // Hides flutter_contacts' Contact
import '../model/contact.dart'; // Your app's Contact model

class ContactImportController extends GetxController {
  var deviceContacts = <Contact>[].obs; // Imported device contacts

  // Fetch device contacts
  Future<void> fetchDeviceContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      Get.snackbar('Permission Denied', 'Contacts access is required.');
      return;
    }

    final contacts = await FlutterContacts.getContacts(
      withProperties: true, // Includes phone numbers, emails, etc.
    );

    deviceContacts.value = contacts
        .map((c) => Contact(
              id: '',
              name: c.displayName,
              phone: c.phones.isNotEmpty ? c.phones.first.number : '',
              email: c.emails.isNotEmpty ? c.emails.first.address : '',
              ownerId: '', // Set the current user's ID or leave empty for now
            ))
        .toList();
  }
}
