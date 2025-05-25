import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eigth_app/widgets/messages_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticateUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      // chatDBの更新時をトリガー
      stream:
          FirebaseFirestore.instance
              .collection("chat")
              .orderBy("createdAt", descending: true)
              .snapshots(),
      builder: (ctx, chatSnapshots) {
        // ローディング中
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // データが空
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return Center(child: Text('No messages found'));
        }
        // エラー時
        if (chatSnapshots.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        // データがある場合
        final loadedMessages = chatSnapshots.data!.docs;
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessages = loadedMessages[index].data();
            final nextChatMessage =
                index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;

            final currentMessageUserId = chatMessages['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessages['text'],
                isMe: currentMessageUserId == authenticateUser.uid,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessages['userImage'],
                username: chatMessages['username'],
                message: chatMessages['text'],
                isMe: currentMessageUserId == authenticateUser.uid,
              );
            }
          },
        );
      },
    );
  }
}
