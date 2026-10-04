import 'package:chat_app_firebase/core/utils/style/screen_size.dart';
import 'package:flutter/material.dart';

class ReciverMessageWidget extends StatelessWidget {
  const ReciverMessageWidget({super.key, required this.message});
final String message ;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: ScreenSize.height / 50,
            bottom: ScreenSize.height / 50,
            left: ScreenSize.width / 20,
          ),
          padding: EdgeInsets.all(ScreenSize.width / 40),
          width: ScreenSize.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(ScreenSize.width / 20),
              bottomLeft: Radius.circular(ScreenSize.width / 20),
              bottomRight: Radius.circular(ScreenSize.width / 20),
            ),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
