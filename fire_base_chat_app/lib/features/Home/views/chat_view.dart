import 'package:chat_app_firebase/core/utils/style/screen_size.dart';
import 'package:chat_app_firebase/features/Auth/data/user_model.dart';
import 'package:chat_app_firebase/features/Home/cubit/chat_cubit.dart';
import 'package:chat_app_firebase/features/Home/data/message_model.dart';
import 'package:chat_app_firebase/features/Home/widgets/reciver_message.dart';
import 'package:chat_app_firebase/features/Home/widgets/sender_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});
  static String routeName = 'chat-view';

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(ScreenSize.height / 50),
            width: ScreenSize.width,
            height: ScreenSize.height / 6,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(ScreenSize.width / 20),
                bottomRight: Radius.circular(ScreenSize.width / 20),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                ),
                CircleAvatar(
                  radius: ScreenSize.width / 15,
                  backgroundImage: NetworkImage(userModel.image!),
                ),
                const Spacer(flex: 1),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "Online",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(flex: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt, color: Colors.grey),
                    ),
                    SizedBox(height: ScreenSize.height / 100),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.call, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenSize.height / 20),
          StreamBuilder<QuerySnapshot>(
            stream: BlocProvider.of<ChatCubit>(
              context,
            ).getMessagesForSpecificUser(userEmail: userModel.email),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(child: SizedBox());
              } else {
                var messages = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      var messageData =
                          messages[i].data() as Map<String, dynamic>;
                      var message = MessageModel.fromJson(messageData);
                      bool isMe =
                          message.senderEmail ==
                          FirebaseAuth.instance.currentUser!.email;
                      return isMe
                          ? SenderMessageWidget(message: message.message)
                          : ReciverMessageWidget(message: message.message);
                    },
                  ),
                );
              }
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.width / 30),
            width: ScreenSize.width,
            height: ScreenSize.height / 10,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ScreenSize.width / 20),
                topRight: Radius.circular(ScreenSize.width / 20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type a message",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.camera_enhance, color: Colors.grey),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message, color: Colors.grey),
                ),
                IconButton(
                  onPressed: () async {
                    await BlocProvider.of<ChatCubit>(context).sentMessage(
                      message: messageController.text,
                      reciverEmail: userModel.email,
                      createdAt: DateTime.now(),
                    );
                    messageController.clear();
                  },
                  icon: Icon(Icons.mic, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
