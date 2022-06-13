import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/entities/user.dart';
import 'package:frontend/main.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
          title: const Text('Edit inf1o'),
        ),
        body: Column(
          children: [
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
                            // TODO: LOADER GIF
                            // backgroundImage: AssetImage('assets/loading.gif'),
                            child: CircleAvatar(
                              radius: 65,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  appState.identityUser?.profilePicture ?? ''),
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
            // TODO: ADD Profile Info Edit features
          ],
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
