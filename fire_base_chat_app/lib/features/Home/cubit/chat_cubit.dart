import 'dart:developer';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:chat_app_firebase/features/Auth/data/user_model.dart';
import 'package:chat_app_firebase/features/Home/data/chat_model.dart';
import 'package:chat_app_firebase/features/Home/data/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  sentMessage({
    required String message,
    required String reciverEmail,
    required DateTime createdAt,
  }) async {
    MessageModel messageModel = MessageModel(
      senderEmail: FirebaseAuth.instance.currentUser!.email.toString(),
      receiverEmail: reciverEmail,
      message: message,
      dateTime: createdAt,
    );
    await FirebaseFirestore.instance
        .collection('Messages')
        .add(messageModel.tojson());
  }

  //currentUser==sender&&anotherUser==reciver || currentUser==reciver&&anotherUser==sender
  Stream<QuerySnapshot> getMessagesForSpecificUser({
    required String userEmail,
  }) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection('Messages')
          .where(
            Filter.or(
              Filter.and(
                Filter(
                  "senderEmail",
                  isEqualTo: FirebaseAuth.instance.currentUser!.email,
                ),
                Filter("receiverEmail", isEqualTo: userEmail),
              ),
              Filter.and(
                Filter("senderEmail", isEqualTo: userEmail),
                Filter(
                  "receiverEmail",
                  isEqualTo: FirebaseAuth.instance.currentUser!.email,
                ),
              ),
            ),
          )
          .snapshots();
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  getpartnerData({required String email}) async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .get();
    UserModel userModel = UserModel.fromJson(user.data()!);
    return userModel;
  }

  Stream<List<ChatModel>> getlastTimeMessages() async* {
    final currentEmail = FirebaseAuth.instance.currentUser!.email;
    // ignore: non_constant_identifier_names
    CollectionReference Messages = FirebaseFirestore.instance.collection(
      'Messages',
    );
    await for (var snapshot in Messages.snapshots()) {
      List<MessageModel> myMessages = snapshot.docs
          .map((e) => MessageModel.fromJson(e.data()))
          .where(
            (msg) =>
                msg.senderEmail == currentEmail ||
                msg.receiverEmail == currentEmail,
          )
          .toList();
      Map<String, MessageModel> lastMessages = {};
      for (var msg in myMessages) {
        String charpartner = msg.senderEmail == currentEmail
            ? msg.receiverEmail
            : msg.senderEmail;
        if (!lastMessages.containsKey(charpartner) ||
            msg.dateTime.isAfter(lastMessages[charpartner]!.dateTime)) {
          lastMessages[charpartner] = msg;
        }
      }
      List<ChatModel> chatList = [];
      for (var entry in lastMessages.entries) {
        UserModel userModel = await getpartnerData(email: entry.key);
        chatList.add(
          ChatModel(
            user: userModel,
            lastMessage: entry.value.message,
            lastMessageTime: entry.value.dateTime,
          ),
        );
      }
      chatList.sort((x, y) => y.lastMessageTime.compareTo(x.lastMessageTime));
      yield chatList;
    }
  }
}
