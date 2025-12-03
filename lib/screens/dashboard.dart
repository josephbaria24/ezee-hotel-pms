// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ezee/model/facilities_model.dart';
import 'package:ezee/model/room_model.dart';
import 'package:ezee/screens/AboutUs.dart';
import 'package:ezee/screens/ContactUsPage.dart';
import 'package:ezee/screens/MyBookedRoomsPage.dart';
import 'package:ezee/screens/facilities_card.dart';
import 'package:ezee/screens/login_signup_page.dart';
import 'package:ezee/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ezee/data/room_data.dart';
import 'package:ezee/screens/promos_offer_page.dart';

class HotelDashboard extends ConsumerStatefulWidget {
  const HotelDashboard({Key? key}) : super(key: key);

  @override
  _HotelDashboardState createState() => _HotelDashboardState();
}

class _HotelDashboardState extends ConsumerState<HotelDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

bool _showMessageInput = false;
final TextEditingController _messageController = TextEditingController();
final selectedFilterProvider = StateProvider<String>((ref) => 'Accommodations');

ScrollController _scrollController = ScrollController();
bool _showStickySearch = false;
@override
void initState() {
  super.initState();
  _loadUserMessages();
  _scrollController.addListener(() {
  if (_scrollController.offset > 100 && !_showStickySearch) {
    setState(() {
      _showStickySearch = true;
    });
  } else if (_scrollController.offset <= 100 && _showStickySearch) {
    setState(() {
      _showStickySearch = false;
    });
  }
});

}



void _loadUserMessages() async {
  final prefs = await SharedPreferences.getInstance();
  final savedMessages = prefs.getStringList('userMessages') ?? [];
  setState(() {
    _userMessages = savedMessages;
  });
}

void _deleteUserMessages() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userMessages');
  setState(() {
    _userMessages.clear();
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Your messages have been deleted.'),
      duration: Duration(seconds: 2),
    ),
  );
}
void _sendMessage() async {
  final message = _messageController.text.trim();
  if (message.isNotEmpty) {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userMessages.add(message);
      _messageController.clear();
    });
    prefs.setStringList('userMessages', _userMessages);

    // Optional: scroll to bottom after a short delay
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController2.animateTo(
        _scrollController2.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}

List<String> _userMessages = [];
final ScrollController _scrollController2 = ScrollController();


final List<String> amenities = [
  'Parking',
  'Mobile keys',
  'Free wifi',
  'Room service',
  '24hrs Guest Reception',
  'Complimentary toilestries',
  'Breakfast',
  'Mini Bar',
  'Transportation information/Transportation Arrangements',
  'Hotel Bar',
  'Laundry services',
  'Spa & Wellness Amenities',
  'Exercise Facilities',
  'Pet Friendly Rooms',
  'Smart Televisions',
  'Dinning experience',
];

final Map<String, IconData> amenityIcons = {
  'Parking': Icons.local_parking,
  'Mobile keys': Icons.vpn_key,
  'Free wifi': Icons.wifi,
  'Room service': Icons.room_service,
  '24hrs Guest Reception': Icons.room,
  'Complimentary toilestries': Icons.soap,
  'Breakfast': Icons.free_breakfast,
  'Mini Bar': Icons.local_drink,
  'Transportation information/Transportation Arrangements': Icons.directions_bus,
  'Hotel Bar': Icons.wine_bar,
  'Laundry services': Icons.local_laundry_service,
  'Spa & Wellness Amenities': Icons.spa,
  'Exercise Facilities': Icons.fitness_center,
  'Pet Friendly Rooms': Icons.pets,
  'Smart Televisions': Icons.tv,
  'Dinning experience': Icons.restaurant,
};




