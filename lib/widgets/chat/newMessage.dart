import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _isEnter = '';

  void _sendMessage() async {
    final user = await FirebaseAuth.instance.currentUser();
    final getUsername =
        await Firestore.instance.collection('users').document(user.uid).get();
    FocusScope.of(context).unfocus();
    Firestore.instance.collection('chat').add(
      {
        'text': _isEnter,
        'time': Timestamp.now(),
        'userId': user.uid,
        'username': getUsername['username'],
        'imageUrl': getUsername['imageUrl'],
      },
    );
    _isEnter = '';
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
        top: 10,
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _isEnter = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _isEnter.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
