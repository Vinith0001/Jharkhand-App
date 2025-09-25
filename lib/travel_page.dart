import 'package:flutter/material.dart';
import 'dart:math';

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  bool _showResults = false;
  bool _showFromDropdown = false;
  bool _showToDropdown = false;
  List<Map<String, dynamic>>? _travelData;
  final Random _random = Random();

  final List<String> _busNames = ['KPN', 'SRS', 'VRL', 'RedBus', 'Orange'];
  final List<String> _trainNames = ['Chennai Express', 'Vande Bharat', 'Shatabdi', 'Rajdhani', 'Duronto'];
  final List<String> _jharkhandPlaces = ['Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro', 'Deoghar', 'Hazaribagh', 'Giridih', 'Ramgarh'];
  
  final List<String> _intermediateStops = [
    'Mango', 'Adityapur', 'Chaibasa', 'Gumla', 'Lohardaga',
    'Khunti', 'Simdega', 'Saraikela', 'Chakradharpur', 'Ghatshila'
  ];

  List<Map<String, dynamic>> _generateTravelData() {
    final from = _fromController.text;
    final to = _toController.text;
    
    return [
      {
        'type': 'Bus',
        'name': '${_busNames[_random.nextInt(_busNames.length)]} ${100 + _random.nextInt(900)}',
        'icon': Icons.directions_bus,
        'color': Colors.orange,
        'distance': '${150 + _random.nextInt(100)}km',
        'stops': _generateStops(from, to, 'bus'),
        'price': '₹${200 + _random.nextInt(300)}',
        'duration': '${4 + _random.nextInt(3)}h ${_random.nextInt(60)}min',
      },
      {
        'type': 'Train',
        'name': _trainNames[_random.nextInt(_trainNames.length)],
        'icon': Icons.train,
        'color': Colors.green,
        'distance': '${140 + _random.nextInt(80)}km',
        'stops': _generateStops(from, to, 'train'),
        'price': '₹${150 + _random.nextInt(200)}',
        'duration': '${3 + _random.nextInt(2)}h ${_random.nextInt(60)}min',
      },
    ];
  }
  
  List<String> _generateStops(String from, String to, String type) {
    List<String> stops = [from];
    int numStops = 5 + _random.nextInt(5);
    
    List<String> availableStops = List.from(_intermediateStops);
    availableStops.shuffle(_random);
    
    for (int i = 0; i < numStops && i < availableStops.length; i++) {
      stops.add(availableStops[i]);
    }
    
    stops.add(to);
    return stops;
  }

  void _requestLocationPermission(bool isFromField) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Permission'),
        content: Text('Allow app to access your location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isFromField) {
                _fromController.text = 'My Location';
              } else {
                _toController.text = 'My Location';
              }
              setState(() {});
            },
            child: Text('Allow'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Travel Anywhere'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationInputs(),
            const SizedBox(height: 20),
            _buildSearchButton(),
            if (_showResults) ...[
              const SizedBox(height: 30),
              _buildResults(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInputs() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              TextField(
                controller: _fromController,
                onChanged: (value) {
                  setState(() {
                    String lowerValue = value.toLowerCase();
                    _showFromDropdown = lowerValue.startsWith('m') || lowerValue.startsWith('l');
                  });
                },
                decoration: InputDecoration(
                  labelText: 'From',
                  prefixIcon: Icon(Icons.my_location, color: Colors.green),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'Enter starting location',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _toController,
                onChanged: (value) {
                  setState(() {
                    String lowerValue = value.toLowerCase();
                    _showToDropdown = lowerValue.startsWith('m') || lowerValue.startsWith('l');
                  });
                },
                decoration: InputDecoration(
                  labelText: 'To',
                  prefixIcon: Icon(Icons.location_on, color: Colors.red),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'Enter destination',
                ),
              ),
              if (_showToDropdown)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.my_location, color: Colors.blue),
                    title: Text('My Location'),
                    onTap: () {
                      _requestLocationPermission(false);
                      setState(() {
                        _showToDropdown = false;
                      });
                    },
                  ),
                ),
            ],
          ),
          if (_showFromDropdown)
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(Icons.my_location, color: Colors.blue),
                  title: Text('My Location'),
                  onTap: () {
                    _requestLocationPermission(true);
                    setState(() {
                      _showFromDropdown = false;
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_fromController.text.isNotEmpty && _toController.text.isNotEmpty) {
            if (_fromController.text.toLowerCase() == _toController.text.toLowerCase()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Travel is same')),
              );
              return;
            }
            setState(() {
              _travelData = _generateTravelData();
              _showResults = true;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Enter',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Travel Options from ${_fromController.text} to ${_toController.text}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _travelData?.length ?? 0,
              itemBuilder: (context, index) {
                final travel = _travelData![index];
                final stops = travel['stops'] as List<String>;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: (travel['color'] as Color?)?.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              travel['icon'] as IconData,
                              color: travel['color'] as Color?,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${travel['type']} - ${travel['name']}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${travel['distance']} • ${travel['duration']}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            travel['price'] as String,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Route: ${stops.join(' → ')}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}