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
  Colors.pink.shade200,
  Colors.blue.shade200,
  Colors.green.shade200,
  Colors.orange.shade200,
  Colors.purple.shade200,
  Colors.teal.shade200,
  Colors.indigo.shade200,
  Colors.yellow.shade200
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
// Define a constant dummy booking range
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

// Replace this with your actual data source in a real app
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

  @override
  void initState() {
    super.initState();
    _loadBookings();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    final dates = _generateMonthDates(_selectedMonth);
    final index = _getFirstBookedDateIndex(dates);
    if (index != null) {
      // Assume each date cell is 80 pixels wide
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

  // Wait for UI to update after setState
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

  // Dummy booking: today to 2 days later for room with ID 'room2'
  final DateTime dummyCheckIn = DateTime.now();
  final DateTime dummyCheckOut = dummyCheckIn.add(const Duration(days: 2));
  const String dummyRoomId = 'room2';

  if (_showDummyBooking &&
      hotelId == dummyRoomId &&
      (DateUtils.isSameDay(dateOnly, dummyCheckIn) ||
       (dateOnly.isAfter(dummyCheckIn) && dateOnly.isBefore(dummyCheckOut)))) {
    return true;
  }

  // Actual booking logic
  final info = roomBookedDates[hotelId];
  return info?.dates.any((d) => DateUtils.isSameDay(d, dateOnly)) ?? false;
}


final ScrollController _horizontalScrollController = ScrollController();


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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: DropdownButtonHideUnderline(
          child: DropdownButton<DateTime>(
            value: _selectedMonth,
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
        leading: Builder(
  builder: (context) => IconButton(
    icon: const Icon(Icons.menu),
    onPressed: () => Scaffold.of(context).openDrawer(),
  ),
),

        centerTitle: true,
      ),
      drawer: _buildAppDrawer(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final verticalScrollController = ScrollController();

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: verticalScrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed room names column
                  Column(
                    children: [
                      Container(
                        height: 50,
                        width: 100,
                        color: Colors.white,
                      ),
                      ...rooms.map((room) {
                        return Container(
                          height: 70,
                          width: 100,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.blue.shade50,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.bed_outlined, size: 15),
                                  Icon(Icons.person, size: 14),
                                  SizedBox(width: 2),
                                  // Text(
                                  //   '${roomBookedDates[room.id]?.guestCount ?? 0}',
                                  //   style: TextStyle(fontSize: 11),
                                  // ),
                                ],
                              ),

                              
                              Text(room.name, style: TextStyle(
                                fontSize: 12
                              ),
                              overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  // Scrollable dates section
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _horizontalScrollController, // Add this line
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: dates.map((date) {
                              return Container(
                                width: 80,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  color: Colors.grey.shade100,
                                ),
                                child: Text(
                                  DateFormat('d\nE').format(date),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                          ),
                          ...rooms.map((room) {
  List<Widget> cells = [];
  int dateIndex = 0;

  while (dateIndex < dates.length) {
    final date = dates[dateIndex];
    bool booked = isDateBooked(room.id, date);

    // Dummy booking config
    final String dummyRoomId = '1';
    final DateTime dummyCheckIn = DateTime.now();
    final DateTime dummyCheckOut = dummyCheckIn.add(const Duration(days: 2));
    const String dummyName = 'Dummy Booker';

    final isDummyBooking = !booked &&
        room.id == dummyRoomId &&
        (date.isAtSameMomentAs(dummyCheckIn) ||
         (date.isAfter(dummyCheckIn) && date.isBefore(dummyCheckOut)));

    if (booked || isDummyBooking) {
      // Find the booking end range
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

      // Generate consistent guest name and info
      final guestName = isDummyBooking ? dummyName : guestNames[random.nextInt(guestNames.length)];
      final guestColor = isDummyBooking
          ? Colors.purple.withOpacity(0.7)
          : pastelColors[random.nextInt(pastelColors.length)];

      final guestCount = random.nextInt(3) + 1;
      final arrivalTime = TimeOfDay(hour: 12 + random.nextInt(6), minute: random.nextInt(60));
      final endOfStayTime = TimeOfDay(hour: (arrivalTime.hour + 3) % 24, minute: arrivalTime.minute);
      final paymentStatuses = ['Paid', 'Partially Paid', 'Unpaid'];
      final paymentStatus = paymentStatuses[random.nextInt(paymentStatuses.length)];

      cells.add(GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
  title: const Text(
    'Booking Info',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  ),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [const Icon(Icons.person, size: 20), const SizedBox(width: 8), Expanded(child: Text('Name: $guestName'))]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.location_pin, size: 20), const SizedBox(width: 8), Expanded(child: Text('Address: Dacanay Road, Bgy. San Manuel, PPC'))]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.phone, size: 20), const SizedBox(width: 8), Expanded(child: Text('Phone: 09${random.nextInt(1000000000).toString().padLeft(9, '0')}'))]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.email, size: 20), const SizedBox(width: 8), Expanded(child: Text('Address: sampleUser@gmail.com'))]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.login, size: 20), const SizedBox(width: 8), Expanded(child: Text('Check-in: May 26, 2025'))]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.logout, size: 20), const SizedBox(width: 8), Expanded(child: Text('Check-out: May 28, 2025'))]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.info, size: 20), const SizedBox(width: 8), Expanded(child: Text('Additional info: N/A'))]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.group, size: 20), const SizedBox(width: 8), Expanded(child: Text('Guests: 3 Adults, 3 Children'))]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.nights_stay, size: 20), const SizedBox(width: 8), Expanded(child: Text('Nights: 3'))]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.price_change_outlined, size: 20), const SizedBox(width: 8), Expanded(child: Text('Total: ₱20,100'))]),
      const SizedBox(height: 8),
      Row(children: [
        Icon(
          Icons.payment,
          size: 20,
          color: paymentStatus == 'Paid'
              ? Colors.green
              : paymentStatus == 'Partially Paid'
                  ? Colors.orange
                  : Colors.red,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text('Payment: $paymentStatus')),
      ]),
      const SizedBox(height: 8),
      Row(children: [const Icon(Icons.monetization_on, size: 20), const SizedBox(width: 8), Expanded(child: Text('Remaining balance: ₱10,100'))]),
    ],
  ),
  actions: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Checkout'),
                  content: Text('Are you sure you want to check out $guestName?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(), // Cancel
                      child: const Text('Cancel'),
                    ),
                    TextButton(
  onPressed: () {
  setState(() {
    _showDummyBooking = false; // hide dummy booking temporarily
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Successfully checked out $guestName'),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    ),
  );

  Navigator.of(context).pop(); // Close confirmation
  Navigator.of(context).pop(); // Close info
},

  child: const Text('Confirm'),
)

                  ],
                );
              },
            );
          },
          child: const Text('Checkout'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  ],
)


          );
        },
        child: Container(
          width: 78.0 * span + (span > 1 ? 5 : 0),

          height: 68, 
          margin: const EdgeInsets.all(1),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: guestColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            guestName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ));

      dateIndex += span; // skip spanned dates
    } else {
      cells.add(Container(
        width: 78,
        height: 68,
        margin: const EdgeInsets.all(1),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(216, 88, 206, 123),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Available',
          style: TextStyle( 
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ));

      dateIndex += 1;
    }
  }

  return Row(children: cells);
}).toList()


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


 Drawer _buildAppDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.white,
    child: Stack(
      children: [
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(20, 228, 82, 24),
            ),
          ),
        ),
        Positioned(
          top: -30,
          left: -30,
          child: Container(
            width: 210,
            height: 210,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(50, 228, 82, 24),
            ),
          ),
        ),
        Positioned(
          top: -90,
          left: -90,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(20, 228, 82, 24),
            ),
          ),
        ),

        // Foreground content
        ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header with profile info
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('lib/assets/icons/vcicon.png'),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ezee Hotel',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Hotel Operations',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.directions_walk_outlined),
              title: Text('Walk in guests', style: TextStyle(
                fontWeight: FontWeight.bold
              ), ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => WalkinPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('View Ratings', style: TextStyle(
                fontWeight: FontWeight.bold
              ), ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => RatingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout', style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const AuthPage()));
              },
            ),
          ],
        ),
      ],
    ),
  );
}

}
