import 'package:flutter/material.dart';
import 'package:lobay/features/inbox/widgets/no_chat_widget.dart';
import 'package:lobay/utilities/text_utils/text_style_utils.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
          child: Text(
            'Chats',
            style: TextUtils.getStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.08,
              fontWeight: FontWeight.bold,
              ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
          child: Text(
            'Lets connect with each other',
            style: TextUtils.getStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Expanded(
          child: Center(
            child: NoChatWidget(),
          ),
        ),
      ],
    );
  }
}
