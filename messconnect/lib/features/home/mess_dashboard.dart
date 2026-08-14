import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../auth/auth_controller.dart';

class MessDashboard extends ConsumerStatefulWidget {
  const MessDashboard({super.key});

  @override
  ConsumerState<MessDashboard> createState() => _MessDashboardState();
}

class _MessDashboardState extends ConsumerState<MessDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _StatsView(),
          _MealPlanView(),
          _MessProfileView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Meals'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  void _showCampaignManager(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Campaign Manager', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Send a discount to all students to increase orders for today!', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            _OfferItem(label: '10% Discount', icon: Icons.local_offer, color: Colors.blue),
            _OfferItem(label: 'Free Dessert', icon: Icons.icecream, color: Colors.pink),
            _OfferItem(label: 'Buy 1 Get 1', icon: Icons.control_point_duplicate, color: Colors.green),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.business_center, color: Color(0xFFE8612C)),
            const SizedBox(width: 12),
            Text('Owner Portal', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
        actions: [
          Switch.adaptive(
            value: true,
            activeColor: Colors.green,
            onChanged: (val) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(val ? 'Kitchen is now OPEN' : 'Kitchen is now CLOSED')));
            },
          ),
          const Center(child: Text('LIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Glass Card
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const LinearGradient(colors: [Color(0xFFE8612C), Color(0xFFFF9E7D)]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL REVENUE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  const Text('₹1,42,500', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _MiniMetric(label: 'New Users', value: '+12', icon: Icons.trending_up),
                      const SizedBox(width: 24),
                      _MiniMetric(label: 'Avg Rating', value: '4.8 ★', icon: Icons.star),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Performance Chart Mock
            Text('Weekly Performance', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 120,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(24)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Bar(height: 40, day: 'M'),
                  _Bar(height: 60, day: 'T'),
                  _Bar(height: 30, day: 'W'),
                  _Bar(height: 80, day: 'T', active: true),
                  _Bar(height: 50, day: 'F'),
                  _Bar(height: 70, day: 'S'),
                  _Bar(height: 20, day: 'S'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Quick Actions
            Text('Kitchen Management', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _ActionCard(icon: Icons.campaign, label: 'Promote', color: Colors.blue, onTap: () => _showCampaignManager(context)),
                const SizedBox(width: 16),
                _ActionCard(icon: Icons.inventory_2, label: 'Inventory', color: Colors.purple, onTap: () {}),
                const SizedBox(width: 16),
                _ActionCard(icon: Icons.qr_code_2, label: 'Payment', color: Colors.teal, onTap: () {
                  final state = context.findAncestorStateOfType<_MessDashboardState>();
                  state?.setState(() => state._currentIndex = 2);
                }),
              ],
            ),
            const SizedBox(height: 32),

            // Stock Alerts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Low Stock Alerts', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            const _StockItem(name: 'Basmati Rice', status: 'Running Low', color: Colors.amber),
            const _StockItem(name: 'Refined Oil', status: 'Critical (2L)', color: Colors.red),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.white70),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.day, this.active = false});
  final double height;
  final String day;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: height,
          decoration: BoxDecoration(color: active ? const Color(0xFFE8612C) : Colors.white12, borderRadius: BorderRadius.circular(10)),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 8, color: Colors.white38)),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockItem extends StatelessWidget {
  const _StockItem({required this.name, required this.status, required this.color});
  final String name, status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _OfferItem extends StatelessWidget {
  const _OfferItem({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      onTap: () {},
    );
  }
}

class _MealPlanView extends StatelessWidget {
  const _MealPlanView();

  void _editMeal(BuildContext context, String day, String currentMeal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $day\'s Menu'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Enter new dishes...'),
          controller: TextEditingController(text: currentMeal),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$day\'s menu updated!')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final meals = ['Paneer Masala & Roti', 'Aloo Gobi & Rice', 'Dal Tadka & Chapati', 'Veg Biryani', 'Chole Bhature', 'Special Thali', 'Holiday / Special'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Meal Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Viewing past menus...')));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFFDE7E0),
            child: Text(days[index][0], style: const TextStyle(color: Color(0xFFE8612C))),
          ),
          title: Text(days[index], style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(meals[index]),
          trailing: IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () => _editMeal(context, days[index], meals[index]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Publish Menu?'),
              content: const Text('This will notify all 124 students about the updated weekly menu.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menu published successfully!')));
                  },
                  child: const Text('Publish'),
                ),
              ],
            ),
          );
        },
        label: const Text('Publish Menu'),
        icon: const Icon(Icons.send),
        backgroundColor: const Color(0xFFE8612C),
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessProfileView extends ConsumerWidget {
  const _MessProfileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mess Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.orange,
              child: Icon(Icons.restaurant, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(profile?.messName ?? 'My Mess', style: Theme.of(context).textTheme.headlineSmall),
            Text(profile?.contactNo ?? 'No contact info', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            const Text('Payment QR Code', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            QrImageView(
              data: 'upi://pay?pa=messconnect@upi&pn=${profile?.messName ?? 'MessConnect'}',
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 16),
            const Text('Students can scan this to pay'),
          ],
        ),
      ),
    );
  }
}
