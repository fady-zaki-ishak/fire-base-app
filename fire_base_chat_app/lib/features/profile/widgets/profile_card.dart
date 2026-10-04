import 'package:chat_app_firebase/core/utils/style/screen_size.dart';
import 'package:flutter/material.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key, required this.vKey, required this.value});
  final String vKey;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenSize.height / 50),
      margin: EdgeInsets.all(ScreenSize.height / 50),
      width: ScreenSize.width,
      height: ScreenSize.height / 13,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Theme.of(context).primaryColor],
        ),
        borderRadius: BorderRadius.circular(ScreenSize.width / 20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(vKey, style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(
            width: ScreenSize.width / 2,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
