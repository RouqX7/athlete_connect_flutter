import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:athlete_connect_flutter/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();
  final _locationController = TextEditingController();
  final _twitterController = TextEditingController();
  final _linkedInController = TextEditingController();
  final _githubController = TextEditingController();
  final _facebookController = TextEditingController();
  final _languageController = TextEditingController();

  // State
  String? _theme = 'light';
  String? _accountStatus = 'active';
  bool _notifEmail = false;
  bool _notifSMS = false;
  bool _notifPush = false;
  bool _verified = false;
  XFile? _profileImage;
  bool _loading = true;
  Map<String, dynamic>? _profile;
  final List<String> _themeOptions = ['light', 'dark'];
  final List<String> _accountStatusOptions = ['active', 'inactive', 'suspended'];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    print('[ProfileScreen] Calling ProfileService.getCurrentProfile()');
    final profile = await ProfileService().getCurrentProfile();
    print('[ProfileScreen] Received profile: ' + (profile == null ? 'null' : profile.toString()));
    if (profile != null) {
      // Print the full profile as JSON for debugging
      try {
        print('[DEBUG] Profile as JSON: ' + jsonEncode(profile));
      } catch (e) {
        print('[DEBUG] Could not serialize profile to JSON: $e');
      }
      _usernameController.text = profile['user']?['authInfo']?['username'] ?? '';
      _emailController.text = profile['user']?['authInfo']?['email'] ?? '';
      _phoneController.text = profile['user']?['authInfo']?['phone'] ?? '';
      _bioController.text = profile['user']?['bio'] ?? '';
      _websiteController.text = profile['user']?['website'] ?? '';
      _locationController.text = profile['user']?['location']?.toString() ?? '';
      _twitterController.text = profile['user']?['socialLinks']?['twitter'] ?? '';
      _linkedInController.text = profile['user']?['socialLinks']?['linkedin'] ?? '';
      _githubController.text = profile['user']?['socialLinks']?['github'] ?? '';
      _facebookController.text = profile['user']?['socialLinks']?['facebook'] ?? '';
      _languageController.text = profile['user']?['socialLinks']?['language'] ?? '';
      _theme = profile['preferences']?['theme'] ?? 'light';
      _notifEmail = profile['preferences']?['notifications']?['email'] ?? false;
      _notifSMS = profile['preferences']?['notifications']?['sms'] ?? false;
      _notifPush = profile['preferences']?['notifications']?['push'] ?? false;
      _accountStatus = profile['accountStatus'] ?? 'inactive';
      _verified = profile['verified'] ?? false;
      // Set the profile image to null (local picker) by default
      _profileImage = null;
      // To display the remote image in your widget tree, use:
      //
      // CircleAvatar(
      //   radius: 48,
      //   backgroundImage: _profileImage != null
      //       ? FileImage(File(_profileImage!.path))
      //       : (profile['user']?['image'] != null && (profile['user']?['image'] as String).isNotEmpty)
      //           ? NetworkImage(profile['user']?['image']) as ImageProvider
      //           : AssetImage('assets/default_avatar.png'),
      // ),

    }
    setState(() => _loading = false);
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    final updates = {
      'username': _usernameController.text,
      'phone': _phoneController.text,
      'bio': _bioController.text,
      'website': _websiteController.text,
      'location': _locationController.text,
      'socialLinks': {
        'twitter': _twitterController.text,
        'linkedin': _linkedInController.text,
        'github': _githubController.text,
        'facebook': _facebookController.text,
        'language': _languageController.text,
      },
      'preferences': {
        'theme': _theme,
        'notifications': {
          'email': _notifEmail,
          'sms': _notifSMS,
          'push': _notifPush,
        },
      },
      'accountStatus': _accountStatus,
    };
    final success = await ProfileService().updateProfile(updates);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Profile updated!' : 'Failed to update profile')),
      );
      if (success) _loadProfile();
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool enabled = true, int maxLines = 1}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> options, ValueChanged<String?> onChanged) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    _twitterController.dispose();
    _linkedInController.dispose();
    _githubController.dispose();
    _facebookController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (_verified)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.verified, color: Colors.blueAccent),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
  radius: 48,
  backgroundImage: _profileImage != null
      ? FileImage(File(_profileImage!.path))
      : (_profile?['user']?['image'] != null && (_profile?['user']?['image'] as String).isNotEmpty)
          ? NetworkImage(_profile!['user']!['image']) as ImageProvider
          : const AssetImage('assets/default_avatar.png'),
),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickProfileImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(_usernameController, 'Username', Icons.person),
            const SizedBox(height: 12),
            _buildTextField(_emailController, 'Email', Icons.email, enabled: false),
            const SizedBox(height: 12),
            _buildTextField(_phoneController, 'Phone', Icons.phone),
            const SizedBox(height: 12),
            _buildTextField(_bioController, 'Bio', Icons.info, maxLines: 2),
            const SizedBox(height: 12),
            _buildTextField(_websiteController, 'Website', Icons.link),
            const SizedBox(height: 12),
            _buildTextField(_locationController, 'Location', Icons.location_on),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(_twitterController, 'Twitter', Icons.alternate_email)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_linkedInController, 'LinkedIn', Icons.business)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(_githubController, 'GitHub', Icons.code)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_facebookController, 'Facebook', Icons.facebook)),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(_languageController, 'Language', Icons.language),
            const SizedBox(height: 12),
            _buildDropdown('Theme', _theme, _themeOptions, (val) => setState(() => _theme = val)),
            const SizedBox(height: 12),
            _buildDropdown('Account Status', _accountStatus, _accountStatusOptions, (val) => setState(() => _accountStatus = val)),
            const SizedBox(height: 12),
            _buildSwitch('Email Notifications', _notifEmail, (val) => setState(() => _notifEmail = val)),
            _buildSwitch('SMS Notifications', _notifSMS, (val) => setState(() => _notifSMS = val)),
            _buildSwitch('Push Notifications', _notifPush, (val) => setState(() => _notifPush = val)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

