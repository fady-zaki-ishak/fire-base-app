import 'package:chat_app_firebase/core/utils/style/screen_size.dart';
import 'package:flutter/material.dart';

class SenderMessageWidget extends StatelessWidget {
  const SenderMessageWidget({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: ScreenSize.height / 50,
            bottom: ScreenSize.height / 50,
            right: ScreenSize.width / 20,
          ),
          padding: EdgeInsets.all(ScreenSize.width / 40),
          width: ScreenSize.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenSize.width / 20),
              bottomLeft: Radius.circular(ScreenSize.width / 20),
              bottomRight: Radius.circular(ScreenSize.width / 20),
            ),
            color: Theme.of(context).primaryColor,
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "Regular",
            ),
          ),
        ),
      ],
    );
  }
}
