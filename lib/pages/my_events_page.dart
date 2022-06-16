import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/entities/event.dart';
import 'package:frontend/entities/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Center(
          child: Column(
            children: [
              SizedBox(height: 60,),
              FutureBuilder<List<Event>?>(
                future: getMyEvents(appState),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Event>?> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('Loading....');
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // return Text('Result: ${jsonEncode(snapshot.data)}');
                        if (snapshot.data == null || snapshot.data?.length == 0) {
                          return Text(
                            '0 events',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          );
                        }
                        return SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemBuilder: (context, i) {
                              // ToDo: Design a card with picture, title, description ( nullable )
                              return EventWidget(snapshot.data![i]);
                            },
                            itemCount: snapshot.data?.length,
                          ),
                        );
                      }
                  }
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Constants.c_purple
                  ),
                  onPressed: () {
                    IdentityUser? identityUser = appState.identityUser;
                    if (identityUser == null) {
                      return;
                    }
                    showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) => FractionallySizedBox(
                        child:
                        AddNewEvent(appState.publishNewEvent, identityUser),
                        heightFactor: 0.7,
                      ),
                    );
                  },
                  child: const Text(
                    'Add new event',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  )
              )
            ],
          ),
        )
      ),
    );
  }

  Future<List<Event>?> getMyEvents(ApplicationState appState) async {
    final accessToken = await appState.getAccessToken();
    final response = await http.get(Uri.parse('$baseUrl/event/mine'), headers: {
      'Authorization': 'Bearer $accessToken',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);

      return jsonResponse.map((event) => Event.fromJson(event)).toList();
    }
    return null;
  }
}

class EventWidget extends StatelessWidget {
  final Event event;
  const EventWidget(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // TODO: Resize picture and make it look nice, also look at text styles
            Image.network(event.picture, height: 125),
            Column(
              children: [
                Text(event.title),
                Text(event.description ?? 'No description')
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddNewEvent extends StatefulWidget {
  final Function callback;
  final IdentityUser user;

  const AddNewEvent(this.callback, this.user, {Key? key}) : super(key: key);

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  final _formKey = GlobalKey<FormState>();
  XFile? image;

  final ImagePicker _picker = ImagePicker();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController imageURLController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(fontSize: 17),
                  ),
                  validator: (value) =>
                      (value == null || value == '') ? 'Cant be null' : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(fontSize: 17),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                image == null
                    ? ElevatedButton(
                        onPressed: () {
                          getImage();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Constants.c_purple
                        ),
                        child: const Text('Pick image'),
                      )
                    : Column(
                        children: [
                          Image.file(
                            File(image!.path),
                            height: 250,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getImage();
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Constants.c_purple
                            ),
                            child: const Text('Change image'),
                          )
                        ],
                      ),
                ElevatedButton(
                    onPressed: handleFormSend,
                    style: ElevatedButton.styleFrom(
                        primary: Constants.c_purple
                    ),
                    child: Center(child: Text('Publish Event')))
              ],
            )),
      ),
    );
  }

  handleFormSend() async {
    if (_formKey.currentState!.validate()) {
      if (image == null || widget.user == null) return; // mandatory
      final path = 'files/${image!.name}';
      final file = File(image!.path);

      final ref = FirebaseStorage.instance.ref().child(path);
      var uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      Event event = Event(
          title: titleController.text,
          description: titleController.text,
          owner: widget.user,
          picture: urlDownload);
      widget.callback(event);
    }
  }

  Future<void> getImage() async {
    XFile? imageReturned = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75);

    setState(() {
      image = imageReturned;
    });
  }
}
