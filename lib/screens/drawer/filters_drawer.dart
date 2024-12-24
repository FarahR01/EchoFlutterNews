import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:echo_flutter_news/models/categories.dart';
import 'package:echo_flutter_news/screens/drawer/category_button.dart';

// Define custom colors to match other screens
const Color primaryColor = Color(0xFF84A59D);  // Sage green
const Color accentColor = Color(0xFFF7BD5F);   // Golden yellow
const Color backgroundColor = Color(0xFFEFE9AE); // Light yellow

class FiltersDrawer extends StatelessWidget {
  const FiltersDrawer({
    super.key,
    required this.selectedCategory,
    required this.onSelectedCategoriesChanged,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.onSignOut,
  });

  final String? selectedCategory;
  final Function onSelectedCategoriesChanged;
  final String name;
  final String email;
  final String imageUrl;
  final VoidCallback onSignOut;

  static const padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) => Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor,
                primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: ListView(
            children: <Widget>[
              buildHeader(
                context,
                name: name,
                imageUrl: imageUrl,
                email: email,
              ),
              Container(
                padding: padding,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Categories',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.5),
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...categories.map((category) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Card(
                            elevation: 0,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CategoryButton(
                              icon: category.icon,
                              text: StringUtils.capitalize(category.name),
                              value: category.name,
                              selected: selectedCategory == category.name,
                              onClicked: (value) {
                                if (selectedCategory == value) {
                                  onSelectedCategoriesChanged(null);
                                  return;
                                }
                                onSelectedCategoriesChanged(value);
                              },
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildHeader(
    BuildContext context, {
    required String name,
    required String email,
    required String imageUrl,
  }) =>
      Container(
        padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accentColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: onSignOut,
                    icon: const Icon(Icons.logout, color: Colors.white),
                    tooltip: 'Sign Out',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
}