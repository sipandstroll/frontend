import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/main.dart';
import 'package:provider/provider.dart';

import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../entities/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<MatchEngine> populateSwipeItems(ApplicationState appState) async {
    List<Event>? events = await appState.getEvents();
    if (events != null) {
      for (int i = 0; i < events.length; i++) {
        _swipeItems.add(
          SwipeItem(
            content: events[i],
            likeAction: () {
              print("Liked ${events[i].title}");
            },
            nopeAction: () {
              print("Disliked ${events[i].title}");
            },
          ),
        );
      }
    }
    return MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        return FutureBuilder(
            future: populateSwipeItems(appState),
            builder:
                (BuildContext context, AsyncSnapshot<MatchEngine> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Loading....');
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Scaffold(
                        extendBodyBehindAppBar: true,
                        body: Container(
                            //height: MediaQuery.of(context).size.height - kToolbarHeight - 100,
                            child: Stack(children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 8),
                            //height: MediaQuery.of(context).size.height - kToolbarHeight ,
                            child: SwipeCards(
                              matchEngine: snapshot.data!,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          _swipeItems[index].content.picture),
                                    ),
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 10),
                                        blurRadius: 20,
                                      )
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _swipeItems[index].content.title,
                                    style: TextStyle(fontSize: 100),
                                  ),
                                );
                              },
                              onStackFinished: () {
                                _scaffoldKey.currentState!
                                    .showSnackBar(SnackBar(
                                  content: Text("Stack Finished"),
                                  duration: Duration(milliseconds: 500),
                                ));
                              },
                              itemChanged: (SwipeItem item, int index) {
                                print(
                                    "item: ${item.content.title}, index: $index");
                              },
                              upSwipeAllowed: true,
                              fillSpace: true,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 40.0),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        primary: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        _matchEngine!.currentItem?.nope();
                                      },
                                      child: ImageIcon(
                                        AssetImage('assets/X_icon.png'),
                                        color: Constants.c_red,
                                        size: 80,
                                      ),
                                    ),
                                    /*ElevatedButton(
                              onPressed: () {
                                _matchEngine!.currentItem?.superLike();
                              },
                              child: Text("Superlike")),*/
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        primary: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        _matchEngine!.currentItem?.like();
                                      },
                                      child: ImageIcon(
                                        AssetImage('assets/star_icon.png'),
                                        color: Constants.c_yellow,
                                        size: 80,
                                      ),
                                    )
                                  ],
                                )),
                          )
                        ])));
                  }
              }
            });
      },
    );
  }
}
