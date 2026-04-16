import 'package:flutter/material.dart';
import 'package:medicity_app/core/constants/app_index.dart';

import '../data/profile_mock.dart';
import '../models/profile_models.dart';
import '../widgets/profile_components.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  bool _showContactUs = false;
  int _expandedFaqIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: AppColors.welcomeBlue,
            padding: EdgeInsets.fromLTRB(
              18,
              MediaQuery.of(context).padding.top + 8,
              18,
              18,
            ),
            child: Column(
              children: [
                ProfileTopBar(
                  title: 'Help Center',
                  backgroundColor: AppColors.welcomeBlue,
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  'How Can We Help You?',
                  style: AppStyles.leagueSpartan16.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColors.hintColor,
                      ),
                      hintText: 'Search...',
                      hintStyle: AppStyles.leagueSpartan16.copyWith(
                        color: AppColors.signUpButtonBlue,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      HelpTabButton(
                        title: 'FAQ',
                        selected: !_showContactUs,
                        onTap: () {
                          setState(() {
                            _showContactUs = false;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      HelpTabButton(
                        title: 'Contact Us',
                        selected: _showContactUs,
                        onTap: () {
                          setState(() {
                            _showContactUs = true;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_showContactUs)
                    Expanded(
                      child: ListView.separated(
                        itemCount: contactOptions.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final option = contactOptions[index];
                          return Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: AppColors.signUpButtonBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  option.icon,
                                  color: AppColors.welcomeBlue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  option.title,
                                  style: AppStyles.leagueSpartan20.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.welcomeBlue,
                                size: 24,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  else
                    Expanded(
                      child: ListView(
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (int i = 0; i < faqTags.length; i++)
                                HelpTagChip(
                                  label: faqTags[i],
                                  selected: i == 0,
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          for (int i = 0; i < faqArticles.length; i++) ...[
                            _FaqCard(
                              article: faqArticles[i],
                              expanded: _expandedFaqIndex == i,
                              onTap: () {
                                setState(() {
                                  _expandedFaqIndex = _expandedFaqIndex == i
                                      ? -1
                                      : i;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  final FaqArticle article;
  final bool expanded;
  final VoidCallback onTap;

  const _FaqCard({
    required this.article,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: AppStyles.leagueSpartan12W300.copyWith(
                        color: const Color(0xFF6A6A6A),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.welcomeBlue,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(
                article.body,
                style: AppStyles.leagueSpartan12W300.copyWith(
                  color: const Color(0xFF6A6A6A),
                  fontSize: 13,
                  height: 1.15,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
