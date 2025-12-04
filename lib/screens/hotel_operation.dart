// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ezee/data/room_data.dart';
import 'package:ezee/model/room_model.dart';
import 'package:ezee/screens/dashboard.dart';
import 'package:ezee/screens/login_signup_page.dart';
import 'dart:math';

import 'package:ezee/screens/ratings_page.dart';
import 'package:ezee/screens/walkIn_page.dart';

final random = Random();
final guestNames = [
  'Alice Guevarra', 'Bob Smith', 'Charlie Johnsons', 'Diana Lee', 'Ethan Martins', 'Fiona Arin',
  'George Bobier', 'Hannah Evans', 'Ivan Motalo', 'Jasmine Curtis', 'Kai Ory', 'Luna Ranas'
];

final pastelColors = [
  Color(0xFF8B7355),
  Color(0xFF6B9B8E),
  Color(0xFFA67C52),
  Color(0xFF7A9E7E),
  Color(0xFFB8956B),
  Color(0xFF6B8E7F),
];

final List<HotelModel> rooms = hotels;

class HotelOperation extends StatefulWidget {
  const HotelOperation({super.key});

  @override
  State<HotelOperation> createState() => _HotelOperationState();
}

class RoomBookingInfo {
  final Set<DateTime> dates;
  final int guestCount;

  RoomBookingInfo({required this.dates, required this.guestCount});
}

bool _showDummyBooking = true;

final DateTime today = DateTime.now();
final DateTime dummyCheckIn = DateTime.now();
final DateTime dummyCheckOut = dummyCheckIn.add(const Duration(days: 2));
const String dummyRoomId = '1';
const String dummyGuestName = 'Dummy Booker';

class Booking {
  final String name;
  final int guestCount;
  final String contactNumber;
  final String time;

  Booking({
    required this.name,
    required this.guestCount,
    required this.contactNumber,
    required this.time,
  });
}

final Map<String, Map<DateTime, Booking>> bookings = {
  'room1': {
    DateTime(2025, 5, 21): Booking(
      name: 'John Doe',
      guestCount: 2,
      contactNumber: '09171234567',
      time: '2:00 PM',
    ),
  },
  'room2': {
    DateTime(2025, 5, 22): Booking(
      name: 'Jane Smith',
      guestCount: 3,
      contactNumber: '09981234567',
      time: '4:30 PM',
    ),
  },
};

