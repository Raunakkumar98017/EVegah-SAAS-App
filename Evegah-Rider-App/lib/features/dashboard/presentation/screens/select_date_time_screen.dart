import 'package:flutter/material.dart';
import '../../../offers/presentation/screens/payment_offers_screen.dart';


class SelectDateTimeScreen extends StatefulWidget {
  const SelectDateTimeScreen({super.key});

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime _selectedDate = DateTime(2026, 6, 17);
  final DateTime _today = DateTime(2026, 6, 19);

  // Time selections
  String _selectedPickupTime = "05:00 PM";
  String _selectedDropoffTime = "08:00 AM";

  final List<String> _pickupTimes = [
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM",
    "08:00 PM",
    "09:00 PM",
  ];

  final List<String> _dropoffTimes = [
    "04:00 AM",
    "05:00 AM",
    "06:00 AM",
    "07:00 AM",
    "08:00 AM",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
  ];

  late FixedExtentScrollController _pickupController;
  late FixedExtentScrollController _dropoffController;

  @override
  void initState() {
    super.initState();
    _pickupController = FixedExtentScrollController(initialItem: _pickupTimes.indexOf(_selectedPickupTime));
    _dropoffController = FixedExtentScrollController(initialItem: _dropoffTimes.indexOf(_selectedDropoffTime));
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Select Pickup Date & Time",
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Choose when you want to start your ride",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. PICKUP LOCATION BOX ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF), // Light purple bg
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFDDD6FE).withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFF4313B8), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Pickup Location",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "48, Kempegowda Service Rd, Domlur I Stage, Bengaluru, Karnataka 560071",
                                  style: TextStyle(
                                    color: Color(0xFF1E293B),
                                    fontSize: 12,
                                    height: 1.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Change",
                              style: TextStyle(
                                color: Color(0xFF4313B8),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- 2. CALENDAR CONTAINER ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.01),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Select Date",
                                style: TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedDate = _today;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  "Clear",
                                  style: TextStyle(
                                    color: Color(0xFF4313B8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Weekdays Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              _WeekdayHeader("Mon"),
                              _WeekdayHeader("Tue"),
                              _WeekdayHeader("Wed"),
                              _WeekdayHeader("Thu"),
                              _WeekdayHeader("Fri"),
                              _WeekdayHeader("Sat"),
                              _WeekdayHeader("Sun"),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Month Name and Arrow
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "June 2026",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey, size: 24),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Days Grid for June 2026 (Starts on Monday!)
                          _buildCalendarDays(),
                          const SizedBox(height: 16),
                          // Legend Indicators
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4313B8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Selected Date",
                                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green, width: 1.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Today",
                                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              const Text(
                                "Weekend",
                                style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- 3. SELECT TIME PICKERS ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.01),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select Time",
                            style: TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              // Left: Pickup Time Picker
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF5F3FF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.access_time_filled, color: Color(0xFF4313B8), size: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                "Pickup Time",
                                                style: TextStyle(color: Color(0xFF1E293B), fontSize: 11, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "When you want to start",
                                                style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 150,
                                      child: _buildTimeWheel(_pickupTimes, _pickupController, (time) {
                                        setState(() {
                                          _selectedPickupTime = time;
                                        });
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              // Vertical Divider line
                              Container(
                                width: 1,
                                height: 180,
                                color: const Color(0xFFF1F5F9),
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              // Right: Dropoff Time Picker
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF5F3FF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.alarm, color: Color(0xFF4313B8), size: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                "Dropoff Time",
                                                style: TextStyle(color: Color(0xFF1E293B), fontSize: 11, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "When you will return",
                                                style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 150,
                                      child: _buildTimeWheel(_dropoffTimes, _dropoffController, (time) {
                                        setState(() {
                                          _selectedDropoffTime = time;
                                        });
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- 4. NOTE DISCLAIMER BOX ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline, color: Color(0xFF4313B8), size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Please ensure you have reached the pickup zone at least 10 minutes before the pickup time.",
                              style: TextStyle(
                                color: Color(0xFF4313B8),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // --- 5. CONTINUE GREEN BUTTON ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _completeBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F7643), // Forest Green
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeWheel(
    List<String> times,
    FixedExtentScrollController controller,
    ValueChanged<String> onSelected,
  ) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 38,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        onSelected(times[index]);
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: times.length,
        builder: (context, index) {
          final time = times[index];
          final isSelected = time == (controller == _pickupController ? _selectedPickupTime : _selectedDropoffTime);
          return Center(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: isSelected
                  ? const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFDDD6FE), width: 1),
                        bottom: BorderSide(color: Color(0xFFDDD6FE), width: 1),
                      ),
                    )
                  : null,
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF4313B8) : Colors.grey.shade400,
                  fontSize: isSelected ? 16 : 14,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarDays() {
    // We render June 2026 grid.
    // 30 days. Starts on Monday (June 1, 2026).
    // Mon (1, 8, 15, 22, 29)
    // Tue (2, 9, 16, 23, 30)
    // Wed (3, 10, 17, 24)
    // Thu (4, 11, 18, 25)
    // Fri (5, 12, 19, 26)
    // Sat (6, 13, 20, 27)
    // Sun (7, 14, 21, 28)

    final List<int> days = List.generate(30, (index) => index + 1);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final int day = days[index];
        final DateTime date = DateTime(2026, 6, day);

        final isToday = date.year == _today.year && date.month == _today.month && date.day == _today.day;
        final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
        
        final int weekday = date.weekday; // 1 = Mon, ..., 6 = Sat, 7 = Sun
        final isWeekend = weekday == 6 || weekday == 7;

        Color textColor = Colors.black87;
        if (isWeekend) textColor = Colors.red;
        if (isSelected) textColor = Colors.white;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4313B8) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isToday && !isSelected
                  ? Border.all(color: Colors.green, width: 1.5)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected || isToday ? FontWeight.w900 : FontWeight.w600,
                    color: textColor,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(height: 2),
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                ],
                if (isToday && !isSelected) ...[
                  const SizedBox(height: 2),
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _completeBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentOffersScreen()),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String label;
  const _WeekdayHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
