import 'dart:ui';

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
  final String serverURL = "http://localhost:3000";
  late IO.Socket socket;
  List<String> messages = ["Hi!", "Hello"];
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
    // socket = IO.io(serverURL);
    //     const name = prompt("Waht is your name?");
    // appednMessage("You joined!");
    // socket.emit("new-user", name);
    socket = IO.io(serverURL);
    socket.connect();

    // socket.on('connect', (data) {
    //   print('connected');
    // });
    socket.onConnect((data) {
      print('connected!');
      socket.emit("new-user", "名無し");
    });

    socket.on("chat-message", (data) {
      // console.log(data);
      // appednMessage(`${data.name}: ${data.message}`);
      setState(() {
        messages = [...messages, data["message"]];
      });
    });
    socket.on("user-connected", (name) {
      // appednMessage(`${name} connected`);
      setState(() {
        messages = [...messages, "someone connected"];
      });
    });

    socket.on("user-disconnected", (name) {
      // appednMessage(`${name} disconnected`);
      setState(() {
        messages = [...messages, "someone left"];
      });
    });

    // messageForm.addEventListener("submit", (e) => {
    //   e.preventDefault();
    //   const message = messageInput.value;
    //   appednMessage(`You: ${message}`);
    //   socket.emit("send-chat-message", message);
    //   messageInput.value = "";
    // });

    // function appednMessage(message) {
    //   const messageElement = document.createElement("div");
    //   messageElement.innerText = message;
    //   messageContainer.append(messageElement);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Easy Chat'),
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
            Text(socket.connected.toString()),
            ListView.builder(
              itemCount: messages.length,
              itemBuilder: ((context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                      top: 5, left: 20, right: 20, bottom: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(messages[index]),
                );
              }),
            ),
            _msgInputBar(_messageController, () {
              if (_messageController.text != "") {
                socket.emit("send-chat-message", _messageController.text);
                setState(() {
                  messages = [...messages, _messageController.text];
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

  Positioned _msgInputBar(
      TextEditingController controller, Function()? onPressed) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Container(
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
