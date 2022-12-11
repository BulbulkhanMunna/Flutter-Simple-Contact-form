import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';

import '../pages/contact_details_page.dart';

class ContactItem extends StatefulWidget {
  final ContactModel contact;
  final ContactProvider provider;
  const ContactItem({Key? key,required this.contact, required this.provider }) : super(key: key);

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,

        child: const Icon(Icons.delete,color: Colors.redAccent,),

      ),
      confirmDismiss:(direction){
        return  showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: const Text('Delete'),
                  content: Text('Are you sure to delet this contact ?'),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context, false);

                      }, child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context, true);

                        },
                        child: const Text('Yes'))
                  ],
                ));
      },

      onDismissed: (direction){
        widget.provider.deleteById(widget.contact.id);
      },
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
          ContactDetailsPage.routeName,
          arguments: [widget.contact.id,widget.contact.name],
        ),
        title: Text(widget.contact.name),
        trailing: IconButton(
          icon: Icon(widget.contact.favorite ? Icons.favorite : Icons.favorite_border),
          onPressed: () async{
            final value = widget.contact.favorite ? 0 : 1;
            await widget.provider.uupdateById(widget.contact.id, tblContactColFavorite, value);
            widget.contact.favorite = !widget.contact.favorite;
            setState(() {

            });
          },
        ),
      ),
    );
  }
}
