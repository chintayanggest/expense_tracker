// lib/screens/learn_screen.dart

import 'package:flutter/material.dart';

// --- DATA SOURCE (ALL ARTICLES) ---
final List<Map<String, dynamic>> learnContents = [
  {
    'title': 'Why Financial Recording is Important?',
    'category': 'Financial Tips',
    'date': 'Nov 13, 2025',
    'image': 'assets/images/pencatatan_keuangan.jpeg',
    'icon': Icons.receipt_long_outlined,
    'content': """
Amid rising prices of basic necessities and increasingly consumptive lifestyles, a new trend is emerging among young people: daily financial recording. A practice once considered complicated is now becoming an essential need to keep financial conditions safe.

According to a national financial survey in 2025, more than 62% of young Indonesians admit to often running out of money in the middle of the month because they never record their expenses. As a result, many feel stressed, impulsive when shopping, and find it difficult to control cash flow.

However, in the past year, changes have started to appear. Financial applications, digital notebooks, and budgeting methods like 50-30-20 are increasingly in demand. Experts assess that financial recording is not just a trend, but has become the foundation of healthy money management.

Why is Financial Recording Important?

1. Avoid Small Money Leaks
Small expenses like coffee, online transportation, and snacks can suddenly pile up to hundreds of thousands if not recorded.

2. Help Determine Financial Priorities
With expense records, wasteful patterns will be clearly visible, making it easier to set priorities.

3. Facilitate Long-Term Financial Plans
Recording helps create realistic savings targets, emergency funds, and investment plans.

4. Prevent Consumptive Debt
Ignorance of financial capacity limits often triggers debt. Financial records provide better control.

5. Maintain Emotional Stability Related to Money
With clear cash flow, someone can feel calmer and not anxious about their financial condition.

In an era that is fast-paced and full of online shopping distractions, financial recording becomes an important shield so that people can survive financially, make wiser decisions, and plan for the future more calmly.
"""
  },
  {
    'title': 'Simple Ways to Create a Monthly Budget',
    'category': 'Budgeting',
    'date': 'Nov 12, 2025',
    'image': 'assets/images/dompet_bulanan.jpeg',
    'icon': Icons.account_balance_wallet_outlined,
    'content': """
Many people struggle to manage monthly expenses not because of lack of money, but because they don't have a clear and structured budget. Creating a monthly budget is actually not as complicated as imagined - it's even very simple if you follow basic steps.

With the right budget, you can know where your money is going, avoid waste, and start building healthier financial habits.

1. Record All Sources of Income
Start by recording all income you receive each month, such as salary, allowance, bonuses, or freelance results.

2. Group Mandatory Expenses
Mandatory expenses include basic needs such as food, transportation, credit, quota, installments, rent, and academic needs.

3. Determine Spending Limits for Each Category
Use methods like 50-30-20 or create your own categories according to your lifestyle.
Example:
- 50% needs
- 30% wants
- 20% savings & investment

4. Set Aside Savings at the Beginning, Not the Rest
The best way to save is to immediately transfer savings funds at the beginning of the month before they are used for other things.

5. Track Daily Expenses
Use expense recording apps, spreadsheets, or notebooks to track all small and large transactions.

6. Evaluate Budget Every Week
Check if you are still within the set spending limits. If there are categories that always swell, adjust the budget.

7. Prepare Unexpected Funds
Not all needs can be predicted. Always set aside a little extra funds for urgent situations.

Creating a monthly budget is not just about managing money, but building discipline and healthier financial habits. By following these simple ways, you can control your finances better and reduce financial stress.
"""
  },
  {
    'title': 'Distinguishing Financial Needs and Wants',
    'category': 'Financial Planning',
    'date': 'Nov 11, 2025',
    'image': 'assets/images/financial_planning.jpeg',
    'icon': Icons.psychology_outlined,
    'content': """
In daily financial management, many people unknowingly misidentify between needs and wants. This simple mistake often becomes the cause of quickly emptying pockets, difficulty saving, and being trapped in impulsive consumption patterns.

Amid many promos, flash sales, and lifestyle trends on social media, the ability to sort out these two things becomes very important so that finances remain healthy and not easily shaken.

What Are Needs and Wants?

- Needs are expenses that must be met to survive and maintain basic life functions. Examples include food, health, shelter, transportation, and education.

- Wants are something done or purchased for comfort, lifestyle, or entertainment. For example, hanging out at expensive cafes, changing phones even though they're still good, or buying premium skincare even though you still have stock.

Why is it Important to Distinguish Needs and Wants?

1. Prevent Unplanned Expenses
By understanding the limits of needs, you can avoid impulsive spending that often makes money run out before time.

2. Help Create a Realistic Budget
By clearly knowing which priorities are primary, you can arrange more effective monthly budgeting.

3. Accelerate Financial Goals
Reducing the portion of wants helps enlarge the space for savings for emergency funds or investments.

4. Reduce Financial Stress
When spending is controlled, you will be calmer and not panic towards the end of the month.

Simple Ways to Distinguish Needs and Wants

- Ask yourself: "If I don't buy this, will my life be disrupted?" If the answer is no, then it's a want.
- Use the 24-hour rule before buying. If after 24 hours you still feel you need it, then consider it.
- Prioritize payment of needs in the first 10 seconds when receiving income. This prevents money from being used for unimportant things.
- Record all monthly expenses. From the records, you can see patterns and what is really important.
- Use a money division percentage like 50-30-20: 50% needs, 30% wants, 20% savings/investment.

With the ability to distinguish these two things, you can make wiser financial decisions, avoid waste, and achieve better economic stability in the future.
"""
  },
];

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Learn',
          style: TextStyle(
            color: Color(0xFFC6FF00),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFC6FF00),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC6FF00).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    color: Color(0xFFC6FF00),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Financial Education',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF121212),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Learn to manage your money wisely',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF121212),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Article Count Badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Articles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC6FF00),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6FF00),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${learnContents.length} articles',
                    style: const TextStyle(
                      color: Color(0xFF121212),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Articles List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 8),
              itemCount: learnContents.length,
              itemBuilder: (context, index) {
                final content = learnContents[index];
                return _buildArticleCard(content, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> content, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC6FF00).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navigateToDetail(content, context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6FF00).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    content['icon'] ?? Icons.article_outlined,
                    color: const Color(0xFF121212),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          content['category'],
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFC6FF00),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        content['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF121212),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Date
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            content['date'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6FF00).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF121212),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(Map<String, dynamic> content, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(data: content),
      ),
    );
  }
}

// --- ARTICLE DETAIL SCREEN (Redesigned) ---
class ArticleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ArticleDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFC6FF00).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFC6FF00)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Article',
          style: TextStyle(
            color: Color(0xFFC6FF00),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFC6FF00),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC6FF00).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data['category'],
                      style: const TextStyle(
                        color: Color(0xFFC6FF00),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    data['title'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF121212),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Metadata
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Color(0xFF121212)),
                      const SizedBox(width: 6),
                      Text(
                        data['date'],
                        style: const TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.visibility_outlined, size: 14, color: Color(0xFF121212)),
                      const SizedBox(width: 6),
                      const Text(
                        'Popular',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                data['content'],
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.8,
                  color: Color(0xFF121212),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
