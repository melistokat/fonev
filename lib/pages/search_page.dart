import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'property_detail_page.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedType = 'Any';
  String selectedPropertyType = 'Any';

  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  final roomCountController = TextEditingController();
  final minSquareMetersController = TextEditingController();

  String? selectedCustomerId;
  String? selectedCustomerName;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyProvider>().loadProperties();
    });
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    roomCountController.dispose();
    minSquareMetersController.dispose();
    super.dispose();
  }

  bool matchesFilters(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? '';
    final price = (data['price'] as num?)?.toDouble() ?? 0;
    final propertyType = data['propertyType']?.toString() ?? '';
    final roomCount = data['roomCount']?.toString() ?? '';
    final squareMeters =
        (data['squareMeters'] as num?)?.toDouble() ?? 0;

    final minPrice =
    double.tryParse(minPriceController.text.trim());

    final maxPrice =
    double.tryParse(maxPriceController.text.trim());

    final minSquareMeters =
    double.tryParse(minSquareMetersController.text.trim());

    if (selectedType != 'Any' && type != selectedType) {
      return false;
    }

    if (selectedPropertyType != 'Any' &&
        propertyType != selectedPropertyType) {
      return false;
    }

    if (minPrice != null && price < minPrice) {
      return false;
    }

    if (maxPrice != null && price > maxPrice) {
      return false;
    }

    if (roomCountController.text.trim().isNotEmpty &&
        roomCount != roomCountController.text.trim()) {
      return false;
    }

    if (minSquareMeters != null &&
        squareMeters < minSquareMeters) {
      return false;
    }

    return true;
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
              'Search Properties',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('customers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LinearProgressIndicator();
                }

                final customers = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['customerType'] == 'Tenant';
                }).toList();

                return DropdownButtonFormField<String>(
                  initialValue: selectedCustomerId,
                  decoration: const InputDecoration(
                    labelText: 'Tenant Customer',                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Select Tenant'),
                  items: customers.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final firstName = data['firstName']?.toString() ?? '';
                    final lastName = data['lastName']?.toString() ?? '';
                    final name = '$firstName $lastName'.trim();

                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text(name.isEmpty ? 'Unnamed Customer' : name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    final customerDoc =
                    customers.firstWhere((doc) => doc.id == value);

                    final data =
                    customerDoc.data() as Map<String, dynamic>;

                    final firstName =
                        data['firstName']?.toString() ?? '';
                    final lastName =
                        data['lastName']?.toString() ?? '';

                    setState(() {
                      selectedCustomerId = value;
                      selectedCustomerName =
                          '$firstName $lastName'.trim();
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: const InputDecoration(
                labelText: 'Listing Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Any',
                  child: Text('Any'),
                ),
                DropdownMenuItem(
                  value: 'For Rent',
                  child: Text('For Rent'),
                ),
                DropdownMenuItem(
                  value: 'For Sale',
                  child: Text('For Sale'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedPropertyType,
              decoration: const InputDecoration(
                labelText: 'Property Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Any',
                  child: Text('Any'),
                ),
                DropdownMenuItem(
                  value: 'Apartment',
                  child: Text('Apartment'),
                ),
                DropdownMenuItem(
                  value: 'House',
                  child: Text('House'),
                ),
                DropdownMenuItem(
                  value: 'Office',
                  child: Text('Office'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPropertyType = value ?? 'Any';
                });
              },
            ),
            const SizedBox(height: 12),

            TextField(
              controller: minPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minimum Price',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: maxPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Maximum Price',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: roomCountController,
              decoration: const InputDecoration(
                labelText: 'Room Count',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: minSquareMetersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minimum Square Meters',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 50),

            const Text(
              'Results',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Consumer<PropertyProvider>(
                builder: (context, propertyProvider, child) {
                  if (propertyProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final filteredProperties =
                  propertyProvider.properties.where((property) {
                    return matchesFilters(property);
                  }).toList();

                  if (filteredProperties.isEmpty) {
                    return const Center(
                      child: Text('No matching properties found'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      final data = filteredProperties[index];

                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropertyDetailPage(
                                  property: data,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            data['title'] ?? 'Untitled Property',
                          ),
                          subtitle: Text(
                            '${data['address'] ?? ''}\n'
                                '${data['type'] ?? ''} • '
                                '${data['price'] ?? 0} TL\n'
                                '${data['roomCount'] ?? ''} rooms • '
                                '${data['squareMeters'] ?? 0} m²',
                          ),
                          isThreeLine: true,
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