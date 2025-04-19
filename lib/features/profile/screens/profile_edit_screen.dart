import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/user_model.dart';
import '../../../core/services/auth_provider.dart';
import '../../../core/utils/system_ui_helper.dart';
import '../widgets/index.dart';
import '../services/index.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update system UI overlay based on current theme
    SystemUIHelper.updateSystemUIOverlay(context);
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
    setState(() {
      _isLoading = true;
    });

    try {
      final imagePath = await ImagePickerService.pickImage(context);

      if (imagePath != null) {
        await ProfileService.updateAvatar(context, imagePath: imagePath);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ProfileService.updateProfile(
        context,
        name: _fullNameController.text,
        email: _emailController.text,
        onSuccess: () {
          if (mounted) {
            context.pop(); // Go back to profile page
          }
        },
      );
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