@override
Widget build(BuildContext context) {
  final selectedFilter = ref.watch(selectedFilterProvider);

  return Scaffold(
    key: _scaffoldKey,
    drawer: AppDrawer(
      isDarkMode: false,
      onToggleDarkMode: () {},
    ),
    backgroundColor: Colors.white,
    floatingActionButton: FloatingActionButton(
      foregroundColor: Colors.white,
      onPressed: () {
        setState(() {
          _showMessageInput = !_showMessageInput;
        });
      },
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: SvgPicture.asset('lib/assets/icons/message2.svg', color: const Color.fromARGB(255, 214, 96, 0),),
    ),
    body: Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              scrolledUnderElevation: 0,
              expandedHeight: 250,
              pinned: true,
              backgroundColor: const Color.fromARGB(252, 255, 255, 255),
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Stack(
  alignment: Alignment.center,
  children: [
    Row(
      children: [
        Row(
          children: [
            
            Image.asset(_showStickySearch ? 'lib/assets/images/ezee.png' : 'lib/assets/images/ezee.png', width: 40,),
            Text(
              "  ",
              style: TextStyle(
                color: _showStickySearch ? const Color.fromARGB(255, 248, 0, 74) : Colors.transparent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    ),
    Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(176, 221, 220, 220),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           
        
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  ],
),

actions: [
  IconButton(
    icon: Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(176, 221, 220, 220),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SvgPicture.asset(
              'lib/assets/icons/filter.svg',
              width: 20,
              height: 20,
              color: _showStickySearch
                  ? Colors.black
                  : const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
    ),
    onPressed: () {
      _scaffoldKey.currentState?.openDrawer();
    },
  ),
],

              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset("lib/assets/images/Ezee1.png", fit: BoxFit.fitHeight),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                            Colors.white.withOpacity(0.5),
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            SvgPicture.asset('lib/assets/icons/searchicon.svg', width: 20,),
                 
                            SizedBox(width: 10),
                            Expanded(
                            child: TextField(
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Search rooms and facilities',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                isCollapsed: true, // Removes default vertical padding
                                contentPadding: EdgeInsets.zero, // Makes it vertically centered
                              ),
                            ),
                          ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // if (_showStickySearch)
            //   SliverPersistentHeader(
            //     pinned: true,
            //     delegate: _SearchBarDelegate(),
            //   ),

            // Filter Chips
         SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    child: SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final filters = ['Accommodations', 'Facilities', 'Amenities'];
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          
          return FilterChip(
            label: Text(filter),
            labelStyle: TextStyle(
              color: isSelected ? const Color(0xFF1C1917) : const Color(0xFF78716C),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
              letterSpacing: -0.1,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            selected: isSelected,
            onSelected: (_) => ref.read(selectedFilterProvider.notifier).state = filter,
            selectedColor: const Color(0xFFFAF8F5),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? const Color(0xFFE7E5E4) : const Color(0xFFF5F5F4),
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    ),
  ),
),

            // Content based on selected filter
// Replace the Accommodations section with this redesigned layout
// Replace the Accommodations section with this redesigned layout
// Replace the Accommodations section with this redesigned layout
// Replace the Accommodations section with this redesigned layout
if (selectedFilter == 'Accommodations') ...[
  // Common Rooms Section
  SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF8F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              'lib/assets/icons/bed.svg',
              width: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "Common Rooms",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1917),
              letterSpacing: -0.4,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              // View all functionality
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF78716C),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: const Row(
             
            ),
          ),
        ],
      ),
    ),
  ),
  
  // Common Rooms Grid/List
  SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    sliver: SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: MediaQuery.of(context).size.width > 600 ? 0.57 : 0.58,
        mainAxisExtent: MediaQuery.of(context).size.width > 600 ? 200 : 260,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= hotels.length || index >= 4) return null;
          return HotelCard(hotel: hotels[index]);
        },
        childCount: hotels.length >= 4 ? 4 : hotels.length,
      ),
    ),
  ),

  // Cameron Rooms Section
  if (hotels.length >= 6) ...[
    SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF8F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                'lib/assets/icons/nature.svg',
                width: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Cameron",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1917),
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
      ),
    ),
    
    // Cameron Rooms Horizontal List
    SliverToBoxAdapter(
      child: SizedBox(
        height: 260,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: hotels.length >= 6 ? 2 : 0,
          itemBuilder: (context, index) {
            final hotel = hotels[index + 4];
            return Container(
              width: 280,
              margin: const EdgeInsets.only(right: 12),
              child: HotelCard(hotel: hotel),
            );
          },
        ),
      ),
    ),
  ],

  // Luxury Room Section
  if (hotels.length >= 7) ...[
    SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFAF8F5),
                    const Color(0xFFEBE4D6),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'lib/assets/icons/shine.svg',
                width: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Luxury Room",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1917),
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
      ),
    ),
    
    // Featured Luxury Room (Full Width)
    SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFAF8F5),
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE7E5E4),
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: HotelCard(hotel: hotels[6]),
        ),
      ),
    ),
  ],
]        
            else if (selectedFilter == 'Facilities')
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final facility = facilities[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FacilityCard(facility: facility),
                    );
                  },
                  childCount: facilities.length,
                ),
              )
            else if (selectedFilter == 'Amenities')
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: amenities.map((amenity) {
                      final icon = amenityIcons[amenity] ?? Icons.star;
                      return Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, size: 26, color: Colors.black87),
                            const SizedBox(height: 8),
                            Text(
                              amenity,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Center(child: Text('No data available')),
              ),

            SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),

 // Dummy floating chatbox at the bottom
