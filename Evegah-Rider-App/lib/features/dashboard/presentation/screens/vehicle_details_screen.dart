import 'package:flutter/material.dart';
import '../../data/services/dashboard_service.dart';
import 'select_date_time_screen.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final String vehicleId; 

  const VehicleDetailsScreen({super.key, required this.vehicleId});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final DashboardService _dashboardService = DashboardService();

  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _vehicleData;
  int _sliderIndex = 0;
  String _rideType = "Daily"; // Daily or Subscription

  @override
  void initState() {
    super.initState();
    _fetchLiveVehicleDetails();
  }

  Future<void> _fetchLiveVehicleDetails() async {
    Map<String, dynamic>? data;
    try {
      data = await _dashboardService.fetchLiveVehicleDetails(widget.vehicleId);
    } catch (e) {
      debugPrint("Error fetching vehicle details: $e");
    }

    if (data == null) {
      final String cleanId = widget.vehicleId.toUpperCase();
      String modelName = 'EVegah E2';
      int battery = 85;
      int maxRange = 110;
      double todaysRate = 20.00;
      double rateAfter = 3.50;
      double lat = 28.6290;
      double lng = 77.2160;

      if (cleanId.contains('E1')) {
        modelName = 'EVegah E1';
        battery = 92;
        maxRange = 90;
        todaysRate = 18.00;
        rateAfter = 3.00;
        lat = 28.6322;
        lng = 77.2190;
      } else if (cleanId.contains('E3')) {
        modelName = 'EVegah E3';
        battery = 78;
        maxRange = 120;
        todaysRate = 22.00;
        rateAfter = 4.00;
        lat = 28.6335;
        lng = 77.2170;
      } else if (cleanId.contains('E4')) {
        modelName = 'EVegah E4';
        battery = 63;
        maxRange = 80;
        todaysRate = 15.00;
        rateAfter = 2.50;
        lat = 28.6280;
        lng = 77.2210;
      } else if (cleanId.contains('MINK')) {
        modelName = 'EVegah Mink';
        battery = 90;
        maxRange = 60;
        todaysRate = 29.00;
        rateAfter = 5.00;
        lat = 28.6304;
        lng = 77.2177;
      }

      data = {
        'vehicleId': widget.vehicleId,
        'modelName': modelName,
        'maxRangeOn100PercentageBatteryKM': maxRange.toString(),
        'latitude': lat,
        'longitude': lng,
        'lockDetails': [
          {
            'battery': battery.toString(),
            'latitude': lat.toString(),
            'longitude': lng.toString(),
          }
        ],
        'farePlanData': [
          {
            'todaysRate': todaysRate.toString(),
            'minimumHireMinuts': '30',
            'rateAfter': rateAfter.toString(),
          }
        ]
      };
    }

    if (mounted) {
      setState(() {
        _vehicleData = data;
        _errorMessage = null; // Prevent showing error screen
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFBFE),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator(color: Color(0xFF1E1452))),
      );
    }

    if (_errorMessage != null || _vehicleData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFBFE),
        appBar: AppBar(
          backgroundColor: Colors.transparent, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        ),
        body: Center(child: Text(_errorMessage ?? "Something went wrong.", style: const TextStyle(color: Colors.red, fontSize: 16))),
      );
    }

    final String model = _vehicleData!['modelName']?.toString() ?? "EVegah Scooter";
    final int range = int.tryParse(_vehicleData!['maxRangeOn100PercentageBatteryKM']?.toString() ?? '0') ?? 0;
    
    final String modelLower = model.toLowerCase();
    final List<String> vehicleImages = modelLower.contains("mink")
        ? ["assets/mink.png", "assets/v1.webp", "assets/v2.webp"]
        : modelLower.contains("e1")
            ? ["assets/mink.png", "assets/v1.webp", "assets/v2.webp"]
            : modelLower.contains("e2")
                ? ["assets/v1.webp", "assets/v2.webp", "assets/mink.png"]
                : ["assets/v2.webp", "assets/v1.webp", "assets/mink.png"];

    double todaysRate = 20.00;
    if (_vehicleData!['farePlanData'] != null && _vehicleData!['farePlanData'].isNotEmpty) {
       todaysRate = double.tryParse(_vehicleData!['farePlanData'][0]['todaysRate']?.toString() ?? '20') ?? 20.00;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context), 
        ),
        title: Text(model, style: const TextStyle(color: Color(0xFF1E1452), fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 100% INSURED BAR ---
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.verified_user, color: Color(0xFF4313B8), size: 16),
                        SizedBox(width: 6),
                        Text("100% Insured", style: TextStyle(color: Color(0xFF4313B8), fontWeight: FontWeight.bold, fontSize: 11)),
                        SizedBox(width: 8),
                        Text("•", style: TextStyle(color: Color(0xFF4313B8), fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Text("Hassle-free", style: TextStyle(color: Color(0xFF4313B8), fontWeight: FontWeight.bold, fontSize: 11)),
                        SizedBox(width: 8),
                        Text("•", style: TextStyle(color: Color(0xFF4313B8), fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Text("24x7 Roadside Assistance", style: TextStyle(color: Color(0xFF4313B8), fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- VEHICLE IMAGE SLIDER ---
                  Container(
                    width: double.infinity,
                    height: 210,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4313B8).withValues(alpha: 0.05),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              PageView.builder(
                                onPageChanged: (index) {
                                  setState(() {
                                    _sliderIndex = index;
                                  });
                                },
                                itemCount: vehicleImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      vehicleImages[index],
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        // Dots Indicator
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              vehicleImages.length,
                              (idx) => Container(
                                width: _sliderIndex == idx ? 16 : 6,
                                height: 6,
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: _sliderIndex == idx ? const Color(0xFF4313B8) : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- SPECS ROW GRID ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpecItem(Icons.speed, "$range km", "Range"),
                      _buildSpecItem(Icons.bolt, "25 km/h", "Top Speed"),
                      _buildSpecItem(Icons.airline_seat_recline_normal, "1 Seat", "Seating"),
                      _buildSpecItem(Icons.battery_charging_full, "Removable", "Battery"),
                      _buildSpecItem(Icons.circle_outlined, "Disc", "Brake"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- ABOUT SECTION ---
                  const Text("About vehicle", style: TextStyle(color: Color(0xFF1E293B), fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    "Compact, stylish and perfect for short city rides. Easy to handle with zero emissions and extremely smooth performance.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),

                  // --- CHOOSE YOUR RIDE ---
                  const Text("Choose your ride", style: TextStyle(color: Color(0xFF1E293B), fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Daily Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _rideType = "Daily"),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _rideType == "Daily" ? const Color(0xFF4313B8) : const Color(0xFFE2E8F0), width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time, color: _rideType == "Daily" ? const Color(0xFF4313B8) : Colors.grey, size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text("Daily Drive", style: TextStyle(color: Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 2),
                                      Text("4+ Hours (Ideal)", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                                if (_rideType == "Daily")
                                  const Icon(Icons.check_circle, color: Color(0xFF4313B8), size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Subscription Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _rideType = "Subscription"),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _rideType == "Subscription" ? const Color(0xFF4313B8) : const Color(0xFFE2E8F0), width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month, color: _rideType == "Subscription" ? const Color(0xFF4313B8) : Colors.grey, size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text("Subscription", style: TextStyle(color: Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 2),
                                      Text("7+ Days bookings", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                                if (_rideType == "Subscription")
                                  const Icon(Icons.check_circle, color: Color(0xFF4313B8), size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- SELECT DATE & TIME DISPLAY CARD ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Color(0xFF4313B8), size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Select Date & Time", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text(
                                "17 June 2026, 05:00 PM - 08:00 AM",
                                style: TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _openDatePicker,
                          child: const Text("Change", style: TextStyle(color: Color(0xFF4313B8), fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- PICKUP ZONE DISPLAY CARD ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Color(0xFF4313B8), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Pickup Zone", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text(
                                "Connaught Place Zone, New Delhi",
                                style: TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Change", style: TextStyle(color: Color(0xFF4313B8), fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // --- BOTTOM PAYABLE CARD & CONTINUE BOOKING BUTTON ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Total Payable", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text("₹${todaysRate.toStringAsFixed(0)}", style: const TextStyle(color: Color(0xFF1E293B), fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          const Icon(Icons.info_outline, color: Colors.grey, size: 14),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text("Incl. of all taxes", style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _openDatePicker,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B0B78), // Deep purple
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Continue Booking", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Icon(icon, color: const Color(0xFF4313B8), size: 18),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _openDatePicker() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectDateTimeScreen()),
    );
  }
}