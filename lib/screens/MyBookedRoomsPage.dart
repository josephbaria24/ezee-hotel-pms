// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:ezee/data/room_data.dart';

class MyBookedRoomsPage extends StatefulWidget {
  const MyBookedRoomsPage({super.key});

  @override
  State<MyBookedRoomsPage> createState() => _MyBookedRoomsPageState();
}

class BookingInfo {
  final DateTime date;
  final String hotelName;
  final int guests;
  final String hotelId;

  BookingInfo({
    required this.date,
    required this.hotelName,
    required this.guests,
    required this.hotelId,
  });
}

class HotelBookingGroup {
  final String hotelName;
  final String hotelId;
  final int guests;
  final List<DateTime> checkInDates;
  bool isExpanded;

  HotelBookingGroup({
    required this.hotelName,
    required this.hotelId,
    required this.guests,
    required this.checkInDates,
    this.isExpanded = false,
  });
}

class _MyBookedRoomsPageState extends State<MyBookedRoomsPage> {
  List<HotelBookingGroup> hotelGroups = [];
  bool isLoading = true;

  // Theme colors
  static const Color beigeBackground = Color(0xFFF5F1ED);
  static const Color beigeCard = Color(0xFFFAF8F6);
  static const Color beigeAccent = Color(0xFFE8DFD6);
  static const Color darkText = Color(0xFF2C2317);
  static const Color mutedText = Color(0xFF6B6257);
  static const Color accentBrown = Color(0xFF8B7355);

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      
      List<BookingInfo> loadedBookings = [];
      
      for (String key in allKeys) {
        if (key.startsWith('booking_')) {
          final bookingString = prefs.getString(key);
          final hotelId = key.replaceFirst('booking_', '');
          
          if (bookingString != null) {
            try {
              final datesMatch = RegExp(r"dates:\s*\[(.*?)\]").firstMatch(bookingString);
              final hotelNameMatch = RegExp(r"hotelName:\s*(.*?)(?:,|}|\))").firstMatch(bookingString);
              final guestsMatch = RegExp(r"guests:\s*(\d+)").firstMatch(bookingString);
              
              if (datesMatch != null && hotelNameMatch != null && guestsMatch != null) {
                String datesPart = datesMatch.group(1) ?? "";
                String hotelName = hotelNameMatch.group(1) ?? "Unknown Hotel";
                String guestsStr = guestsMatch.group(1) ?? "1";
                
                hotelName = hotelName.trim();
                if (hotelName.startsWith('"') && hotelName.endsWith('"')) {
                  hotelName = hotelName.substring(1, hotelName.length - 1);
                }
                
                List<String> dateStrings = [];
                if (datesPart.contains(",")) {
                  dateStrings = datesPart.split(",");
                } else {
                  dateStrings = [datesPart];
                }
                
                for (String dateStr in dateStrings) {
                  try {
                    final date = DateTime.parse(dateStr.trim());
                    loadedBookings.add(BookingInfo(
                      date: date,
                      hotelName: hotelName,
                      guests: int.tryParse(guestsStr) ?? 1,
                      hotelId: hotelId,
                    ));
                  } catch (e) {
                    print("Error parsing date: $dateStr - $e");
                  }
                }
              }
            } catch (e) {
              print("Error processing booking: $e");
            }
          }
        }
      }
      
      Map<String, HotelBookingGroup> groupedBookings = {};
      
      for (var booking in loadedBookings) {
        if (groupedBookings.containsKey(booking.hotelName)) {
          groupedBookings[booking.hotelName]!.checkInDates.add(booking.date);
        } else {
          groupedBookings[booking.hotelName] = HotelBookingGroup(
            hotelName: booking.hotelName,
            hotelId: booking.hotelId,
            guests: booking.guests,
            checkInDates: [booking.date],
          );
        }
      }
      
      List<HotelBookingGroup> groups = groupedBookings.values.toList();
      for (var group in groups) {
        group.checkInDates.sort();
      }
      
      groups.sort((a, b) {
        if (a.checkInDates.isEmpty) return 1;
        if (b.checkInDates.isEmpty) return -1;
        return a.checkInDates.first.compareTo(b.checkInDates.first);
      });
      
