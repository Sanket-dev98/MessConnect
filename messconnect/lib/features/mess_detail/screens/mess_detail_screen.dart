import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_theme.dart';

class MessDetailScreen extends StatelessWidget {
  final String? messId;
  const MessDetailScreen({super.key, this.messId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.navyPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Annapurna Veg Delight',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: AppColors.orangeSecondary),
                              const SizedBox(width: 4),
                              Text(
                                'Navrangpura, Ahmedabad',
                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.star, color: Colors.green, size: 20),
                            Text(
                              '4.8',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _QuickInfo(icon: Icons.access_time, label: 'Open Now', sub: '9 AM - 10 PM'),
                      _QuickInfo(icon: Icons.currency_rupee, label: '₹2,500/mo', sub: 'Starting'),
                      _QuickInfo(icon: Icons.restaurant, label: 'Veg only', sub: 'Category'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Today\'s Menu',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: 'Lunch',
                    time: '12:30 PM - 2:30 PM',
                    items: 'Paneer Butter Masala, Roti, Dal Fry, Jeera Rice, Salad, Pickle',
                  ),
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: 'Dinner',
                    time: '7:30 PM - 9:30 PM',
                    items: 'Mix Veg Curry, Phulka Roti, Tadka Dal, Steamed Rice, Sweet (Gulab Jamun)',
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Subscription Plans',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PlanCard(
                    title: 'Monthly Unlimited',
                    price: '₹2,800',
                    description: '2 meals/day, 30 days',
                    isPopular: true,
                  ),
                  const SizedBox(height: 12),
                  _PlanCard(
                    title: '15 Meals Pack',
                    price: '₹1,500',
                    description: 'Flexible validity, Any 15 meals',
                    isPopular: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navyPrimary,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('SUBSCRIBE NOW'),
        ),
      ),
    );
  }
}

class _QuickInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;

  const _QuickInfo({required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.navyPrimary),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(sub, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final String time;
  final String items;

  const _MenuSection({required this.title, required this.time, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.navyPrimary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          const Divider(height: 24),
          Text(items, style: TextStyle(color: AppColors.darkGrey.withOpacity(0.8), height: 1.5)),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final bool isPopular;

  const _PlanCard({required this.title, required this.price, required this.description, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPopular ? AppColors.navyPrimary.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPopular ? AppColors.navyPrimary : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.orangeSecondary, borderRadius: BorderRadius.circular(4)),
                    child: const Text('POPULAR', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navyPrimary)),
        ],
      ),
    );
  }
}
