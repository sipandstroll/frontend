import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Constants.c_green, Constants.c_purple],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            )),
          ),
          elevation: 0,
          title: Container(
            child: const ImageIcon(
              AssetImage('assets/logo_nume_lowercase.png'),
              color: Colors.white,
              size: 200,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Edit info',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
                                  appState.identityUser?.profilePicture ?? ''),
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
                  builder: (context, appState, _) =>
                      UserDataForm(appState: appState)),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
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

class UserDataForm extends StatefulWidget {
  final ApplicationState appState;
  const UserDataForm({required this.appState, super.key});

  @override
  UserDataFormState createState() {
    return UserDataFormState();
  }
}

class UserDataFormState extends State<UserDataForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController ageController;

  @override
  void initState() {
    nameController =
        TextEditingController(text: widget.appState.identityUser?.name);
    emailController =
        TextEditingController(text: widget.appState.identityUser?.email);
    ageController = TextEditingController(
        text: widget.appState.identityUser?.age.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: nameController,
                    decoration: const InputDecoration(
                        labelText: 'Name', labelStyle: TextStyle(fontSize: 17)),
                    validator: (value) => null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 17)),
                    validator: (value) => null,
                  ),
                  TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(
                        labelText: 'Age', labelStyle: TextStyle(fontSize: 17)),
                    validator: (value) {
                      if (value != "" &&
                          value != null &&
                          int.parse(value) < 18) {
                        return 'You must be 18 or older for participating to our events';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final age = ageController.value.text;
                          final email = emailController.value.text;
                          final name = nameController.value.text;
                          IdentityUser currentUser = appState.identityUser!;

                          if (age != "") currentUser.age = int.parse(age);
                          if (email != "") currentUser.email = email;
                          if (name != "") currentUser.name = name;

                          appState.updateIdentityUser(currentUser);
                        }
                        print(ageController.value.text);
                      },
                      child: Text('Save'))
                ],
              ),
            )),
      ),
    );
  }
}
