import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class LanguageTranslatorScreen extends StatefulWidget {
  const LanguageTranslatorScreen({super.key});

  @override
  State<LanguageTranslatorScreen> createState() => _LanguageTranslatorScreenState();
}

class _LanguageTranslatorScreenState extends State<LanguageTranslatorScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _particleController;
  final TextEditingController _inputController = TextEditingController();
  
  String _translatedText = '';
  String _sourceLanguage = 'English';
  String _targetLanguage = 'Hindi';
  
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF4ECDC4);
  static const Color backgroundColor = Color(0xFF0F0F23);
  
  final List<String> _languages = [
    'English', 'Hindi', 'Bengali', 'Telugu', 'Marathi', 'Tamil', 'Gujarati'
  ];
  
  final Map<String, List<Map<String, String>>> _commonPhrases = {
    'Greetings': [
      {'en': 'Hello', 'hi': 'नमस्ते'},
      {'en': 'Good morning', 'hi': 'सुप्रभात'},
      {'en': 'Good evening', 'hi': 'शुभ संध्या'},
    ],
    'Travel': [
      {'en': 'Where is the bus station?', 'hi': 'बस स्टेशन कहाँ है?'},
      {'en': 'How much is the ticket?', 'hi': 'टिकट कितने का है?'},
      {'en': 'I need help', 'hi': 'मुझे मदद चाहिए'},
    ],
    'Food': [
      {'en': 'I am hungry', 'hi': 'मुझे भूख लगी है'},
      {'en': 'Water please', 'hi': 'पानी दीजिए'},
      {'en': 'How much does this cost?', 'hi': 'इसकी कितनी कीमत है?'},
    ],
  };

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

  void _translateText() {
    if (_inputController.text.isEmpty) return;
    
    // Simple mock translation
    final translations = {
      'hello': 'नमस्ते',
      'thank you': 'धन्यवाद',
      'please': 'कृपया',
      'help': 'मदद',
      'water': 'पानी',
      'food': 'खाना',
    };
    
    String input = _inputController.text.toLowerCase();
    String result = translations[input] ?? 'Translation not available';
    
    setState(() {
      _translatedText = result;
    });
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
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildLanguageSelector(),
                          const SizedBox(height: 20),
                          _buildTranslationSection(),
                          const SizedBox(height: 30),
                          _buildCommonPhrases(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Language Translator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Icon(Icons.translate, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('From', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _sourceLanguage,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    final temp = _sourceLanguage;
                    _sourceLanguage = _targetLanguage;
                    _targetLanguage = temp;
                  });
                },
                icon: const Icon(Icons.swap_horiz, color: Colors.white),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('To', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _targetLanguage,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              TextField(
                controller: _inputController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter text to translate...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: primaryColor),
                  ),
                ),
                onChanged: (text) => _translateText(),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _translatedText.isEmpty ? 'Translation will appear here...' : _translatedText,
                  style: TextStyle(
                    color: _translatedText.isEmpty ? Colors.white.withOpacity(0.5) : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _inputController.text.isNotEmpty ? _translateText : null,
                icon: const Icon(Icons.translate),
                label: const Text('Translate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommonPhrases() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Common Phrases',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ..._commonPhrases.entries.map((category) {
          return _buildPhraseCategory(category.key, category.value);
        }).toList(),
      ],
    );
  }

  Widget _buildPhraseCategory(String category, List<Map<String, String>> phrases) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...phrases.map((phrase) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phrase['en'] ?? '',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          phrase['hi'] ?? '',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _inputController.text = phrase['en'] ?? '';
                      _translateText();
                    },
                    icon: const Icon(Icons.copy, color: Colors.white, size: 18),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}