      setState(() {
        hotelGroups = groups;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading bookings: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beigeBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: darkText,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: beigeBackground,
        foregroundColor: darkText,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentBrown),
                strokeWidth: 2.5,
              ),
            )
          : hotelGroups.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadBookings,
                  color: accentBrown,
                  backgroundColor: beigeCard,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    physics: BouncingScrollPhysics(),
                    itemCount: hotelGroups.length,
                    itemBuilder: (context, index) => _buildBookingCard(hotelGroups[index]),
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('lib/assets/icons/empty.json', width: 180, height: 180),
          SizedBox(height: 24),
          Text(
            'No bookings yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: darkText,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your upcoming reservations will appear here',
            style: TextStyle(
              fontSize: 14,
              color: mutedText,
            ),
          ),
          SizedBox(height: 24),
          TextButton.icon(
            onPressed: _loadBookings,
            icon: Icon(Icons.refresh_rounded, size: 18),
            label: Text('Refresh'),
            style: TextButton.styleFrom(
              foregroundColor: accentBrown,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: beigeCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: beigeAccent, width: 1),
              ),
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
// Continued from Part 1...
  
  Widget _buildBookingCard(HotelBookingGroup group) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: beigeCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: beigeAccent, width: 1),
        boxShadow: [
          BoxShadow(
            color: darkText.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: beigeAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.hotel_rounded, color: accentBrown, size: 24),
          ),
          title: Text(
            group.hotelName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: darkText,
              letterSpacing: -0.3,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(Icons.event_note_rounded, size: 14, color: mutedText),
                SizedBox(width: 4),
                Text(
                  '${group.checkInDates.length} booking${group.checkInDates.length > 1 ? 's' : ''}',
                  style: TextStyle(color: mutedText, fontSize: 13),
                ),
                SizedBox(width: 12),
                Icon(Icons.people_outline_rounded, size: 14, color: mutedText),
                SizedBox(width: 4),
                Text(
                  '${group.guests} guest${group.guests > 1 ? 's' : ''}',
                  style: TextStyle(color: mutedText, fontSize: 13),
                ),
              ],
            ),
          ),
          trailing: AnimatedRotation(
            turns: group.isExpanded ? 0.5 : 0.0,
            duration: Duration(milliseconds: 200),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: beigeAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.keyboard_arrow_down_rounded, color: accentBrown, size: 20),
            ),
          ),
          initiallyExpanded: group.isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                for (var otherGroup in hotelGroups) {
                  if (otherGroup != group) otherGroup.isExpanded = false;
                }
              }
              group.isExpanded = expanded;
            });
          },
          children: [
            Container(
              decoration: BoxDecoration(
                color: beigeBackground.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  // Dates Section
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, size: 16, color: accentBrown),
                            SizedBox(width: 8),
                            Text(
                              'Check-in Dates',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: accentBrown,
                                letterSpacing: 0.5,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ...group.checkInDates.map((date) {
                          final formattedDate = DateFormat('EEEE, MMMM d, y').format(date);
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: beigeAccent.withOpacity(0.5), width: 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: accentBrown,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: darkText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  Divider(height: 1, thickness: 1, color: beigeAccent),

                  // Rating Section
                  _buildRatingSection(group),

                  Divider(height: 1, thickness: 1, color: beigeAccent),

                  // Actions
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.info_outline_rounded, size: 16),
                            label: Text('Details'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: accentBrown,
                              side: BorderSide(color: beigeAccent, width: 1.5),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showCancelDialog(group),
                            icon: Icon(Icons.close_rounded, size: 16),
                            label: Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Color(0xFFB85C5C),
                              side: BorderSide(color: Color(0xFFE8B4B4), width: 1.5),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(HotelBookingGroup group) {
    return StatefulBuilder(
      builder: (context, setInnerState) {
        double currentRating = 0;
        TextEditingController feedbackController = TextEditingController();

        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star_rounded, size: 16, color: accentBrown),
                  SizedBox(width: 8),
                  Text(
                    'Rate Your Stay',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: accentBrown,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: RatingBar.builder(
                  initialRating: currentRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 32,
                  itemPadding: EdgeInsets.symmetric(horizontal: 6),
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rounded,
                    color: Color(0xFFD4A574),
                  ),
                  onRatingUpdate: (rating) {
                    setInnerState(() => currentRating = rating);
                  },
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: feedbackController,
                maxLines: 3,
                style: TextStyle(fontSize: 14, color: darkText),
                decoration: InputDecoration(
                  labelText: 'Share your experience',
                  labelStyle: TextStyle(color: mutedText, fontSize: 13),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: beigeAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: beigeAccent, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentBrown, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: accentBrown,
                        content: Text('Thank you for your feedback!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentBrown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Submit Feedback',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCancelDialog(HotelBookingGroup group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: beigeCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Cancel Booking',
          style: TextStyle(fontWeight: FontWeight.w600, color: darkText),
        ),
        content: Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: TextStyle(color: mutedText, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Booking'),
            style: TextButton.styleFrom(foregroundColor: mutedText),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllBookings();
            },
            child: Text('Cancel Booking'),
            style: TextButton.styleFrom(foregroundColor: Color(0xFFB85C5C)),
          ),
        ],
      ),
    );
  }

  // Delete methods from original code
  Future<bool> _deleteBooking(String hotelId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove('booking_$hotelId');
    } catch (e) {
      return false;
    }
  }

  Future<void> _deleteAllBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookingKeys = prefs.getKeys().where((k) => k.startsWith('booking_')).toList();
      for (final key in bookingKeys) await prefs.remove(key);
      await _loadBookings();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking cancelled successfully'),
          backgroundColor: accentBrown,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}
