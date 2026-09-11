import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PropertyDetailPage extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyDetailPage({
    super.key,
    required this.property,
  });

  String value(String key) {
    final data = property[key];

    if (data == null || data.toString().isEmpty) {
      return '-';
    }

    return data.toString();
  }

  pw.Widget pdfRow(String title, String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$title:',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(text),
          ),
        ],
      ),
    );
  }

  Future<void> createAndSharePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Property Detail'),
          ),

          pw.SizedBox(height: 20),

          pdfRow('Title', value('title')),
          pdfRow('Address', value('address')),
          pdfRow('Listing Type', value('type')),
          pdfRow('Property Type', value('propertyType')),
          pdfRow('Price', '${value('price')} TL'),
          pdfRow('Square Meters', '${value('squareMeters')} m2'),
          pdfRow('Room Count', value('roomCount')),
          pdfRow('Floor', value('floor')),
          pdfRow('Building Floors', value('buildingFloors')),
          pdfRow('Heating Type', value('heatingType')),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'property_detail.pdf',
    );
  }

  Widget detailRow(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(text),
          ),
        ],
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                const Text(
                  'Property Details',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  value('title'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                if (property['imageUrls'] != null &&
                    (property['imageUrls'] as List).isNotEmpty) ...[
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: (property['imageUrls'] as List).length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final imageUrl =
                        (property['imageUrls'] as List)[index].toString();

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: 240,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 240,
                                height: 180,
                                alignment: Alignment.center,
                                child: const Icon(Icons.broken_image),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                detailRow('Address', value('address')),
                detailRow('Listing Type', value('type')),
                detailRow('Property Type', value('propertyType')),
                detailRow('Price', '${value('price')} TL'),
                detailRow(
                  'Square Meters',
                  '${value('squareMeters')} m²',
                ),
                detailRow('Room Count', value('roomCount')),
                detailRow('Floor', value('floor')),
                detailRow(
                  'Building Floors',
                  value('buildingFloors'),
                ),
                detailRow(
                  'Heating Type',
                  value('heatingType'),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: createAndSharePdf,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Export / Share PDF'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}