import 'dart:async';
import 'package:flutter/material.dart';
import 'destination.dart';
import 'travel_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _showAllDestinations = false;
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final allDestinations = [
          {'name': 'Netarhat Hills', 'location': 'Latehar', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'},
          {'name': 'Hundru Falls', 'location': 'Ranchi', 'image': 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=400'},
          {'name': 'Betla Park', 'location': 'Latehar', 'image': 'https://images.unsplash.com/photo-1549366021-9f761d040a94?w=400'},
          {'name': 'Dassam Falls', 'location': 'Ranchi', 'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400'},
          {'name': 'Jonha Falls', 'location': 'Ranchi', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'},
          {'name': 'Tagore Hill', 'location': 'Ranchi', 'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400'},
          {'name': 'Deoghar Temple', 'location': 'Deoghar', 'image': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400'},
          {'name': 'Parasnath Hill', 'location': 'Giridih', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'},
        ];
        _currentPage = (_currentPage + 1) % allDestinations.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildDestinations(),
              _buildTravelAnywhere(),
              _buildNearbyFoods(),
              _buildNearbyHotels(),
              _buildCategories(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const Text(
                'Explore Jharkhand',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => print('Notification tapped'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.notifications_outlined, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => print('Search tapped'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[500]),
            const SizedBox(width: 12),
            Text(
              'Where do you want to go?',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinations() {
    final allDestinations = [
      {'name': 'Netarhat Hills', 'location': 'Latehar', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'},
      {'name': 'Hundru Falls', 'location': 'Ranchi', 'image': 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=400'},
      {'name': 'Betla Park', 'location': 'Latehar', 'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400'},
      {'name': 'Dassam Falls', 'location': 'Ranchi', 'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400'},
      {'name': 'Jonha Falls', 'location': 'Ranchi', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'},
      {'name': 'Tagore Hill', 'location': 'Ranchi', 'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400'},
      {'name': 'Deoghar Temple', 'location': 'Deoghar', 'image': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400'},
      {'name': 'Parasnath Hill', 'location': 'Giridih', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Destinations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () => print('See all tapped'),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: null,
            itemBuilder: (context, index) {
              final realIndex = index % allDestinations.length;
              final destination = allDestinations[realIndex];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DestinationDetailScreen(
                          name: destination['name'] as String,
                          location: destination['location'] as String,
                          image: destination['image'] as String,
                          rating: '4.${(8 - realIndex).clamp(1, 9)}',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Stack(
                              children: [
                                Image.network(
                                  destination['image'] as String,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: Icon(Icons.landscape, size: 40, color: Colors.grey[400]),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.visibility, size: 12, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Preview',
                                          style: TextStyle(fontSize: 10, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            destination['name'] as String,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTravelAnywhere() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Text(
            'Travel Anywhere',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TravelPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.directions, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Plan Your Journey',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildNearbyFoods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Text(
            'Popular Crafts & Foods',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          index == 0 ? 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400' :
                          index == 1 ? 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400' :
                          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(
                                  index == 0 ? Icons.palette : 
                                  index == 1 ? Icons.handyman : Icons.restaurant,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index == 0 ? 'Folk Arts' : index == 1 ? 'Local Food' : 'Handicrafts',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(9.8)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyHotels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Text(
            'Hotels',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          index == 0 ? 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400' :
                          index == 1 ? 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400' :
                          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(
                                  index == 0 ? Icons.pool : 
                                  index == 1 ? Icons.deck : Icons.local_pizza,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index == 0 ? 'Luxury Hotel' : index == 1 ? 'Resort' : 'Budget Hotel',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(9.8)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'name': 'Adventure', 'icon': Icons.terrain, 'color': Colors.orange},
      {'name': 'Culture', 'icon': Icons.temple_buddhist, 'color': Colors.purple},
      {'name': 'Nature', 'icon': Icons.forest, 'color': Colors.green},
      {'name': 'Wildlife', 'icon': Icons.pets, 'color': Colors.brown},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () => print('${category['name']} category tapped'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[100]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (category['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          category['icon'] as IconData,
                          color: category['color'] as Color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        category['name'] as String,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}