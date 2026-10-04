import 'package:chat_app_firebase/features/Auth/data/user_model.dart';

class ChatModel {
  final UserModel user;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatModel({
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}