class _HotelOperationState extends State<HotelOperation> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  Map<String, RoomBookingInfo> roomBookedDates = {};
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadBookings();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dates = _generateMonthDates(_selectedMonth);
      final index = _getFirstBookedDateIndex(dates);
      if (index != null) {
        final targetOffset = index * 80.0;
        _horizontalScrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _loadBookings() async {
    final result = await loadAllBookedDates(rooms);
    setState(() {
      roomBookedDates = result;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dates = _generateMonthDates(_selectedMonth);
      final index = _getFirstBookedDateIndex(dates);
      if (index != null) {
        final targetOffset = index * 80.0;
        _horizontalScrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<Map<String, RoomBookingInfo>> loadAllBookedDates(List<HotelModel> hotels) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, RoomBookingInfo> bookedDatesMap = {};

    for (var hotel in hotels) {
      final bookingString = prefs.getString('booking_${hotel.id}');
      Set<DateTime> bookedDates = {};
      int guestCount = 0;

      if (bookingString != null) {
        final parts = RegExp(r"dates: \[(.*?)\], guests: (\d+)")
            .firstMatch(bookingString);

        if (parts != null) {
          final localDates = parts.group(1)!
              .split(', ')
              .map((str) => DateTime.tryParse(str))
              .whereType<DateTime>()
              .toSet();
          bookedDates = localDates;
          guestCount = int.tryParse(parts.group(2)!) ?? 0;
        }
      }

      bookedDatesMap[hotel.id] = RoomBookingInfo(dates: bookedDates, guestCount: guestCount);
    }

    return bookedDatesMap;
  }

  List<DateTime> _generateMonthDates(DateTime month) {
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return List.generate(
      lastDay.day,
      (index) => DateTime(month.year, month.month, index + 1),
    );
  }

  bool isDateBooked(String hotelId, DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);

    final DateTime dummyCheckIn = DateTime.now();
    final DateTime dummyCheckOut = dummyCheckIn.add(const Duration(days: 2));
    const String dummyRoomId = 'room2';

    if (_showDummyBooking &&
        hotelId == dummyRoomId &&
        (DateUtils.isSameDay(dateOnly, dummyCheckIn) ||
         (dateOnly.isAfter(dummyCheckIn) && dateOnly.isBefore(dummyCheckOut)))) {
      return true;
    }

    final info = roomBookedDates[hotelId];
    return info?.dates.any((d) => DateUtils.isSameDay(d, dateOnly)) ?? false;
  }

  int? _getFirstBookedDateIndex(List<DateTime> dates) {
    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      for (var hotel in hotels) {
        if (isDateBooked(hotel.id, date)) {
          return i;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateMonthDates(_selectedMonth);

    return Scaffold(
      backgroundColor: Color(0xFFF5F1E8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded, color: Color(0xFF2C2C2C)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFF5F1E8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE8E4DB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DateTime>(
              value: _selectedMonth,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6B9B8E)),
              dropdownColor: Colors.white,
              style: TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (newDate) {
                if (newDate != null) {
                  setState(() => _selectedMonth = newDate);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final dates = _generateMonthDates(newDate);
                    final index = _getFirstBookedDateIndex(dates);
                    if (index != null) {
                      final targetOffset = index * 80.0;
                      _horizontalScrollController.animateTo(
                        targetOffset,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                }
              },
              items: List.generate(12, (index) {
                final date = DateTime(_selectedMonth.year, index + 1);
                return DropdownMenuItem(
                  value: date,
                  child: Text(DateFormat('MMMM yyyy').format(date)),
                );
              }),
            ),
          ),
        ),
        centerTitle: true,
      ),
      drawer: _buildAppDrawer(context),
      body: _buildRoomGrid(dates),
    );
  }

  
  Widget _buildRoomGrid(List<DateTime> dates) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed room names column
                  _buildRoomNamesColumn(),
                  // Scrollable dates section
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _horizontalScrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateHeader(dates),
                          ..._buildRoomRows(dates),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoomNamesColumn() {
    return Column(
      children: [
        Container(
          height: 60,
          width: 120,
          decoration: BoxDecoration(
            color: Color(0xFFF5F1E8),
            border: Border(
              right: BorderSide(color: Color(0xFFE8E4DB)),
              bottom: BorderSide(color: Color(0xFFE8E4DB)),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            'Rooms',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF2C2C2C),
            ),
          ),
        ),
        ...rooms.map((room) {
          return Container(
            height: 75,
            width: 120,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Color(0xFFE8E4DB)),
                bottom: BorderSide(color: Color(0xFFE8E4DB), width: 0.5),
              ),
              color: Color(0xFFFAF8F5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF6B9B8E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bed_outlined, size: 16, color: Color(0xFF6B9B8E)),
                      SizedBox(width: 4),
                      Icon(Icons.person_outline, size: 14, color: Color(0xFF6B9B8E)),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  room.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDateHeader(List<DateTime> dates) {
    return Row(
      children: dates.map((date) {
        final isToday = DateUtils.isSameDay(date, DateTime.now());
        return Container(
          width: 85,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Color(0xFFE8E4DB), width: 0.5),
              bottom: BorderSide(color: Color(0xFFE8E4DB)),
            ),
            color: isToday ? Color(0xFF6B9B8E).withOpacity(0.1) : Color(0xFFF5F1E8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('d').format(date),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isToday ? Color(0xFF6B9B8E) : Color(0xFF2C2C2C),
                ),
              ),
              Text(
                DateFormat('E').format(date),
                style: TextStyle(
                  fontSize: 11,
                  color: isToday ? Color(0xFF6B9B8E) : Color(0xFF7A7A7A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildRoomRows(List<DateTime> dates) {
    return rooms.map((room) {
      List<Widget> cells = [];
      int dateIndex = 0;

      while (dateIndex < dates.length) {
        final date = dates[dateIndex];
        bool booked = isDateBooked(room.id, date);

        final String dummyRoomId = '1';
        final DateTime dummyCheckIn = DateTime.now();
        final DateTime dummyCheckOut = dummyCheckIn.add(const Duration(days: 2));
        const String dummyName = 'Dummy Booker';

        final isDummyBooking = !booked &&
            room.id == dummyRoomId &&
            (date.isAtSameMomentAs(dummyCheckIn) ||
             (date.isAfter(dummyCheckIn) && date.isBefore(dummyCheckOut)));

        if (booked || isDummyBooking) {
          int span = 1;
          DateTime startDate = date;

          while (
            dateIndex + span < dates.length &&
            (isDateBooked(room.id, dates[dateIndex + span]) ||
             (isDummyBooking &&
              room.id == dummyRoomId &&
              dates[dateIndex + span].isBefore(dummyCheckOut)))
          ) {
            span++;
          }

          final guestName = isDummyBooking ? dummyName : guestNames[random.nextInt(guestNames.length)];
          final guestColor = isDummyBooking
              ? Color(0xFF8B7355)
              : pastelColors[random.nextInt(pastelColors.length)];

          final guestCount = random.nextInt(3) + 1;
          final paymentStatuses = ['Paid', 'Partially Paid', 'Unpaid'];
          final paymentStatus = paymentStatuses[random.nextInt(paymentStatuses.length)];

          cells.add(_buildBookingCell(
            guestName: guestName,
            guestColor: guestColor,
            span: span,
            guestCount: guestCount,
            paymentStatus: paymentStatus,
          ));

          dateIndex += span;
        } else {
          cells.add(_buildAvailableCell());
          dateIndex += 1;
        }
      }

      return Row(children: cells);
    }).toList();
  }

// Add these methods to the _HotelOperationState class (Part 3)

  Widget _buildBookingCell({
    required String guestName,
    required Color guestColor,
    required int span,
    required int guestCount,
    required String paymentStatus,
  }) {
    return GestureDetector(
      onTap: () => _showBookingDialog(guestName, guestCount, paymentStatus),
      child: Container(
        width: 83.5 * span + (span > 1 ? 3 : 0),
        height: 73,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: guestColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: guestColor.withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: 10, color: guestColor),
                    SizedBox(width: 2),
                    Text(
                      '$guestCount',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: guestColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  guestName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableCell() {
    return Container(
      width: 83,
      height: 73,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Color(0xFF6B9B8E).withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xFF6B9B8E).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Color(0xFF6B9B8E),
              size: 20,
            ),
            SizedBox(height: 4),
            Text(
              'Available',
              style: TextStyle(
                color: Color(0xFF6B9B8E),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(String guestName, int guestCount, String paymentStatus) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF6B9B8E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.info_outline, color: Color(0xFF6B9B8E), size: 24),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Booking Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildInfoRow(Icons.person_outline, 'Guest', guestName),
              _buildInfoRow(Icons.location_on_outlined, 'Address', 'Dacanay Road, Bgy. San Manuel, PPC'),
              _buildInfoRow(Icons.phone_outlined, 'Phone', '09${random.nextInt(1000000000).toString().padLeft(9, '0')}'),
              _buildInfoRow(Icons.email_outlined, 'Email', 'sampleUser@gmail.com'),
              _buildInfoRow(Icons.login_outlined, 'Check-in', 'May 26, 2025'),
              _buildInfoRow(Icons.logout_outlined, 'Check-out', 'May 28, 2025'),
              _buildInfoRow(Icons.group_outlined, 'Guests', '3 Adults, 3 Children'),
              _buildInfoRow(Icons.nights_stay_outlined, 'Nights', '3'),
              _buildInfoRow(Icons.payments_outlined, 'Total', '₱20,100'),
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: _getPaymentColor(paymentStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _getPaymentColor(paymentStatus).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getPaymentIcon(paymentStatus),
                      color: _getPaymentColor(paymentStatus),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Payment: $paymentStatus',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _getPaymentColor(paymentStatus),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Color(0xFF6B9B8E)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _handleCheckout(guestName),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          color: Color(0xFF6B9B8E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6B9B8E),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFF5F1E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Color(0xFF7A7A7A)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2C2C2C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPaymentColor(String status) {
    switch (status) {
      case 'Paid':
        return Color(0xFF6B9B8E);
      case 'Partially Paid':
        return Color(0xFFB8956B);
      default:
        return Color(0xFFD9756C);
    }
  }

  IconData _getPaymentIcon(String status) {
    switch (status) {
      case 'Paid':
        return Icons.check_circle_outline;
      case 'Partially Paid':
        return Icons.schedule_outlined;
      default:
        return Icons.error_outline;
    }
  }

  void _handleCheckout(String guestName) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Confirm Checkout'),
        content: Text('Are you sure you want to check out $guestName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF7A7A7A))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6B9B8E),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                _showDummyBooking = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully checked out $guestName'),
                  backgroundColor: Color(0xFF6B9B8E),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Drawer _buildAppDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6B9B8E),
                  Color(0xFF8B7355),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'lib/assets/icons/ezee.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ezee Hotel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0),
                    Text(
                      'Hotel Operations',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildDrawerItem(
                  icon: Icons.directions_walk_outlined,
                  title: 'Walk-in Guests',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WalkinPage())),
                ),
                _buildDrawerItem(
                  icon: Icons.star_outline,
                  title: 'View Ratings',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RatingsScreen())),
                ),
                Divider(height: 32, indent: 16, endIndent: 16),
                _buildDrawerItem(
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  color: Color(0xFFD9756C),
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthPage())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ?? Color(0xFF2C2C2C);
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? Color(0xFF6B9B8E)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: itemColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: itemColor,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}