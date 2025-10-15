import 'package:flutter/material.dart';
import '../models/content_item_model.dart';
// import 'package.url_launcher/url_launcher.dart';

class LearnScreen extends StatelessWidget {
  LearnScreen({super.key});

  final List<ContentItem> _contentItems = [
    // All your content data is the same...
    ContentItem(id: '1', title: 'The Richest Man in Babylon', description: 'Timeless financial principles through parables.', creator: 'George S. Clason', type: 'Book', url: '...'),
    ContentItem(id: '2', title: 'The 50/30/20 Rule of Thumb', description: 'A clear, concise explanation of this popular budgeting rule.', creator: 'The Plain Bagel', type: 'Video', url: '...'),
    ContentItem(id: '3', title: 'How to Create a Budget in 6 Simple Steps', description: 'A practical, step-by-step guide to setting up your first budget.', creator: 'NerdWallet', type: 'Article', url: '...'),
    ContentItem(id: '4', title: 'The Total Money Makeover', description: 'Explains the "Debt Snowball" method for getting out of debt.', creator: 'Dave Ramsey', type: 'Book', url: '...'),
    ContentItem(id: '5', title: 'Good Debt vs. Bad Debt', description: 'An educational video on the critical difference between debt types.', creator: 'Khan Academy', type: 'Video', url: '...'),
    ContentItem(id: '6', title: 'What Is a Credit Score and How to Improve It?', description: 'A foundational article explaining what a credit score is.', creator: 'Investopedia', type: 'Article', url: '...'),
    ContentItem(id: '7', title: 'The Little Book of Common Sense Investing', description: 'Explains the simple strategy of buying and holding low-cost index funds.', creator: 'John C. Bogle', type: 'Book', url: '...'),
    ContentItem(id: '8', title: 'The Power of Compound Interest (Animated)', description: 'Visually demonstrates why starting to invest early is so powerful.', creator: 'Various Creators', type: 'Video', url: '...'),
    ContentItem(id: '9', title: 'Stocks, Bonds, and Mutual Funds: An Overview', description: 'A clear article that defines the basic building blocks of investing.', creator: 'Forbes Advisor', type: 'Article', url: '...'),
    ContentItem(id: '10', title: 'The Psychology of Money', description: 'Doing well with money isn\'t about what you know, but how you behave.', creator: 'Morgan Housel', type: 'Book', url: '...'),
    ContentItem(id: '11', title: 'Saving for tomorrow, tomorrow', description: 'A fascinating TED Talk that explores the behavioral challenges of saving.', creator: 'Shlomo Benartzi', type: 'Video', url: '...'),
    ContentItem(id: '12', title: 'What Are Assets and Liabilities?', description: 'Explains the fundamental concept from "Rich Dad Poor Dad".', creator: 'Rich Dad Blog', type: 'Article', url: '...'),
  ];

  // <<< The '_launchURL' function has been REMOVED >>>

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Book': return Icons.book_outlined;
      case 'Video': return Icons.play_circle_outline;
      case 'Article': return Icons.article_outlined;
      default: return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgeting = _contentItems.where((i) => int.parse(i.id) <= 3).toList();
    final debt = _contentItems.where((i) => int.parse(i.id) >= 4 && int.parse(i.id) <= 6).toList();
    final investing = _contentItems.where((i) => int.parse(i.id) >= 7 && int.parse(i.id) <= 9).toList();
    final mindset = _contentItems.where((i) => int.parse(i.id) >= 10).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Literacy Hub'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategorySection('Budgeting & Saving Strategies', budgeting),
              _buildCategorySection('Understanding Debt & Credit', debt),
              _buildCategorySection('Introduction to Investing', investing),
              _buildCategorySection('Financial Mindset & Psychology', mindset),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<ContentItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...items.map((item) => _buildContentCard(item)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContentCard(ContentItem item) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // We removed the InkWell and onTap to prevent any errors.
      // This is now a simple, non-tappable card.
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(_getIconForType(item.type), color: Colors.deepPurple, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item.description, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}