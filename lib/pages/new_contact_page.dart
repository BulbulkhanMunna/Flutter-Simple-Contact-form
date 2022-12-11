import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:contact_app/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewContactPage extends StatefulWidget {
  static const String routeName = '/new_contact';
  const NewContactPage({Key? key}) : super(key: key);

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}


class _NewContactPageState extends State<NewContactPage> {

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _webControoler = TextEditingController();

  String? dob;
  String? imagePath;
  ImageSource source = ImageSource.camera;
  final formKey = GlobalKey<FormState>();


  @override
  void dispose() {
   _nameController.dispose();
   _mobileController.dispose();
   _emailController.dispose();
   _addressController.dispose();
   _webControoler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contact'),
        actions: [
          IconButton(
              onPressed: _saveContact,
              icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width:100,
                    height: 100,
                    child: Card(
                      elevation: 5,
                      child: imagePath == null ? 
                      const Icon(Icons.person,size: 70,): 
                      Image.file(File(imagePath!), fit: BoxFit.cover,),
                    ),
                  ),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(onPressed: (){
                        source = ImageSource.camera;
                        _getImage();

                      },
                          icon: Icon(Icons.camera),
                          label: const Text('Capture'),
                      ),
                      TextButton.icon(onPressed: (){
                        source = ImageSource.gallery;
                        _getImage();

                      },
                        icon: Icon(Icons.photo_album),
                        label: const Text('Gallery'),
                      ),

                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10,),
            
            TextFormField(
              controller:  _nameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Contact Name *',
                prefixIcon: const Icon(Icons.person,color: Colors.red,),
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'This field must not be empty';
                }
                if(value.length > 20){
                  return 'Name should be less than or equals 20 charecters';
                }
                return null ;
              },

            ),

            const SizedBox(height: 10,),

            TextFormField(
              keyboardType: TextInputType.phone,
              controller:  _mobileController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Mobile Number *',
                prefixIcon: const Icon(Icons.call,color: Colors.red,),
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'This field must not be empty';
                }
                if(value.length == 11 || value.length == 14){
                  return null;
                }
                return 'Invalid mobile Number' ;
              },

            ),

            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller:  _emailController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Email Address',
                prefixIcon: const Icon(Icons.email,color: Colors.red,),
              ),
              validator: (value){
                return null ;
              },

            ),

            TextFormField(
              controller:  _addressController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Street Address',
                prefixIcon: const Icon(Icons.streetview,color: Colors.red,),
              ),
              validator: (value){

                return null ;
              },

            ),

            TextFormField(
              controller:  _webControoler,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Website',
                prefixIcon: const Icon(Icons.web,color: Colors.red,),
              ),
              validator: (value){

                return null ;
              },

            ),

           Card(
             elevation: 5,
             child: Padding(
               padding: EdgeInsets.all(8.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   TextButton.icon(
                     icon: const Icon(Icons.calendar_month),
                     onPressed: _showCalender,
                       label: const Text('Show Date Picker'),
                   ),
                   Text(
                     dob== null ? 'No Date chosen' : dob!,)
                 ],
               ),
             ) ,
           ),
          ],
        ),
      ),
    );
  }

  void _saveContact() {
    if(formKey.currentState!.validate()){
      final contact = ContactModel(
          name: _nameController.text,
          mobile: _mobileController.text,
          email: _emailController.text,
          streetAddress: _addressController.text,
          website: _webControoler.text,
          image: imagePath,
          dob: dob,
      );
      Provider
          .of<ContactProvider>(context,listen: false)
          .insert(contact).then((id){
            contact.id = id;
        Provider
            .of<ContactProvider>(context,listen: false).updateList(contact);
            Navigator.pop(context);
      }).catchError((error){
        print(error.toString());
        showMsg(context, 'Failed to save');
      });

    }
  }

  void _showCalender() async {
   final dateTime = await showDatePicker(
       context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now()
   );
   if(dateTime != null){
     setState(() {
      dob = getFormattedDate(dateTime, 'dd/MM/yyyy');
     });
   }
  }

  void _getImage() async {
  final xFile =  await ImagePicker().pickImage(source: source);
  if(xFile != null){
    setState(() {
      imagePath = xFile.path;
    });
  }

  }
}
