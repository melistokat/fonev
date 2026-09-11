import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}
class _CustomerPageState extends State<CustomerPage> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  String selectedCustomerType = 'Owner';

  Future<void> addCustomer() async {
    await FirebaseFirestore.instance.collection('customers').add({
      'firstName': nameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'name': '${nameController.text.trim()} ${lastNameController.text.trim()}'.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'customerType': selectedCustomerType,
    });

    nameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();

    setState(() {
      selectedCustomerType = 'Owner';
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer added successfully'),
        ),
      );
    }
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            const Text(
              'Customers',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedCustomerType,
              decoration: const InputDecoration(
                labelText: 'Customer Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Owner',
                  child: Text('Owner'),
                ),
                DropdownMenuItem(
                  value: 'Tenant',
                  child: Text('Tenant'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCustomerType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            Center(
              child: SizedBox(
                width: 170,
                height: 48,
                child: ElevatedButton(
                  onPressed: addCustomer,
                  child: const Text('Add Customer'),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('customers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final customers = snapshot.data!.docs;

                  if (customers.isEmpty) {
                    return const Center(
                      child: Text('No customers yet'),
                    );
                  }

                  return ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];

                      return Card(
                        child: ListTile(
                          title: Text(customer['name']),
                          subtitle: Text(
                            '${customer['phone']} • ${customer['email']}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final editFirstNameController = TextEditingController(
                                    text: customer['firstName'] ?? customer['name'] ?? '',
                                  );
                                  final editLastNameController = TextEditingController(
                                    text: customer['lastName'] ?? '',
                                  );
                                  final editPhoneController = TextEditingController(
                                    text: customer['phone'],
                                  );
                                  final editEmailController = TextEditingController(
                                    text: customer['email'],
                                  );
                                  String editCustomerType = customer['customerType'] ?? 'Owner';

                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Edit Customer'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: editFirstNameController,
                                              decoration: const InputDecoration(
                                                labelText: 'First Name',
                                              ),
                                            ),
                                            TextField(
                                              controller: editLastNameController,
                                              decoration: const InputDecoration(
                                                labelText: 'Last Name',
                                              ),
                                            ),
                                            TextField(
                                              controller: editPhoneController,
                                              decoration: const InputDecoration(
                                                labelText: 'Phone',
                                              ),
                                            ),
                                            TextField(
                                              controller: editEmailController,
                                              decoration: const InputDecoration(
                                                labelText: 'Email',
                                              ),
                                            ),
                                            DropdownButtonFormField<String>(
                                              initialValue: editCustomerType,
                                              decoration: const InputDecoration(
                                                labelText: 'Customer Type',
                                              ),
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'Owner',
                                                  child: Text('Owner'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Tenant',
                                                  child: Text('Tenant'),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                if (value != null) {
                                                  editCustomerType = value;
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await customer.reference.update({
                                                'firstName': editFirstNameController.text.trim(),
                                                'lastName': editLastNameController.text.trim(),
                                                'name': '${editFirstNameController.text.trim()} ${editLastNameController.text.trim()}'.trim(),
                                                'phone': editPhoneController.text.trim(),
                                                'email': editEmailController.text.trim(),
                                                'customerType': editCustomerType,
                                              });

                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final linkedProperties = await FirebaseFirestore.instance
                                      .collection('properties')
                                      .where('ownerId', isEqualTo: customer.id)
                                      .get();

                                  if (linkedProperties.docs.isNotEmpty) {
                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'This customer cannot be deleted because they own a property.',
                                        ),
                                      ),
                                    );

                                    return;
                                  }

                                  await customer.reference.delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}