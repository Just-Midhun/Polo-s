import 'package:flutter/material.dart';

class Friend {
  final String name;
  final String imageUrl;
  final double rating;

  Friend({required this.name, required this.imageUrl, required this.rating});
}

class FriendsTabPage extends StatefulWidget{
  const FriendsTabPage({Key? key}): super(key: key);

  @override
  _FriendsTabPageState createState() => _FriendsTabPageState();
}
  final List<Friend> friends = [
    Friend(name: 'John', imageUrl: 'assets/images/john.jpg', rating: 4.5),
    Friend(name: 'Jane', imageUrl: 'assets/images/jane.jpg', rating: 4.2),
    Friend(name: 'Alex', imageUrl: 'assets/images/alex.jpg', rating: 4.7),
  ];

class _FriendsTabPageState extends State<FriendsTabPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          Friend friend = friends[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(friend.imageUrl),
            ),
            title: Text(friend.name),
            subtitle: Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                Text(friend.rating.toString()),
                const SizedBox(width: 8),
                const Icon(Icons.chat),
              ],
            ),
          );
        },
      ),
    );
  }
}