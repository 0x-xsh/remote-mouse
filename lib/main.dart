import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'consts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var _channel = WebSocketChannel.connect(
    Uri.parse('ws://$IP:$PORT'),
  );

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.8;
    var height = MediaQuery.of(context).size.height * 0.8;

    void _decodeAndSend(pos) {
      var posToString = pos.substring(7, pos.length - 1);
      _channel.sink.add(utf8.encode(posToString));
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _channel = WebSocketChannel.connect(
                Uri.parse('ws://$IP:$PORT'),
              );
            });
          },
          child: Icon(Icons.done),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(194, 29, 76, 1.0),
                    Color.fromRGBO(199, 16, 215, 1.0),
                    Color.fromRGBO(224, 25, 115, 1.0),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onPanDown: (detail) {
                      _decodeAndSend(detail.localPosition.toString());
                    },
                    onPanUpdate: (detail) {
                      _decodeAndSend(detail.localPosition.toString());
                    },
                    child: Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
