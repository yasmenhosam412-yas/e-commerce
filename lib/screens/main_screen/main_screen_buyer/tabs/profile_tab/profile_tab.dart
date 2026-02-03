import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
              ),
              SizedBox(height: 12),
              Text(
                "User Name",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "user@email.com",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _profileItem(
            icon: Icons.local_shipping_outlined,
            title: "Orders",
            onTap: () {},
          ),
          _profileItem(
            icon: Icons.data_array,
            title: "My Info",
            onTap: () {},
          ),
          _profileItem(
            icon: Icons.person_outline,
            title: "Account",
            onTap: () {},
          ),

          const Divider(height: 32),

          _profileItem(
            icon: Icons.logout,
            title: "Logout",
            color: Colors.red,
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String title,
    Color color = Colors.black,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
