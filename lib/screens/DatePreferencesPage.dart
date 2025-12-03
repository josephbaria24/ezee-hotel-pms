// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ezee/model/room_model.dart';
import 'dart:convert';


class DatePreferencesPage extends StatefulWidget {
  final HotelModel hotel;
  final int nightCount;

  const DatePreferencesPage({
    super.key,
    required this.hotel,
    required this.nightCount,
  });

  @override
  State<DatePreferencesPage> createState() => _DatePreferencesPageState();
}


class _DatePreferencesPageState extends State<DatePreferencesPage> {


  @override
void initState() {
  super.initState();
  _loadBookedDates();
}

Future<void> _loadBookedDates() async {
  final prefs = await SharedPreferences.getInstance();
  final bookingString = prefs.getString('booking_${widget.hotel.id}');

  // Start with the booked dates from the hotel model
  Set<DateTime> initialDates = widget.hotel.bookedDates?.toSet() ?? {};

  if (bookingString != null) {
    final parts = RegExp(r"dates: \[(.*?)\], guests: (\d+)")
        .firstMatch(bookingString);

    if (parts != null) {
      final localDates = parts.group(1)!
          .split(', ')
          .map((str) => DateTime.parse(str))
          .toSet();

      final guests = int.parse(parts.group(2)!);

      setState(() {
        bookedDates = {...initialDates, ...localDates}; // Merge server + local
        guestCount = guests;
      });
      return;
    }
  }

  setState(() {
    bookedDates = initialDates;
  });
}

int adultCount = 1;
int childCount = 0;
// Future<void> _saveBookedDates() async {
//   final prefs = await SharedPreferences.getInstance();

//   final updatedHotel = HotelModel(
//     price: widget.hotel.price,
//     id: widget.hotel.id,
//     name: widget.hotel.name,
//     rating: widget.hotel.rating,
//     amenities: widget.hotel.amenities,
//     reviewCount: widget.hotel.reviewCount,
//     imageUrl: widget.hotel.imageUrl,
//     location: widget.hotel.location,
//     bookedDates: bookedDates.toList(),
//   );

//   // Load current list
//   final current = prefs.getStringList('booked_rooms') ?? [];

//   // Add this new booking
//   current.add(jsonEncode(updatedHotel.toJson()));

//   await prefs.setStringList('booked_rooms', current);
// }

final TextEditingController nameController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController additionalInfoController = TextEditingController();


Future<void> _saveBookedDates() async {
  final prefs = await SharedPreferences.getInstance();

  final List<String> dateStrings = bookedDates.map((date) => date.toIso8601String()).toList();

  // Format the data in a more predictable way
  final bookingString = '{dates: [${dateStrings.join(", ")}], guests: $guestCount, hotelName: ${widget.hotel.name}}';
  
  await prefs.setString('booking_${widget.hotel.id}', bookingString);
  
  // For debugging: show a message with what was saved
  print('Saved booking data: $bookingString');
}



  DateTime selectedDate = DateTime.now();
  String selectedTime = '10:00 AM';
  int guestCount = 1;

  final List<String> timeSlots = [
    '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM'
  ];
  Set<DateTime> bookedDates = {}; // 👈 Holds booked dates


  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.hotel.price * widget.nightCount;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
  final formattedDate = DateFormat('MMMM d, y').format(selectedDate);

String name = nameController.text;
    String address = addressController.text;
    String phoneNumber = phoneController.text;
    String email = emailController.text;
    String additionalInfo = additionalInfoController.text;

    String formattedCheckInDate = DateFormat.yMMMd().format(selectedDate);
    String formattedCheckOutDate = DateFormat.yMMMd().format(selectedDate.add(Duration(days: widget.nightCount)));


  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:MediaQuery.of(context).size.height * 0.8, 
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
            
                  Center(
                    child: Icon(Icons.check_circle, color: Colors.green, size: 48),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Confirm Booking',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
            
                  SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.account_circle, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Name: $name')),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Address: $address')),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Phone: $phoneNumber')),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.email, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Email: $email')),
              ],
            ),
            SizedBox(height: 4),
