import 'package:contactstesto/view/contact_detail.dart';
import 'package:flutter/material.dart';
import '../model/contact.dart';

class ContactsPage extends StatefulWidget {
  final List<Contact> contacts;

  const ContactsPage({Key? key, required this.contacts}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filtered contacts based on search query
    final filteredContacts = widget.contacts
        .where((contact) =>
            contact.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // Group contacts alphabetically
    final Map<String, List<Contact>> groupedContacts = {};
    for (var contact in filteredContacts) {
      final firstLetter = contact.name[0].toUpperCase();
      groupedContacts.putIfAbsent(firstLetter, () => []).add(contact);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText:
                    'Search through all ${widget.contacts.length} contacts',
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: groupedContacts.keys.length,
        itemBuilder: (context, index) {
          final letter = groupedContacts.keys.elementAt(index);
          final contacts = groupedContacts[letter]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header (Alphabet)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  letter,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // List of Contacts under this letter
              ...contacts.map((contact) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.primaries[letter.codeUnitAt(0) %
                          Colors.primaries.length], // Dynamic color
                      child: Text(
                        contact.name[0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(contact.name),
                    onTap: () {
                      // Navigate to Contact Detail Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ContactDetailView(contact: contact),
                        ),
                      );
                    },
                  )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new contact functionality
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
