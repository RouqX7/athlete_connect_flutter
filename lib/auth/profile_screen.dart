import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileService = ProfileService();
  Profile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final profile = await _profileService.getCurrentProfile();
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: Text('Failed to load profile')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _profile!.user.image?.isNotEmpty == true
                  ? NetworkImage(_profile!.user.image!)
                  : null,
              child: _profile!.user.image?.isEmpty ?? true
                  ? Icon(Icons.person, size: 50)
                  : null,
            ),
            SizedBox(height: 16),
            Text(
              _profile!.user.authInfo.username ?? 'No username',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text('@${_profile!.user.authInfo.email}'),
            if (_profile!.user.bio?.isNotEmpty == true) ...[
              SizedBox(height: 16),
              Text(_profile!.user.bio!),
            ],
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(_profile!.user.authInfo.email),
            ),
            if (_profile!.user.authInfo.phone?.isNotEmpty == true)
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Phone'),
                subtitle: Text(_profile!.user.authInfo.phone!),
              ),
            if (_profile!.user.website?.isNotEmpty == true)
              ListTile(
                leading: Icon(Icons.link),
                title: Text('Website'),
                subtitle: Text(_profile!.user.website!),
              ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Account Status'),
              subtitle: Text(_profile!.accountStatus),
            ),
            ListTile(
              leading: Icon(Icons.palette),
              title: Text('Theme'),
              subtitle: Text(_profile!.preferences.theme),
            ),
          ],
        ),
      ),
    );
  }
} 