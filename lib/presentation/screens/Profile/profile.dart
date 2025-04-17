import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Placeholder for user's profile picture
  String? _profilePictureUrl;
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';

  // Placeholder method for changing the profile picture
  Future<void> _changeProfilePicture() async {
    // Implement your logic to change the profile picture, e.g., from gallery or camera
    // For example, you can use an image picker package.
    setState(() {
      _profilePictureUrl =
          'https://example.com/new_profile_picture.jpg'; // New image URL
    });
  }

  // Placeholder method for saving the profile information
  Future<void> _saveProfile() async {
    // Save the updated information (e.g., to a backend or local storage)
    // For now, we can just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: GestureDetector(
                onTap: _changeProfilePicture,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profilePictureUrl != null
                      ? NetworkImage(_profilePictureUrl!)
                      : const AssetImage('assets/default_profile_picture.jpg')
                          as ImageProvider,
                  child: _profilePictureUrl == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Name Field
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Email Field
            TextFormField(
              initialValue: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            const SizedBox(height: 32),
            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