AnimatedPositioned(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  bottom: _showMessageInput ? 80 : -400,
  left: 20,
  right: 20,
  child: AnimatedOpacity(
    duration: const Duration(milliseconds: 300),
    opacity: _showMessageInput ? 1.0 : 0.0,
    child: IgnorePointer(
      ignoring: !_showMessageInput,
      child: Container(
        height: 350,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with recipient name
            Row(
  children: [
    const CircleAvatar(
      radius: 16,
      backgroundColor: Colors.black,
      child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 16),
    ),
    const SizedBox(width: 10),
    const Text(
      "Ezee Admin",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
    Spacer(),
    PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          _deleteUserMessages();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete My Messages'),
        ),
      ],
    ),
    IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        setState(() {
          _showMessageInput = false;
        });
      },
    ),
  ],
),


            const SizedBox(height: 8),

                // Chat messages (dummy messages for now)
                Expanded(
      child: ListView(
        controller: _scrollController2,
        children: [
          _chatBubble("Hello! 👋", isAdmin: true),
          _chatBubble("I'm the Ezee Hotel Admin. How can I help you today?", isAdmin: true),
          _chatBubble("Feel free to ask any questions.", isAdmin: true),
          ..._userMessages.map((msg) => _chatBubble(msg, isAdmin: false)),
        ],
      ),
    ),


            // Message input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: 5,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: () {
                      _sendMessage();
                     
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),



      ],
    ),
  );
}
                }
Widget _chatBubble(String message, {bool isAdmin = false}) {
  return Align(
    alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isAdmin ? Colors.grey[200] : Colors.blue[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.black87),
      ),
    ),
  );
}


/// 🔧 Sticky Search Bar Delegate
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.black),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search hotels, houses, meeting rooms',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
    
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  
}


// Replace the HotelCard widget with this redesigned version
// Replace the HotelCard widget with this redesigned version
class HotelCard extends StatelessWidget {
  final HotelModel hotel;

