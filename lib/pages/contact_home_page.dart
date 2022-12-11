import 'package:contact_app/customwidgets/contact_item.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/pages/contact_details_page.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactHomePage extends StatelessWidget {
  static const String routeName = '/';
  const ContactHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ContactProvider>(context,listen: false).getAll();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      body: Consumer<ContactProvider>(
          builder:(context,provider,child)=>
          provider.contactList.isEmpty ?
          Center(child: const Text('No Contact Found'),):
              ListView.builder(
                itemCount: provider.contactList.length,
                  itemBuilder: (context,index){
                  final contact = provider.contactList[index];
                  return ContactItem(contact : contact, provider: provider,);
                  },
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NewContactPage.routeName),
        child: const Icon(Icons.add),
      ),
    );
  }


}
