import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/models/user_model.dart';
import '../../../core/services/auth_provider.dart';
import '../../../core/utils/lottie_animations.dart';
import '../../../core/widgets/success_dialog.dart';
import '../widgets/index.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Set status bar to light (dark icons) for light theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _firstNameController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    if (user != null) {
      _fullNameController.text = user.name;
      _firstNameController.text = 'Andrew'; // Demo data
      _dateOfBirthController.text = "12/27/1995"; // Demo data
      _genderController.text = "Male"; // Demo data
      _emailController.text = "andrew_ainsley@yourdomain.com"; // Demo data
      _phoneController.text = "+1 111 467 378 399"; // Demo data
      _countryController.text = "United States"; // Demo data
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      // Show a bottom sheet with options
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          );
        },
      );

      // User canceled the selection
      if (source == null) return;

      // Pick the image
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _isLoading = true;
        });

        // Upload the image
        final success = await Provider.of<AuthProvider>(
          context,
          listen: false,
        ).updateAvatar(image.path);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (success) {
            // Show success dialog with animation
            SuccessDialog.show(
              context,
              message: 'Profile picture updated successfully',
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update profile picture')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).updateProfile(_fullNameController.text, _emailController.text);

      if (success && mounted) {
        // Show success dialog with animation
        SuccessDialog.show(
          context,
          message: 'Profile updated successfully',
          onDismissed: () {
            context.pop(); // Go back to profile page
          },
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditableAvatar(user: user, onEdit: _pickImage),
                  const SizedBox(height: 24),

                  // Full name field
                  ProfileFormField(
                    controller: _fullNameController,
                    labelText: 'Andrew Ainsley',
                    background: true,
                  ),

                  // First name field
                  ProfileFormField(
                    controller: _firstNameController,
                    labelText: 'Andrew',
                    background: true,
                  ),

                  // Date of birth field
                  ProfileFormField(
                    controller: _dateOfBirthController,
                    labelText: '12/27/1995',
                    background: true,
                    suffix: const Icon(Icons.calendar_today, size: 20),
                  ),

                  // Gender field
                  ProfileFormField(
                    controller: _genderController,
                    labelText: 'Male',
                    background: true,
                    suffix: const Icon(Icons.arrow_drop_down, size: 24),
                  ),

                  // Email field
                  ProfileFormField(
                    controller: _emailController,
                    labelText: 'andrew_ainsley@yourdomain.com',
                    background: true,
                    inputType: TextInputType.emailAddress,
                    suffix: const Icon(Icons.email_outlined, size: 20),
                  ),

                  // Phone field with flag
                  ProfilePhoneField(
                    controller: _phoneController,
                    labelText: '+1 111 467 378 399',
                  ),

                  // Country field
                  ProfileFormField(
                    controller: _countryController,
                    labelText: 'United States',
                    background: true,
                    suffix: const Icon(Icons.arrow_drop_down, size: 24),
                  ),

                  const SizedBox(height: 24),
                  ProfileUpdateButton(
                    isLoading: _isLoading,
                    onPressed: _updateProfile,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
