import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

// Models
enum DestinationCategory { 
  ecoTourism, 
  cultural, 
  historical, 
  adventure, 
  waterfalls, 
  wildlife 
}

class Destination {
  final String id;
  final String name;
  final String description;
  final String location;
  final List<DestinationCategory> categories;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final List<String> activities;
  final String bestTimeToVisit;
  final String entryFee;
  final bool hasARPreview;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.categories,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.activities,
    required this.bestTimeToVisit,
    required this.entryFee,
    this.hasARPreview = false,
  });
}

// Main Explore Destinations Screen
class ExploreDestinationsScreen extends StatefulWidget {
  const ExploreDestinationsScreen({super.key});

  @override
  State<ExploreDestinationsScreen> createState() => _ExploreDestinationsScreenState();
}

class _ExploreDestinationsScreenState extends State<ExploreDestinationsScreen>
    with TickerProviderStateMixin {
  
  Set<DestinationCategory> selectedFilters = {};
  List<Destination> filteredDestinations = [];
  
  late TabController _tabController;
  late AnimationController _particleController;
  
  // Consistent color scheme with home.dart
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF4ECDC4);
  static const Color backgroundColor = Color(0xFF0F0F23);
  
  // Sample destinations data for Jharkhand
  final List<Destination> destinations = [
    Destination(
      id: '1',
      name: 'Netarhat Hill Station',
      description: 'Known as the "Queen of Chotanagpur", Netarhat offers breathtaking sunrise and sunset views with lush green valleys.',
      location: 'Netarhat, Jharkhand',
      categories: [DestinationCategory.ecoTourism, DestinationCategory.adventure],
      images: ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400'],
      rating: 4.5,
      reviewCount: 1250,
      activities: ['Trekking', 'Photography', 'Sunrise/Sunset viewing', 'Nature walks'],
      bestTimeToVisit: 'October to March',
      entryFee: 'Free',
      hasARPreview: true,
    ),
    Destination(
      id: '2',
      name: 'Hundru Falls',
      description: 'A spectacular 98-meter waterfall on the Subarnarekha River, perfect for nature lovers and adventure enthusiasts.',
      location: 'Hundru Falls, Jharkhand',
      categories: [DestinationCategory.waterfalls, DestinationCategory.adventure],
      images: ['https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=400', 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400'],
      rating: 4.3,
      reviewCount: 890,
      activities: ['Rock climbing', 'Photography', 'Picnicking', 'Swimming'],
      bestTimeToVisit: 'July to February',
      entryFee: '₹10 per person',
      hasARPreview: true,
    ),
    Destination(
      id: '3',
      name: 'Betla National Park',
      description: 'Home to tigers, elephants, and diverse wildlife. One of the first national parks in India to become a tiger reserve.',
      location: 'Betla National Park, Jharkhand',
      categories: [DestinationCategory.wildlife, DestinationCategory.ecoTourism],
      images: ['https://images.unsplash.com/photo-1549366021-9f761d040a94?w=400', 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400'],
      rating: 4.2,
      reviewCount: 567,
      activities: ['Wildlife Safari', 'Bird watching', 'Jungle trekking', 'Photography'],
      bestTimeToVisit: 'November to April',
      entryFee: '₹50 per person + Safari charges',
      hasARPreview: false,
    ),
    Destination(
      id: '4',
      name: 'Deoghar Temple Complex',
      description: 'Sacred pilgrimage site housing the famous Baidyanath Temple, one of the twelve Jyotirlingas of Lord Shiva.',
      location: 'Deoghar, Jharkhand',
      categories: [DestinationCategory.cultural, DestinationCategory.historical],
      images: ['https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400', 'https://images.unsplash.com/photo-1605538883669-825200433431?w=400'],
      rating: 4.6,
      reviewCount: 2100,
      activities: ['Temple visits', 'Cultural exploration', 'Spiritual ceremonies', 'Local cuisine'],
      bestTimeToVisit: 'October to March',
      entryFee: 'Free (Donations welcome)',
      hasARPreview: true,
    ),
    Destination(
      id: '5',
      name: 'Patratu Valley',
      description: 'Scenic valley with pristine lake surrounded by hills, perfect for boating and peaceful retreats.',
      location: 'Patratu Valley, Jharkhand',
      categories: [DestinationCategory.ecoTourism, DestinationCategory.adventure],
      images: ['https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?w=400', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400'],
      rating: 4.1,
      reviewCount: 445,
      activities: ['Boating', 'Fishing', 'Camping', 'Photography'],
      bestTimeToVisit: 'October to April',
      entryFee: '₹20 per person + Boat charges',
      hasARPreview: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    filteredDestinations = destinations;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _particleController.dispose();
    super.dispose();
  }



  String _getCategoryString(List<DestinationCategory> categories) {
    return categories.map((cat) => _categoryToString(cat)).join(', ');
  }

  String _categoryToString(DestinationCategory category) {
    switch (category) {
      case DestinationCategory.ecoTourism:
        return 'Eco-Tourism';
      case DestinationCategory.cultural:
        return 'Cultural';
      case DestinationCategory.historical:
        return 'Historical';
      case DestinationCategory.adventure:
        return 'Adventure';
      case DestinationCategory.waterfalls:
        return 'Waterfalls';
      case DestinationCategory.wildlife:
        return 'Wildlife';
    }
  }

  void _applyFilters() {
    setState(() {
      if (selectedFilters.isEmpty) {
        filteredDestinations = destinations;
      } else {
        filteredDestinations = destinations.where((destination) {
          return destination.categories.any((cat) => selectedFilters.contains(cat));
        }).toList();
      }
    });
  }

  void _showDestinationDetails(Destination destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationDetailScreen(destination: destination),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final progress = (_particleController.value + index * 0.1) % 1.0;
        final size = MediaQuery.of(context).size;
        final particleSize = 3.0 + (index % 4) * 1.5;
        
        return Positioned(
          left: (math.sin(progress * 2 * math.pi + index) * 0.4 + 0.5) * size.width,
          top: (math.cos(progress * 2 * math.pi + index * 0.7) * 0.4 + 0.5) * size.height,
          child: Container(
            width: particleSize,
            height: particleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  primaryColor.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor,
              Color(0xFF16213E),
              Color(0xff6c63ff33),
              Color(0xff4ecdc433),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            ...List.generate(15, (index) => _buildFloatingParticle(index)),
            Column(
              children: [
                _buildCustomAppBar(),
                _buildFilterChips(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMapView(),
                      _buildListView(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 10, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'Explore Jharkhand',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(icon: Icon(Icons.map, size: 20), text: 'Map'),
                Tab(icon: Icon(Icons.list, size: 20), text: 'List'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: DestinationCategory.values.length,
        itemBuilder: (context, index) {
          final category = DestinationCategory.values[index];
          final isSelected = selectedFilters.contains(category);
          
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedFilters.remove(category);
                  } else {
                    selectedFilters.add(category);
                  }
                  _applyFilters();
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(colors: [primaryColor, secondaryColor])
                      : null,
                  color: isSelected ? null : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _categoryToString(category),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.3),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredDestinations.length,
        itemBuilder: (context, index) {
          final destination = filteredDestinations[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                ),
                child: const Icon(Icons.location_on, color: Colors.white),
              ),
              title: Text(
                destination.name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                destination.location,
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                '★ ${destination.rating}',
                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
              onTap: () => _showDestinationDetails(destination),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.3),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredDestinations.length,
        itemBuilder: (context, index) {
          final destination = filteredDestinations[index];
          return _buildDestinationCard(destination);
        },
      ),
    );
  }

  Widget _buildDestinationCard(Destination destination) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 15),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: InkWell(
            onTap: () => _showDestinationDetails(destination),
            borderRadius: BorderRadius.circular(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (destination.images.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                          child: Image.network(
                            destination.images.first,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 220,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                  ),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 220,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.landscape,
                                    size: 80,
                                    color: Colors.white70,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          height: 220,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.landscape,
                              size: 80,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                destination.location.split(',').first,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (destination.hasARPreview)
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.purple.shade600, Colors.purple.shade400],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.view_in_ar, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text('AR', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.amber.withOpacity(0.5)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${destination.rating}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.reviews, color: Colors.white.withOpacity(0.7), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '${destination.reviewCount} reviews',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: destination.entryFee.toLowerCase().contains('free') 
                                  ? Colors.green.withOpacity(0.2)
                                  : primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: destination.entryFee.toLowerCase().contains('free')
                                    ? Colors.green.withOpacity(0.5)
                                    : primaryColor.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              destination.entryFee,
                              style: TextStyle(
                                color: destination.entryFee.toLowerCase().contains('free')
                                    ? Colors.green.shade300
                                    : Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        destination.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: destination.categories.take(2).map((category) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor.withOpacity(0.4), secondaryColor.withOpacity(0.4)],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _categoryToString(category),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Destination Detail Screen
class DestinationDetailScreen extends StatefulWidget {
  final Destination destination;

  const DestinationDetailScreen({super.key, required this.destination});

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> with TickerProviderStateMixin {
  late AnimationController _particleController;
  
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF4ECDC4);
  static const Color backgroundColor = Color(0xFF0F0F23);
  
  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor,
              Color(0xFF16213E),
              Color(0xff6c63ff4d),
              Color(0xff4ecdc433),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.destination.name,
                  style: const TextStyle(
                    shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (widget.destination.images.isNotEmpty)
                      Image.network(
                        widget.destination.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.landscape,
                                size: 80,
                                color: Colors.white70,
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.landscape,
                            size: 80,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.destination.rating}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${widget.destination.reviewCount} reviews)',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (widget.destination.hasARPreview)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showARPreview();
                            },
                            icon: const Icon(Icons.view_in_ar),
                            label: const Text('View in AR'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        'About',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.destination.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoSection('Activities', widget.destination.activities),
                      const SizedBox(height: 16),
                      _buildInfoRow('Best Time to Visit', widget.destination.bestTimeToVisit),
                      _buildInfoRow('Entry Fee', widget.destination.entryFee),
                      const SizedBox(height: 24),
                      const Text(
                        'Categories',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.destination.categories.map((category) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor.withOpacity(0.3), secondaryColor.withOpacity(0.3)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Text(
                              _categoryToString(category),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showDirections();
        },
        backgroundColor: primaryColor,
        icon: const Icon(Icons.directions),
        label: const Text('Get Directions'),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  String _categoryToString(DestinationCategory category) {
    switch (category) {
      case DestinationCategory.ecoTourism:
        return 'Eco-Tourism';
      case DestinationCategory.cultural:
        return 'Cultural';
      case DestinationCategory.historical:
        return 'Historical';
      case DestinationCategory.adventure:
        return 'Adventure';
      case DestinationCategory.waterfalls:
        return 'Waterfalls';
      case DestinationCategory.wildlife:
        return 'Wildlife';
    }
  }

  void _showARPreview() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.view_in_ar,
                  size: 80,
                  color: Colors.purple.shade600,
                ),
                const SizedBox(height: 20),
                const Text(
                  'AR Preview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Experience ${widget.destination.name} in Augmented Reality. Point your camera to see historical reconstructions and cultural activities.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Launch AR Experience'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDirections() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Get Directions'),
          content: const Text('Open in your preferred maps application?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Open Maps'),
            ),
          ],
        );
      },
    );
  }
}