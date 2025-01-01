// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:share_plus/share_plus.dart';
// import '../model/contact.dart';
// import 'addeditpage.dart';

// class ContactDetailView extends StatefulWidget {
//   final Contact contact;

//   const ContactDetailView({Key? key, required this.contact}) : super(key: key);

//   @override
//   _ContactDetailViewState createState() => _ContactDetailViewState();
// }

// class _ContactDetailViewState extends State<ContactDetailView> {
//   late Contact contact;

//   @override
//   void initState() {
//     super.initState();
//     contact = widget.contact;
//   }

//   Future<void> _launchPhone(String phoneNumber) async {
//     final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
//     try {
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       } else {
//         throw 'Could not launch phone: $phoneNumber';
//       }
//     } catch (e) {
//       _showErrorDialog('Could not make a call to $phoneNumber');
//     }
//   }

//   Future<void> _launchSMS(String phoneNumber) async {
//     final Uri uri = Uri(scheme: 'sms', path: phoneNumber);
//     try {
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       } else {
//         throw 'Could not send SMS to $phoneNumber';
//       }
//     } catch (e) {
//       _showErrorDialog('Could not send SMS to $phoneNumber');
//     }
//   }

//   Future<void> _launchEmail(String email) async {
//     final Uri uri = Uri(scheme: 'mailto', path: email);
//     try {
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       } else {
//         throw 'Could not open email client for $email';
//       }
//     } catch (e) {
//       _showErrorDialog('Could not open email client for $email');
//     }
//   }

//   void _shareContact() {
//     String customFields = contact.customFields?.entries
//             .map((e) => '${e.key}: ${e.value}')
//             .join('\n') ??
//         'No custom fields';
//     Share.share('Contact Information:\n'
//         'Name: ${contact.name}\n'
//         'Phone: ${contact.phone}\n'
//         'Email: ${contact.email}\n'
//         'Custom Fields:\n$customFields');
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Contact Details"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.share),
//             onPressed: _shareContact,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 60,
//               backgroundImage: NetworkImage(
//                 'https://i.pinimg.com/736x/44/98/b6/4498b6ef6034c4402a35ebdb757c9df9.jpg', // Replace with contact image
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               contact.name,
//               style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 12),
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.symmetric(vertical: 8),
//               child: ListTile(
//                 leading: Icon(Icons.phone, color: Colors.green),
//                 title: Text(contact.phone),
//                 subtitle: Text('Mobile'),
//                 trailing: IconButton(
//                   icon: Icon(Icons.message, color: Colors.blue),
//                   onPressed: () => _launchSMS(contact.phone),
//                 ),
//                 onTap: () => _launchPhone(contact.phone),
//               ),
//             ),
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.symmetric(vertical: 8),
//               child: ListTile(
//                 leading: Icon(Icons.email, color: Colors.red),
//                 title: Text(contact.email),
//                 subtitle: Text('Email'),
//                 onTap: () => _launchEmail(contact.email),
//               ),
//             ),
//             if (contact.customFields != null &&
//                 contact.customFields!.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Custom Fields",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8),
//                     ReorderableListView(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       onReorder: (oldIndex, newIndex) {
//                         setState(() {
//                           if (newIndex > oldIndex) newIndex -= 1;
//                           final entries =
//                               contact.customFields!.entries.toList();
//                           final movedItem = entries.removeAt(oldIndex);
//                           entries.insert(newIndex, movedItem);
//                           contact.customFields = Map.fromEntries(entries);
//                         });
//                       },
//                       children: contact.customFields!.entries.map((entry) {
//                         return Card(
//                           key: ValueKey(entry.key),
//                           elevation: 4,
//                           margin: EdgeInsets.symmetric(vertical: 4),
//                           child: ListTile(
//                             leading: Icon(Icons.info, color: Colors.teal),
//                             title: Text(entry.key),
//                             subtitle: Text(entry.value),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: () => _launchSMS(contact.phone),
//               icon: Icon(Icons.message),
//               label: Text('Message ${contact.phone}'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final updatedContact = await Navigator.push<Contact>(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddEditContactPage(contact: contact),
//             ),
//           );

//           if (updatedContact != null) {
//             setState(() {
//               contact = updatedContact;
//             });
//           }
//         },
//         child: Icon(Icons.edit),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/contact.dart';
import 'addeditpage.dart';

class OppoFixLauncher {
  static Future<void> launchCustomURL(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  static Future<void> launchPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    await launchCustomURL(uri);
  }

  static Future<void> launchSMS(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'sms', path: phoneNumber);
    await launchCustomURL(uri);
  }

  static Future<void> launchEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    await launchCustomURL(uri);
  }
}

class ContactDetailView extends StatefulWidget {
  final Contact contact;

  const ContactDetailView({Key? key, required this.contact}) : super(key: key);

  @override
  _ContactDetailViewState createState() => _ContactDetailViewState();
}

class _ContactDetailViewState extends State<ContactDetailView> {
  late Contact contact;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  Future<void> _saveCustomFieldsToFirebase() async {
    try {
      final customFields = contact.customFields;
      if (customFields != null) {
        await FirebaseFirestore.instance
            .collection('contacts')
            .doc(contact
                .id) // Ensure this ID matches the document ID in Firestore
            .update({'customFields': customFields});
        print('Custom fields saved to Firebase!');
      }
    } catch (e) {
      _showErrorDialog('Failed to save changes to Firebase: $e');
      print('Error updating Firebase: $e');
    }
  }

  void _shareContact() {
    String customFields = contact.customFields?.entries
            .map((e) => '${e.key}: ${e.value}')
            .join('\n') ??
        'No custom fields';
    Share.share('Contact Information:\n'
        'Name: ${contact.name}\n'
        'Phone: ${contact.phone}\n'
        'Email: ${contact.email}\n'
        'Custom Fields:\n$customFields');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareContact,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/736x/44/98/b6/4498b6ef6034c4402a35ebdb757c9df9.jpg', // Replace with contact image
              ),
            ),
            SizedBox(height: 16),
            Text(
              contact.name,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.phone, color: Colors.green),
                title: Text(contact.phone),
                subtitle: Text('Mobile'),
                trailing: IconButton(
                  icon: Icon(Icons.message, color: Colors.blue),
                  onPressed: () => OppoFixLauncher.launchSMS(contact.phone),
                ),
                onTap: () => OppoFixLauncher.launchPhone(contact.phone),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.red),
                title: Text(contact.email),
                subtitle: Text('Email'),
                onTap: () => OppoFixLauncher.launchEmail(contact.email),
              ),
            ),
            if (contact.customFields != null &&
                contact.customFields!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Custom Fields",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      onReorder: (oldIndex, newIndex) async {
                        if (newIndex > oldIndex) newIndex -= 1;

                        final entries = contact.customFields!.entries.toList();
                        final movedItem = entries.removeAt(oldIndex);
                        entries.insert(newIndex, movedItem);

                        setState(() {
                          contact.customFields = Map.fromEntries(entries);
                        });

                        // Save to Firebase after reordering
                        await _saveCustomFieldsToFirebase();
                      },
                      children: contact.customFields!.entries.map((entry) {
                        return Card(
                          key: ValueKey(entry.key),
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(Icons.info, color: Colors.teal),
                            title: Text(entry.key),
                            subtitle: Text(entry.value),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => OppoFixLauncher.launchSMS(contact.phone),
              icon: Icon(Icons.message),
              label: Text('Message ${contact.phone}'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updatedContact = await Navigator.push<Contact>(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditContactPage(contact: contact),
            ),
          );

          if (updatedContact != null) {
            setState(() {
              contact = updatedContact;
            });
          }
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
