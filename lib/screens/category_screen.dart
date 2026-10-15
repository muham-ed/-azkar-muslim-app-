import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dhikr_provider.dart';
import '../widgets/dhikr_card.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<DhikrProvider>(context, listen: false)
                  .resetCategory(categoryName);
            },
            tooltip: 'إعادة تعيين الكل',
          ),
        ],
      ),
      body: Consumer<DhikrProvider>(
        builder: (context, provider, child) {
          final category = provider.categories
              .firstWhere((cat) => cat.name == categoryName);
          
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: category.dhikrs.length,
            itemBuilder: (context, index) {
              final dhikr = category.dhikrs[index];
              return DhikrCard(
                dhikr: dhikr,
                onTap: () => provider.incrementDhikr(categoryName, dhikr.id),
                onReset: () => provider.resetDhikr(categoryName, dhikr.id),
              );
            },
          );
        },
      ),
    );
  }
}