  const HotelCard({Key? key, required this.hotel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HotelDetailPage(hotel: hotel),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF5F5F4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    hotel.imageUrl,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                ),
                // Rating badge
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${hotel.rating}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' (${hotel.reviewCount})',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room name
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1917),
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Color(0xFF78716C),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          hotel.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF78716C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // Price
                  Row(
                    children: [
                      Text(
                        '₱${NumberFormat('#,##0', 'en_US').format(hotel.price)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1917),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Text(
                        '/night',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF78716C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


















// App Drawer Widget
class AppDrawer extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;
  
  const AppDrawer({
    Key? key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  }) : super(key: key);


@override
Widget build(BuildContext context) {
  return Drawer(
    backgroundColor: const Color(0xFFFAF8F5), // Warm beige background
    child: Column(
      children: [
        // Modern Header with subtle elevation
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF5F1E8), // Light beige
                const Color(0xFFEBE4D6), // Deeper beige
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with subtle shadow
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('lib/assets/images/ezee.png'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // User name
              const Text(
                'John Doe',
                style: TextStyle(
                  color: Color(0xFF2C2416), // Dark brown
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              // Email
              Text(
                'ezeehotel@gmail.com',
                style: TextStyle(
                  color: const Color(0xFF6B5D47), // Muted brown
                  fontSize: 14,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),

        // Menu Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _buildMenuItem(
                context,
                icon: "lib/assets/icons/bedd.svg",
                title: 'My Booked Rooms',
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 1), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyBookedRoomsPage()),
                    );
                  });
                },
              ),
              _buildMenuItem(
                context,
                icon: "lib/assets/icons/promo.svg",
                title: 'Promos and Offers',
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 1), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PromosAndOffersScreen()),
                    );
                  });
                },
              ),
              _buildMenuItem(
                context,
                icon: "lib/assets/icons/rate.svg",
                title: 'Rate Our Service',
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 1), () {
                    showDialog(
                      context: context,
                      builder: (context) => RateServiceDialog(),
                    );
                  });
                },
              ),
              _buildMenuItem(
                context,
                icon: "lib/assets/icons/phone.svg",
                title: 'Contact Us',
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 1), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Contactuspage()),
                    );
                  });
                },
              ),
              _buildMenuItem(
                context,
                icon: "lib/assets/icons/about.svg",
                title: 'About Us',
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 1), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUsPage()),
                    );
                  });
                },
              ),
              
              // Divider before sign out
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Divider(
                  color: const Color(0xFFD4C8B3).withOpacity(0.5),
                  thickness: 1,
                ),
              ),
              
              _buildMenuItem(
                context,
                icon: "lib/assets/icons/logout.svg",
                title: 'Sign Out',
                isDestructive: true,
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 1), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  });
                },
              ),
            ],
          ),
        ),

        // Copyright footer
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: const Color(0xFFD4C8B3).withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Text(
            '© ${DateTime.now().year} Ezee Hotel. All rights reserved',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF9B8B73),
              letterSpacing: 0.3,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}

// Helper method to build consistent menu items
Widget _buildMenuItem(
  BuildContext context, {
  required String icon,
  required String title,
  required VoidCallback onTap,
  bool isDestructive = false,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: isDestructive 
            ? const Color(0xFFE94E3E).withOpacity(0.1)
            : const Color(0xFFD4C8B3).withOpacity(0.2),
        highlightColor: isDestructive
            ? const Color(0xFFE94E3E).withOpacity(0.05)
            : const Color(0xFFD4C8B3).withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icon container with subtle background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? const Color(0xFFE94E3E).withOpacity(0.08)
                      : Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDestructive
                        ? const Color(0xFFE94E3E).withOpacity(0.2)
                        : const Color(0xFFD4C8B3).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      isDestructive 
                          ? const Color(0xFFE94E3E)
                          : const Color(0xFF6B5D47),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDestructive
                        ? const Color(0xFFE94E3E)
                        : const Color(0xFF2C2416),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              // Chevron icon
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDestructive
                    ? const Color(0xFFE94E3E).withOpacity(0.5)
                    : const Color(0xFF9B8B73),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
class RateServiceDialog extends StatefulWidget {
  @override
  _RateServiceDialogState createState() => _RateServiceDialogState();
}

class _RateServiceDialogState extends State<RateServiceDialog> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
Widget build(BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    content: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500), // Adjust width here
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rate Our Service',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Wrap(
                  spacing: 4, // Small spacing between stars
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                      child: Icon(
                        index < _rating ? Icons.star_rate_rounded : Icons.star_border_purple500_rounded,
                        color: Colors.amber,
                        size: 30,
                      ),
                    );
                  }),
                ),
              ),
            ),


            const SizedBox(height: 12),
            TextField(
            controller: _feedbackController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Suggestions / Recommendations (optional)",
              filled: true,
              fillColor: const Color(0xFFF5F5F5),

              // Default border
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),

              // Border when focused
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),

          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel', style: TextStyle(color: Colors.black),),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Thanks for your feedback!")),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Submit'),
      ),
    ],
  );
}

}

// Provider for filter selection
final selectedFilterProvider = StateProvider<String>((ref) => 'All');