Row(
  children: [
    Icon(Icons.login, size: 20),
    SizedBox(width: 8),
    Expanded(
      child: Text('Check-in: $formattedCheckInDate (from 2:00 PM)'),
    ),
  ],
),
SizedBox(height: 4),
Row(
  children: [
    Icon(Icons.logout, size: 20),
    SizedBox(width: 8),
    Expanded(
      child: Text('Check-out: $formattedCheckOutDate (until 12:00 PM)'),
    ),
  ],
),

            SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.notes, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Additional Info: ${additionalInfo.isEmpty ? "None" : additionalInfo}')),
              ],
            ),
                  Row(
                    children: [
                      Icon(Icons.hotel, size: 20),
                      SizedBox(width: 8),
                      Expanded(child: Text('Hotel: ${widget.hotel.name}')),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20),
                      SizedBox(width: 8),
                      Text('Date: $formattedDate'),
                    ],
                  ),
                  SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.person, size: 20),
                      SizedBox(width: 8),
                      Text('Guests: $adultCount Adult${adultCount > 1 ? 's' : ''}, $childCount Child${childCount != 1 ? 'ren' : ''}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.nights_stay, size: 20),
                      SizedBox(width: 8),
                      Text('Nights: ${widget.nightCount}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 20),
                      SizedBox(width: 8),
                      Text('Total: ₱${NumberFormat('#,##0').format(widget.hotel.price * widget.nightCount)}'),
                    ],
                  ),
            
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            final List<DateTime> bookedRange = List.generate(
                              widget.nightCount,
                              (i) => selectedDate.add(Duration(days: i)),
                            );
            
                            // Check if any date in the range is already booked
                            bool isAlreadyBooked = bookedRange.any((date) =>
                              bookedDates.any((bookedDate) => isSameDay(bookedDate, date)),
                            );
            
                            if (isAlreadyBooked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected date range is already booked!'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
            
                            // Proceed with booking
                            setState(() {
                              bookedDates.addAll(bookedRange);
                            });
            
                            _saveBookedDates();
            
                            Navigator.pop(context); // ✅ Dismiss the confirmation dialog
            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Booking confirmed!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text('Confirm'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                        ),
            
                                        ],
                                      )
                                    ],
                                  ),
                                ),
          ),
        ),
                          );
                        },
                      );
                    },

        label: Text('Book Now - ₱${NumberFormat('#,##0').format(totalPrice)}'),
        icon: Icon(Icons.check),
        backgroundColor: const Color.fromARGB(255, 179, 143, 78),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Back Button
                Row(
                  children: [
                    GestureDetector(
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
                    SizedBox(width: 60,),

                    Text("Date & Preferences", style: 
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
                SizedBox(height: 20),

                Text('Nights: ${widget.nightCount}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),

                // 📅 Inline Calendar Picker
                Text('Select Date:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TableCalendar(
        focusedDay: selectedDate,
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(Duration(days: 365)),
        selectedDayPredicate: (day) => isSameDay(day, selectedDate),
        onDaySelected: (day, _) {
          setState(() {
            selectedDate = day;
          });
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final isBooked = bookedDates.any((d) => isSameDay(d, day));
            return Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isBooked ? Colors.red[300] : null,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: isBooked ? Colors.white : Colors.black,
                ),
              ),
            );
          },
        ),
      ),
    ),
                ),
                SizedBox(height: 8),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: timeSlots.map((time) {
                //       final isSelected = time == selectedTime;
                //       return GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             selectedTime = time;
                //           });
                //         },
                //         child: Container(
                //             margin: EdgeInsets.only(right: 10),
                //             padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                //             decoration: BoxDecoration(
                //               color: isSelected ? Colors.black : Colors.grey[200],
                //               borderRadius: BorderRadius.circular(12),
                //               border: Border.all(
                //                 color: isSelected ? Colors.transparent : Colors.grey, // Add grey border when not selected
                //                 width: 0.5,
                //               ),
                //             ),
                //             child: Text(
                //               time,
                //               style: TextStyle(
                //                 color: isSelected ? Colors.white : Colors.black,
                //               ),
                //             ),
                //           ),

                //       );
                //     }).toList(),
                //   ),
                // ),
                // SizedBox(height: 16),

                Text('Number of Guests:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
SizedBox(height: 8),
Row(
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Adults'),
          DropdownButton<int>(
            value: adultCount,
            onChanged: (value) {
              setState(() => adultCount = value!);
            },
            items: List.generate(10, (index) => index + 1)
              .map((val) => DropdownMenuItem(value: val, child: Text(val.toString())))
              .toList(),
          ),
        ],
      ),
    ),
    SizedBox(width: 16),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Children'),
          DropdownButton<int>(
            value: childCount,
            onChanged: (value) {
              setState(() => childCount = value!);
            },
            items: List.generate(10, (index) => index)
              .map((val) => DropdownMenuItem(value: val, child: Text(val.toString())))
              .toList(),
          ),
        ],
      ),
    ),
  ],
),




Text('Booking Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
SizedBox(height: 8),

TextField(
  controller: nameController,
  decoration: InputDecoration(
    labelText: 'Full Name',
    border: OutlineInputBorder(),
  ),
),
SizedBox(height: 12),

TextField(
  controller: addressController,
  decoration: InputDecoration(
    labelText: 'Address',
    border: OutlineInputBorder(),
  ),
),
SizedBox(height: 12),

TextField(
  controller: phoneController,
  keyboardType: TextInputType.phone,
  decoration: InputDecoration(
    labelText: 'Telephone Number',
    border: OutlineInputBorder(),
  ),
),
SizedBox(height: 12),

TextField(
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
  ),
),
SizedBox(height: 12),

Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            controller: TextEditingController(
              text: DateFormat.yMMMd().format(selectedDate),
            ),
            decoration: InputDecoration(
              labelText: 'Check-in Date',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: TextField(
            readOnly: true,
            controller: TextEditingController(
              text: DateFormat.yMMMd().format(
                selectedDate.add(Duration(days: widget.nightCount)),
              ),
            ),
            decoration: InputDecoration(
              labelText: 'Check-out Date',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    ),
    SizedBox(height: 8),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        'Check-in: 2:00 PM onwards\nCheck-out: 12:00 PM noon or earlier',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[700],
        ),
      ),
    ),
  ],
),

SizedBox(height: 12),

TextField(
  controller: additionalInfoController,
  maxLines: 3,
  decoration: InputDecoration(
    labelText: 'Additional Information',
    border: OutlineInputBorder(),
  ),
),

SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
