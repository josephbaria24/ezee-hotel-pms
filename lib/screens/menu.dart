// hotel_detail_page.dart

// ignore_for_file: prefer_const_constructors

import 'package:ezee/model/room_model.dart';
import 'package:ezee/screens/DatePreferencesPage.dart';
import 'package:ezee/screens/dashboard.dart';
import 'package:ezee/screens/full_screen_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class HotelDetailPage extends StatefulWidget {
  final HotelModel hotel;
  

  const HotelDetailPage({Key? key, required this.hotel}) : super(key: key);

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  int nightCount = 1;
  

  void _increaseNight() {
    setState(() {
      nightCount++;
    });
  }

  void _decreaseNight() {
    if (nightCount > 1) {
      setState(() {
        nightCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final totalPrice = widget.hotel.price * nightCount;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DatePreferencesPage(
                  hotel: widget.hotel,
                  nightCount: nightCount,
                ),
              ),
            );
          },
        label: Text('Next - ₱${NumberFormat('#,##0').format(totalPrice)}'),
        icon: Icon(Icons.arrow_forward),
        backgroundColor: const Color.fromARGB(255, 148, 132, 87),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImage(imageUrl: widget.hotel.imageUrl),
                    ),
                  );
                },
                child: Hero(
                  tag: widget.hotel.imageUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      widget.hotel.imageUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: topPadding + 10,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back_ios_new_outlined, size: 17),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Night counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nights: $nightCount',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _decreaseNight,
                            icon: Icon(Icons.remove_circle_outline),
                          ),
                          IconButton(
                            onPressed: _increaseNight,
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.hotel.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star_rate_rounded,
                                    color: Colors.amber, size: 17),
                                SizedBox(width: 5),
                                Text(
                                  '${widget.hotel.rating} (${widget.hotel.reviewCount} reviews)',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "lib/assets/icons/info.png",
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 8), // Add some spacing between the icon and text
                          Expanded(
                            child: Text(
                              widget.hotel.location,
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.hotel.amenities.map<Widget>((amenity) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: _buildAmenityCard(amenity.icon, amenity.label),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 16),
                  Text(
                    '₱${NumberFormat('#,##0', 'en_US').format(widget.hotel.price)}/night',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'This room offers great comfort and amenities. Perfect for travelers looking for convenience and style. Includes fast Wi-Fi, daily housekeeping, and more.',
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  SizedBox(height: 100), // Extra spacing so FAB doesn't cover
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildAmenityCard(IconData icon, String label) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 28,
          color: Colors.black,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}


}