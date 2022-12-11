import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:contact_app/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = '/contact_details';
  const ContactDetailsPage({Key? key}) : super(key: key);

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final id = argList[0];
    final name = argList[1];

    return Scaffold(
      appBar: AppBar(title: Text(name),),
      body: Consumer<ContactProvider>(
        builder: ((context, provider, child) =>
        FutureBuilder<ContactModel>(
        future: provider.getById(id),
    builder: (context, snapshot) {

      if(snapshot.hasData) {
        final contact = snapshot.data!;
        return ListView(

          children: [
            contact.image == null ?
                Image.asset('images/imagenotfound.jpeg',width: double.infinity,height: 250,fit: BoxFit.cover,):
                Image.file(File(contact.image!),width: double.infinity,height: 250,fit: BoxFit.cover,),


            ListTile(
              title: Text(contact.mobile),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  IconButton(onPressed: (){
                   _callContact(contact.mobile);
                  },
                      icon: const Icon(Icons.call),
                  ),


                  IconButton(onPressed: (){

                  },
                    icon: const Icon(Icons.sms),
                  ),

                ],
              ),
            ),


            ListTile(
              title: Text(contact.email!.isEmpty ? 'Email not set yet' : contact.email!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  IconButton(onPressed: (){
                  showUpdateDialog(context: context,
                      tittle: 'Email',
                      onSaved: (value) async{
                     await provider.uupdateById(id,
                         tblContactColEmail, value);
                     setState(() {

                     });
                      });
                  },
                    icon:  Icon(Icons.edit),
                  ),

                 if(contact.email!.isNotEmpty) IconButton(onPressed: (){

                  },
                    icon:  Icon(Icons.email),
                  ),

                ],
              ),
            ),


            ListTile(
              title: Text(contact.streetAddress!.isEmpty ? 'Address not set yet' : contact.streetAddress!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,

                children: [

                  IconButton(onPressed: (){
                    showUpdateDialog(context: context,
                        tittle: 'Addresee',
                        onSaved: (value) async{
                          await provider.uupdateById(id,
                              tblContactColAddress, value);
                          setState(() {

                          });
                        });

                  },
                    icon:  Icon(Icons.edit),
                  ),

                  if(contact.streetAddress!.isNotEmpty) IconButton(onPressed: (){

                  },
                    icon:  Icon( Icons.location_city),
                  ),

                ],
              ),
            ),



            ListTile(
              title: Text(contact.website!.isEmpty ? 'Website not found' : contact.website!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,

                children: [

                  IconButton(onPressed: (){
                    showUpdateDialog(context: context,
                        tittle: 'Website',
                        onSaved: (value) async{
                          await provider.uupdateById(id,
                              tblContactColWebsite, value);
                          setState(() {

                          });
                        });

                  },
                    icon:  Icon(Icons.edit),
                  ),

                  if(contact.website!.isNotEmpty) IconButton(onPressed: (){

                  },
                    icon:  Icon( Icons.web),
                  ),

                ],
              ),
            ),

           /* ListTile(
              title: Text(contact.dob!.isEmpty ? 'Date of birth not set yet' : contact.dob!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  IconButton(onPressed: (){

                  },
                    icon:  Icon(contact.dob!.isEmpty ? Icons.edit : Icons.date_range),
                  ),

                ],
              ),
            ),*/
          ],
        );
    }
      if(snapshot.hasError){
        return const Center(
        child: Text('Failed to fetch ata'),
        );
    }
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    )
      ),
    ),
    );
  }

  void _callContact(String mobile) async {
    final url = ' tel:$mobile';
    if( await canLaunchUrlString(url)){
      await launchUrlString(url);

    } else {
      showMsg(context, 'Cannot perform this operation');
    }


  }
}
