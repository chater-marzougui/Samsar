import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsar/Widgets/widgets.dart';
import 'package:samsar/values/app_routes.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.tertiary,
          unselectedLabelColor: theme.cardColor,
          padding: EdgeInsets.only(top: 10),
          tabs: [
            Tab(text: 'Notifications', icon: Icon(Icons.notifications)),
            Tab(text: 'Messages', icon: Icon(Icons.message)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSystemNotifications(),
          _buildMessages(),
        ],
      ),
    );
  }

  Widget _buildSystemNotifications() {
    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('notifications')
          .where('userId', isEqualTo: _auth.currentUser?.uid)
          //.orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomLoadingScreen(message: "Loading notifications...");
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No notifications'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var notification = snapshot.data!.docs[index];
            return ListTile(
              leading: Icon(Icons.notifications),
              title: Text(notification['title']),
              subtitle: Text(notification['body']),
              trailing: Text(
                _formatTimestamp(notification['timestamp']),
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                // Handle notification tap (e.g., navigate to the new house listing)
                if (notification['type'] == 'new_house') {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.houseDetails,
                    arguments: notification['houseId'],
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('conversations')
          .where('participants', arrayContains: _auth.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomLoadingScreen(message: "Loading messages...");
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var conversation = snapshot.data!.docs[index];
            return FutureBuilder<DocumentSnapshot>(
              future: db.collection('users').doc(conversation['otherUserId']).get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return ListTile(title: Text('Loading...'));
                }
                var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData['profilePicture'] ?? ''),
                    child: userData['profilePicture'] == null ? Text(userData['firstName'][0]) : null,
                  ),
                  title: Text('${userData['firstName']} ${userData['lastName']}'),
                  subtitle: Text(conversation['lastMessage'] ?? 'No messages'),
                  trailing: Text(
                    _formatTimestamp(conversation['lastMessageTimestamp']),
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    // Navigate to chat screen
                    Navigator.pushNamed(
                      context,
                      AppRoutes.chatScreen,
                      arguments: {
                        'conversationId': conversation.id,
                        'otherUserId': conversation['otherUserId'],
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}