import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/entities/event.dart';
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
        builder: (context, appState, _) => FutureBuilder<List<Event>?>(
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
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      // ToDo: Design a card with picture, title, description ( nullable )
                      return Text('Result: ${jsonEncode(snapshot.data![i])}');
                    },
                    itemCount: snapshot.data?.length,
                  );
                }
            }
          },
        ),
        child: Container(
          color: Colors.white,
          child: ListView.builder(
            itemBuilder: ((context, index) => const Text('123')),
          ),
        ),
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
