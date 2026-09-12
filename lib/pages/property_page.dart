import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PropertyPage extends StatefulWidget {
  const PropertyPage({super.key});

  @override
  State<PropertyPage> createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  final ScrollController scrollController = ScrollController();
  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final squareMetersController = TextEditingController();
  final roomCountController = TextEditingController();
  final floorController = TextEditingController();
  final buildingFloorsController = TextEditingController();

  String selectedPropertyType = 'Apartment';
  String selectedHeatingType = 'Natural Gas';
  String selectedType = 'For Rent';

  String? selectedOwnerId;
  String? editingPropertyId;
  List<XFile> selectedImages = [];
  final ImagePicker imagePicker = ImagePicker();

  Future<void> pickImages() async {
    final List<XFile> images = await imagePicker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        selectedImages = images;
      });
    }
  }

  Future<List<String>> uploadImages() async {
    List<String> imageUrls = [];

    for (final image in selectedImages) {
      final file = File(image.path);

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageUrls.length}';

      final ref = FirebaseStorage.instance
          .ref()
          .child('property_images')
          .child('$fileName.jpg');

      await ref.putFile(file);

      final url = await ref.getDownloadURL();
      imageUrls.add(url);
    }

    return imageUrls;
  }

Future<void> addProperty() async {
  if (selectedOwnerId == null) return;

  final imageUrls = await uploadImages();

  await FirebaseFirestore.instance.collection('properties').add({
    'title': titleController.text.trim(),
    'address': addressController.text.trim(),
    'price': double.tryParse(priceController.text) ?? 0,
    'type': selectedType,
    'ownerId': selectedOwnerId,
    'propertyType': selectedPropertyType,
    'squareMeters': double.tryParse(squareMetersController.text) ?? 0,
    'roomCount': roomCountController.text.trim(),
    'floor': int.tryParse(floorController.text) ?? 0,
    'buildingFloors': int.tryParse(buildingFloorsController.text) ?? 0,
    'heatingType': selectedHeatingType,
    'imageUrls': imageUrls,
  });
  titleController.clear();
  addressController.clear();
  priceController.clear();
  squareMetersController.clear();
  roomCountController.clear();
  floorController.clear();
  buildingFloorsController.clear();

  setState(() {
    selectedPropertyType = 'Apartment';
    selectedHeatingType = 'Natural Gas';
  });
}
  Future<void> updateProperty() async {
    if (editingPropertyId == null || selectedOwnerId == null) return;
    List<String>? imageUrls;

    if (selectedImages.isNotEmpty) {
      final oldDocument = await FirebaseFirestore.instance
          .collection('properties')
          .doc(editingPropertyId)
          .get();

      final oldData = oldDocument.data();

      if (oldData != null) {
        final oldImageUrls =
        List<String>.from(oldData['imageUrls'] ?? []);

        for (final oldImageUrl in oldImageUrls) {
          try {
            await FirebaseStorage.instance
                .refFromURL(oldImageUrl)
                .delete();
          } catch (e) {
            debugPrint('Old image delete error: $e');
          }
        }
      }

      imageUrls = await uploadImages();
    }

    await FirebaseFirestore.instance
        .collection('properties')
        .doc(editingPropertyId)
        .update({
      'title': titleController.text.trim(),
      'address': addressController.text.trim(),
      'price': double.tryParse(priceController.text) ?? 0,
      'type': selectedType,
      'ownerId': selectedOwnerId,
      'propertyType': selectedPropertyType,
      'squareMeters': double.tryParse(squareMetersController.text) ?? 0,
      'roomCount': roomCountController.text.trim(),
      'floor': int.tryParse(floorController.text) ?? 0,
      'buildingFloors': int.tryParse(buildingFloorsController.text) ?? 0,
      'heatingType': selectedHeatingType,

      'imageUrls': ?imageUrls,
    });

    titleController.clear();
    addressController.clear();
    priceController.clear();
    squareMetersController.clear();
    roomCountController.clear();
    floorController.clear();
    buildingFloorsController.clear();

    setState(() {
      editingPropertyId = null;
      selectedImages = [];
      selectedPropertyType = 'Apartment';
      selectedHeatingType = 'Natural Gas';
    });
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
        body: SingleChildScrollView(
          controller: scrollController,
          primary: false,
          physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  const Text(
                    'Properties',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
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
                  if (value != null) {
                    setState(() {
                      selectedPropertyType = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 12),

              TextField(
                controller: squareMetersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Square Meters',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: roomCountController,
                decoration: const InputDecoration(
                  labelText: 'Room Count',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: floorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Floor',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: buildingFloorsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Building Floors',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: selectedHeatingType,
                decoration: const InputDecoration(
                  labelText: 'Heating Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Natural Gas',
                    child: Text('Natural Gas'),
                  ),
                  DropdownMenuItem(
                    value: 'Central Heating',
                    child: Text('Central Heating'),
                  ),
                  DropdownMenuItem(
                    value: 'Electric',
                    child: Text('Electric'),
                  ),
                  DropdownMenuItem(
                    value: 'None',
                    child: Text('None'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedHeatingType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
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
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),

            const SizedBox(height: 12),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('customers')
                  .where('customerType', isEqualTo: 'Owner')
                  .snapshots(),              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final customers = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  initialValue: selectedOwnerId,
                  decoration: const InputDecoration(
                    labelText: 'Owner',
                    border: OutlineInputBorder(),
                  ),
                  items: customers.map((customer) {
                    final data = customer.data() as Map<String, dynamic>;

                    return DropdownMenuItem<String>(
                      value: customer.id,
                      child: Text(data['name'] ?? 'Unknown'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOwnerId = value;
                    });
                  },
                );
              },
            ),
              const SizedBox(height: 20),

                  Center(
                    child: SizedBox(
                      width: 190,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: pickImages,
                        icon: const Icon(Icons.photo_library),
                        label: Text(
                          selectedImages.isEmpty
                              ? 'Select Photos'
                              : '${selectedImages.length} Photos Selected',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),

                  Center(
                    child: SizedBox(
                      width: 190,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: editingPropertyId == null ? addProperty : updateProperty,
                        child: Text(
                          editingPropertyId == null ? 'Add Property' : 'Update Property',
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 20),

              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('properties')
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

                    final properties = snapshot.data!.docs;

                    if (properties.isEmpty) {
                      return const Center(
                        child: Text('No properties yet'),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final property = properties[index];
                        final data = property.data() as Map<String, dynamic>;

                        return Card(
                          child: ListTile(
                            title: Text(data['title'] ?? ''),
                            subtitle: Text(
                              '${data['address'] ?? ''}\n'
                                  '${data['type'] ?? ''} • ${data['price'] ?? 0} TL',
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    titleController.text = data['title'] ?? '';
                                    addressController.text = data['address'] ?? '';
                                    priceController.text = data['price'].toString();

                                    squareMetersController.text =
                                        data['squareMeters']?.toString() ?? '';

                                    roomCountController.text =
                                        data['roomCount']?.toString() ?? '';

                                    floorController.text =
                                        data['floor']?.toString() ?? '';

                                    buildingFloorsController.text =
                                        data['buildingFloors']?.toString() ?? '';

                                    setState(() {
                                      selectedType = data['type'] ?? 'For Rent';
                                      selectedOwnerId = data['ownerId'];
                                      selectedPropertyType = data['propertyType'] ?? 'Apartment';
                                      selectedHeatingType = data['heatingType'] ?? 'Natural Gas';
                                      editingPropertyId = property.id;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final data = property.data() as Map<String, dynamic>;

                                    final imageUrls =
                                    List<String>.from(data['imageUrls'] ?? []);

                                    for (final imageUrl in imageUrls) {
                                      try {
                                        await FirebaseStorage.instance
                                            .refFromURL(imageUrl)
                                            .delete();
                                      } catch (e) {
                                        debugPrint('Image delete error: $e');
                                      }
                                    }

                                    await FirebaseFirestore.instance
                                        .collection('properties')
                                        .doc(property.id)
                                        .delete();
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
            ],
          ),
        ),
          ),
      );
  }
    }