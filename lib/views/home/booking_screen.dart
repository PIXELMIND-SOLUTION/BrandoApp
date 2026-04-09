import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isAC = true;
  String selectedPlan = 'Daily';
  int selectedShareIndex = 0;
  int selectedDateIndex = 0;

  final List<String> planOptions = ['Daily', 'Monthly', 'Weekly', 'Yearly'];

  final List<Map<String, String>> dateList = [
    {'day': 'Sun', 'date': '13'},
    {'day': 'Mon', 'date': '14'},
    {'day': 'Tue', 'date': '15'},
    {'day': 'Wed', 'date': '16'},
    {'day': 'Tue', 'date': '15'},
    {'day': 'Wed', 'date': '17'},
    {'day': 'Thu', 'date': '18'},
  ];

  final List<Map<String, String>> shareOptions = [
    {'label': '1 SHARE', 'price': '5,000/-'},
    {'label': '2 SHARE', 'price': '5,000/-'},
    {'label': '3 SHARE', 'price': '5,000/-'},
    {'label': '4 SHARE', 'price': '5,000/-'},
    {'label': '1 SHARE', 'price': '5,000/-'},
    {'label': '2 SHARE', 'price': '5,000/-'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: const BackButton(color: Colors.black),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'HIFI ',
                style: TextStyle(
                  color: Color(0xFFD32F2F),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'Hostels',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.asset(
                'assets/detailimage.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.image, size: 60, color: Colors.grey),
                  ),
                ),
              ),
            ),

            // Location Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Color(0xFFD32F2F), size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Kphb Hyderabad Kukatpally ...',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.keyboard_arrow_down, size: 18),
                    ],
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFFD32F2F),
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  //   child: const Text(
                  //     'AC',
                  //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  //   ),
                  // ),
                ],
              ),
            ),

            // Details Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Details',
                style: TextStyle(
                  color: Color(0xFFD32F2F),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Details Table
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Table(
                border: TableBorder.all(color: const Color(0xFFD32F2F), width: 1),
                children: [
                  TableRow(
                    children: [
                      _tableCell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Room No :', style: TextStyle(color: Colors.white, fontSize: 12)),
                            Text('101 1st floor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        isRed: true,
                      ),
                      _tableCell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Amount Paid :', style: TextStyle(color: Colors.black, fontSize: 12)),
                            Text('2,000/-', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        isRed: false,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      _tableCell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Proofs Submitted :', style: TextStyle(color: Color(0xFFD32F2F), fontSize: 12)),
                            Text('Aadhar Card, Pan Card', style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                        isRed: false,
                      ),
                      _tableCell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedPlan,
                              style: const TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            const Text(
                              '( 15/2/2026 – 18/2/2026 )',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ],
                        ),
                        isRed: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Upgrade Section with AC Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upgrade',
                    style: TextStyle(
                      color: Color(0xFFD32F2F),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  // AC / Non-AC Toggle
                  GestureDetector(
                    onTap: () => setState(() => isAC = !isAC),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 72,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isAC ? const Color(0xFFD32F2F) : Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Labels
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'AC',
                                style: TextStyle(
                                  color: isAC ? Colors.white : Colors.transparent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'AC',
                                style: TextStyle(
                                  color: !isAC ? Colors.white : Colors.transparent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Thumb
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 250),
                            alignment: isAC ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  'AC',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: isAC ? const Color(0xFFD32F2F) : Colors.grey,
                                  ),
                                ),
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

            const SizedBox(height: 12),

            // Plan Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPlan,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    items: planOptions.map((plan) {
                      return DropdownMenuItem(
                        value: plan,
                        child: Text(plan, style: const TextStyle(fontSize: 15)),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedPlan = val!),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Daily Prices for AC/Non-AC
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$selectedPlan Prices for ',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    TextSpan(
                      text: isAC ? 'Ac' : 'Non Ac',
                      style: const TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Share Options Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(shareOptions.length, (index) {
                  final isSelected = selectedShareIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedShareIndex = index),
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 24 - 32) / 3,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFD32F2F) : Colors.white,
                        border: Border.all(
                          color: isSelected ? const Color(0xFFD32F2F) : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Text(
                            shareOptions[index]['label']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            shareOptions[index]['price']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Select Date Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Select Date To Book a Hostel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            const SizedBox(height: 12),

            // Date Scroll
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: dateList.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedDateIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedDateIndex = index),
                    child: Container(
                      width: 55,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFD32F2F) : Colors.white,
                        border: Border.all(
                          color: isSelected ? const Color(0xFFD32F2F) : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dateList[index]['day']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            dateList[index]['date']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // Book Now Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Booking Successfull....')));
                  },
                  child: const Text(
                    'Book Now',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _tableCell({required Widget child, required bool isRed}) {
    return Container(
      color: isRed ? const Color(0xFFD32F2F) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: child,
    );
  }
}