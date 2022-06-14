import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/entities/user.dart';
import 'package:frontend/main.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Edit info'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Consumer<ApplicationState>(
                builder: (context, appState, _) => Container(
                  child: appState.identityUser!.profilePicture == null
                      ? TextButton(
                    onPressed: () => getImage(appState),
                    child: Text(
                      'Pick image',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: Colors.blueGrey),
                    ),
                  )
                      : Column(
                    children: [
                      // Image.network(
                      //   appState.identityUser?.profilePicture ?? '',
                      //   loadingBuilder: (BuildContext context, Widget child,
                      //       ImageChunkEvent? loadingProgress) {
                      //     if (loadingProgress == null) return child;
                      //     return Center(
                      //       child: CircularProgressIndicator(
                      //         value: loadingProgress.expectedTotalBytes !=
                      //                 null
                      //             ? loadingProgress.cumulativeBytesLoaded /
                      //                 loadingProgress.expectedTotalBytes!
                      //             : null,
                      //       ),
                      //     );
                      //   },
                      // ),
                      CircleAvatar(
                        radius: 65,
                        foregroundImage: NetworkImage(
                            appState.identityUser?.profilePicture ?? ''
                        ),
                        backgroundColor: Constants.c_purple,
                        child: const Icon(
                          Icons.person_rounded,
                          color: Constants.c_green,
                        ),

                      ),
                      TextButton(
                        onPressed: () => getImage(appState),
                        child: Text(
                          'Change image',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<ApplicationState>(
                builder: (context, appState, _) => Container(
                  child: const UserDataForm(),

                ),
              ),
              SizedBox(height: 50,),
            ],
          ),
        )
    );
  }

  Future<void> getImage(ApplicationState appState) async {
    XFile? imageReturned = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75);
    final path = 'files/${imageReturned!.name}';
    final file = File(imageReturned!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    var uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
    IdentityUser? user = appState.identityUser;
    if (user != null) {
      user.profilePicture = urlDownload;
    }
    appState.updateIdentityUser(user!);
    this.setState(() {
      image = imageReturned;
    });
  }
}

class UserDataForm extends StatefulWidget{
  const UserDataForm({super.key});

  @override
  UserDataFormState createState(){
    return UserDataFormState();
  }
}
class UserDataFormState extends State<UserDataForm>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => Container(
          child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(

                          labelText: 'Name',
                          labelStyle: TextStyle(
                              fontSize: 17
                          )
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(

                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontSize: 17
                          )
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(

                          labelText: 'Age',
                          labelStyle: TextStyle(
                              fontSize: 17
                          )
                      ),
                      validator: (value) {
                        if (int.parse(value!) < 18) {
                          return 'You must be 18 or older for participating to our events';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                        onPressed:() => getData(appState),
                        child: Text('Save')
                    )
                  ],
                ),
              )
          ),
        ),
    );
  }

  Future <void> getData(ApplicationState appState) async {
      //TODO implementation
  }

}
