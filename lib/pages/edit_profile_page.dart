import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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
            Container(
              child: image == null
                  ? TextButton(
                      onPressed: getImage,
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
                        Image.file(File(image!.path)),
                        TextButton(
                          onPressed: getImage,
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
            // TODO: ADD Profile Info Edit features
          ],
        ));
  }

  Future<void> getImage() async {
    XFile? imageReturned = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = imageReturned;
    });
  }
}
