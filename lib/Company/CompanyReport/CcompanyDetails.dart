// ignore_for_file: unused_label, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart'; // Import for date formatting

class CompanyDetails extends StatefulWidget {
  const CompanyDetails({super.key});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  late Map<String, dynamic> orderData;

  @override
  Widget build(BuildContext context) {
    orderData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            const Text(
              'Schedule',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 19),
            _buildScheduleCard(),
            const SizedBox(height: 19),
            _buildLineChart(), // Add the line chart widget
            const SizedBox(height: 19),
            const Text(
              'Assets',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 19),
            _buildAssetCard('Visual Identity.zip'),

            const SizedBox(height: 51),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 14,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(_getStatusIcon(orderData['status'])),
              const SizedBox(width: 5),
              Text(
                orderData['status'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_outlined),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 17,
                backgroundImage: NetworkImage(orderData['userPic']),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 1),
                  Text(
                    orderData['userName'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total amount spent',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    orderData['amount'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            orderData['selectedServices'],
            style: const TextStyle(
              color: Color(0xFF7A7A7A),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusIcon(String status) {
    switch (status) {
      case 'Completed':
        return 'assets/images/greenDot.png';
      case 'In Progress':
        return 'assets/images/yellowDot.png';
      case 'Cancelled':
        return 'assets/images/redDot.png';
      default:
        return 'assets/images/greenDot.png';
    }
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 14,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildScheduleColumn('Start time', '4/4/2024'),
          _buildScheduleColumn('Delivery time', '24/4/2024'),
          _buildScheduleColumn('Avg.', '20 days'),
        ],
      ),
    );
  }

  Widget _buildScheduleColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildAssetCard(String assetName) {
    String googleDriveUrl =
        'https://drive.google.com/uc?export=download&id=1HU36mX4IAqRGYMKKENytOgHNvIDy3Rom';

    return GestureDetector(
      onTap: () {
        _launchURL(googleDriveUrl); // Use the modified URL here
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 14,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          // Wrap the text and icon in a Row
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Align items with space
          children: [
            Text(
              assetName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 10), // Add some spacing between text and icon
            const Icon(Icons
                .download_rounded), // Add the download icon // Add some spacing between text and icon// Add the download icon
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    final startDateString =
        orderData['start time'] ?? '4/4/2024'; // Default value if null
    final endDateString = orderData['delivery time'] ??
        '24/4/2024'; // Get end date from orderData

    final dateFormat = DateFormat('dd/MM/yyyy'); // Format for parsing dates
    final startDate = dateFormat.parse(startDateString);
    final endDate = dateFormat.parse(endDateString);

    // Calculate total duration and elapsed duration
    final totalDays = endDate.difference(startDate).inDays;
    final today = DateTime.now();
    final elapsedDays = today.difference(startDate).inDays;

    // Percentage calculation
    final percentageComplete = (elapsedDays / totalDays * 100).toInt();

    // Data for the line chart with dates
    final data = [
      DateValue(startDate, 0),
      DateValue(today, percentageComplete),
      DateValue(endDate, 100),
    ];

    // Series with date values
    List<charts.Series<DateValue, DateTime>> series = [
      charts.Series<DateValue, DateTime>(
        id: 'Progress',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DateValue sales, _) => sales.date,
        measureFn: (DateValue sales, _) => sales.value,
        data: data,
      )
    ];

    // Line chart widget
    return Container(
      height: 200, // Adjust height as needed
      padding: const EdgeInsets.all(20.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 14,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: charts.TimeSeriesChart(
        series,
        animate: true,
        domainAxis: charts.DateTimeAxisSpec(
            renderSpec: charts.GridlineRendererSpec(

                // Tick and Label styling here.
                labelStyle: const charts.TextStyleSpec(
                    fontSize: 12, // size in Pts.
                    color: charts.MaterialPalette.black),
                lineStyle: charts.LineStyleSpec(
                    color: charts.MaterialPalette.gray.shadeDefault))),
        primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(

                // Tick and Label styling here.
                labelStyle: const charts.TextStyleSpec(
                    fontSize: 12, // size in Pts.
                    color: charts.MaterialPalette.black),

                // Change the line colors to match text color.
                lineStyle: charts.LineStyleSpec(
                    color: charts.MaterialPalette.gray.shadeDefault))),
      ),
    );
  }
}

class DateValue {
  final DateTime date;
  final int value;
  DateValue(this.date, this.value);
}

/// Sample data class for the line chart

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $uri');
  }
}
