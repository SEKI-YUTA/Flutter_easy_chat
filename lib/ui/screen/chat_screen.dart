import 'dart:ui';

import 'package:easy_chat_app/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  // final String serverURL = "https://mysterious-peak-16231.herokuapp.com/";
  final String serverURL = "https://mysterious-peak-16231.herokuapp.com/";
  String mychatId = "";
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [
    // {"id": "xxxx", "message": "Hello"},
    // {"id": "yyy", "message": "Hi"},
  ];
  @override
  void initState() {
    super.initState();
    initSocket();
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  void initSocket() {
    print('initSocket');
    socket = IO.io(serverURL);
    socket.connect();

    // socket.on('connect', (data) {
    //   print('connected');
    // });
    socket.onConnect((data) {
      print('connected!');
      print('socketid is ${socket.id}');
      socket.emit('new-user', "");
      setState(() {
        mychatId = socket.id.toString();
      });
    });

    socket.on("chat-message", (data) {
      print("data${data}");
      setState(() {
        messages = [...messages, data];
      });
    });
    socket.on("user-connected", (id) {
      setState(() {
        messages = [
          ...messages,
          {"id": "usernotification", "message": "someone connected"}
        ];
      });
    });

    socket.on("user-disconnected", (id) {
      setState(() {
        messages = [
          ...messages,
          {"id": "usernotification", "message": "someone left"}
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Chat'),
        leading: IconButton(
          icon: Icon(Icons.nightlight),
          onPressed: () {
            ThemeService().switchTheme();
          },
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      opacity: 0.3,
                      image: AssetImage('images/bg_img.jpg'),
                      fit: BoxFit.cover)),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            ListView.builder(
              itemCount: messages.length,
              itemBuilder: ((context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                      top: 5, left: 20, right: 20, bottom: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: messages[index]["id"] == mychatId
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(messages[index]["message"]),
                        SizedBox(
                          width: 10,
                        ),
                        // Text("send by:${messages[index]["name"]}"),
                      ],
                    ),
                  ),
                );
              }),
            ),
            _msgInputBar(context, _messageController, () {
              if (_messageController.text != "") {
                socket.emit("send-chat-message", _messageController.text);
                setState(() {
                  messages = [
                    ...messages,
                    {
                      "id": "${socket.id}",
                      "message": "${_messageController.text}"
                    }
                  ];
                });
                _messageController.text = "";
                print('send message:${_messageController.text}');
              }
            })
          ],
        ),
      ),
    );
  }

  Positioned _msgInputBar(BuildContext context,
      TextEditingController controller, Function()? onPressed) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              child: Expanded(
                  child: TextField(
                controller: controller,
              )),
            ),
            IconButton(onPressed: onPressed, icon: Icon(Icons.send))
          ],
        ),
      ),
    );
  }

  // _askUsername() async {
  //   await showTextAnswerDialog(
  //       context: context,
  //       keyword: "あなたのなまえは？",
  //       onWillPop: () async {
  //         print('poped');
  //         return true;
  //       });
  // }
}
