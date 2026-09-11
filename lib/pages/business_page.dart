import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}
class _BusinessPageState extends State<BusinessPage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final authorizedPersonController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
Future<void> saveBusiness() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  await firestore.collection('businesses').doc(user.uid).set({
    'name': nameController.text.trim(),
    'address': addressController.text.trim(),
    'phone': phoneController.text.trim(),
    'authorizedPerson': authorizedPersonController.text.trim(),
    'userId': user.uid,
  });
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Business saved successfully'),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/fonev_logo.png',
          height: 50,
          fit: BoxFit.contain,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 70),
            const Text(
              'Business',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Business Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: authorizedPersonController,
              decoration: const InputDecoration(
                labelText: 'Authorized Person',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 170,
                height: 48,
                child: ElevatedButton(
                  onPressed: saveBusiness,
                  child: const Text('Save Business'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}