import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:hive_crud/Blocs/text_provider.dart';
import 'package:hive_crud/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllContacts();
    searchController.addListener(() {
      filterContacts();
    });
  }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String serachTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName!.toLowerCase();
        return contactName.contains(serachTerm);
      });
      setState(() {
        contactsFiltered = _contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final text_provider = Provider.of<TextProvider>(context);
    bool IsSearching = searchController.text.isNotEmpty;
    return Scaffold(
        appBar: AppBar(
          title: Text('${AppLocalizations.of(context)!.contactlist}'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context)!.search2}',
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Theme.of(context).primaryColor)),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                      )),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: IsSearching == true
                          ? contactsFiltered.length
                          : contacts.length,
                      itemBuilder: (context, index) {
                        Contact contact = IsSearching == true
                            ? contactsFiltered[index]
                            : contacts[index];
                        return ListTile(
                          title: Text("${contact.displayName}"),
                          subtitle:
                              Text("${contact.phones?.elementAt(0).value}"),
                          leading: (contact.avatar != null &&
                                  contact.avatar!.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(contact.avatar!),
                                )
                              : CircleAvatar(child: Text(contact.initials())),
                          onTap: () {
                            text_provider
                                .getName(contact.displayName as String);
                            Navigator.pop(context);
                          },
                        );
                      }))
            ],
          ),
        ));
  }
}
