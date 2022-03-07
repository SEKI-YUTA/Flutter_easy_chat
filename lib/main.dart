import 'package:easy_chat_app/ui/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  print('main');
//   const String serverURL = "https://mysterious-peak-16231.herokuapp.com/";

//   IO.Socket socket = IO.io(serverURL);

// //     const name = prompt("Waht is your name?");
// // appednMessage("You joined!");
// // socket.emit("new-user", name);
//   socket.connect();
//   socket.onConnect((data) {
//     print('connected');
//     // messages.add('connected');
//   });
//   socket.on("chat-message", (data) {
//     // console.log(data);
//     // appednMessage(`${data.name}: ${data.message}`);
//     // messages.add(data.message);
//   });
//   socket.on("user-connected", (name) {
//     // appednMessage(`${name} connected`);
//     // messages.add('someone connected!');
//   });

//   socket.on("user-disconnected", (name) {
//     // appednMessage(`${name} disconnected`);
//     // messages.add('someone left this chat');
//   });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}
