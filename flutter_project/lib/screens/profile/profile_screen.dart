import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../models/user_profile.dart';
import '../../core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _districtCtrl;
  late TextEditingController _villageCtrl;
  late TextEditingController _landAreaCtrl;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppStateProvider>().userProfile;
    _nameCtrl = TextEditingController(text: profile.name);
    _phoneCtrl = TextEditingController(text: profile.phone);
    _stateCtrl = TextEditingController(text: profile.state);
    _districtCtrl = TextEditingController(text: profile.district);
    _villageCtrl = TextEditingController(text: profile.village);
    _landAreaCtrl = TextEditingController(text: profile.landArea.toString());
  }

  void _saveProfile() {
    final state = context.read<AppStateProvider>();
    final updated = UserProfile(
      id: state.userProfile.id,
      name: _nameCtrl.text,
      phone: _phoneCtrl.text,
      state: _stateCtrl.text,
      district: _districtCtrl.text,
      village: _villageCtrl.text,
      landArea: double.tryParse(_landAreaCtrl.text) ?? 5.0,
      landUnit: state.userProfile.landUnit,
      primaryCrops: state.userProfile.primaryCrops,
      preferredLanguage: state.currentLanguage,
    );
    state.updateProfile(updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('किसान प्रोफ़ाइल सफलतापूर्वक अपडेट हो गई!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isHindi = state.currentLanguage == 'hi';

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.person, size: 54, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.accent,
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              state.userProfile.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            Text(
              '${state.userProfile.district}, ${state.userProfile.state}',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            // Form Fields
            _field('किसान का नाम (Farmer Name)', _nameCtrl),
            _field('मोबाइल नंबर (Mobile Number)', _phoneCtrl),
            _field('राज्य (State)', _stateCtrl),
            _field('जिला (District)', _districtCtrl),
            _field('गाँव / क्षेत्र (Village)', _villageCtrl),
            _field('कुल कृषि भूमि (एकड़)', _landAreaCtrl),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              child: Text(isHindi ? 'प्रोफ़ाइल सहेजें' : 'Save Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
