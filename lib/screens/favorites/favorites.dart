import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:echo_flutter_news/models/users.dart';
import 'package:echo_flutter_news/navigation/bottom_navbar.dart';
import 'package:echo_flutter_news/screens/articles/article_screen/article_screen.dart';
import 'package:echo_flutter_news/services/firestore_service.dart';
import 'package:echo_flutter_news/widgets/profile_stats_item.dart';
import 'package:echo_flutter_news/widgets/circle_avatar_button.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.onNewTabSelected});

  final Function onNewTabSelected;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color sandyBrown = const Color(0xFFF7BD5F);
  final Color sage = const Color.fromARGB(255, 0, 0, 0);
  final Color cream = const Color(0xFFEFE9AE);

  @override
  Widget build(BuildContext context) {
    String userid = FirebaseAuth.instance.currentUser!.uid;
    UserData? userData;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: sage,
            fontFamily: GoogleFonts.texturina().fontFamily,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: cream.withOpacity(0.9),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavbar(
        selected: 1,
        onTap: widget.onNewTabSelected,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: FirestoreService().getUser(userid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              userData = snapshot.data;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [cream.withOpacity(0.9), Colors.white],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    CircleAvatarButton(
                      imageUrl: userData!.avatarUrl,
                      color: sandyBrown,
                      iconColor: Colors.white,
                      onTap: () async {
                        await FirestoreService().setRandomAvatar(userid);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      userData!.name,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: sage,
                      ),
                    ),
                    Text(
                      userData!.email,
                      style: TextStyle(color: sage.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 24.0),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StatsItem(
                            title: "Articles Viewed",
                            icon: Icons.remove_red_eye,
                            color: sage,
                            value: userData!.openedArticles.length.toString(),
                          ),
                          StatsItem(
                            title: "Articles Liked",
                            value: userData!.favoriteArticles.length.toString(),
                            icon: Icons.favorite,
                            color: sandyBrown,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Favorite Articles",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: GoogleFonts.robotoCondensed().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: sage,
                            ),
                          ),
                          if (userData!.favoriteArticles.isNotEmpty)
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: cream,
                                    title: Text('Clear all?', style: TextStyle(color: sage)),
                                    content: Text(
                                      'Are you sure you want to clear all your favorite articles?',
                                      style: TextStyle(color: sage.withOpacity(0.8)),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: Text('Yes', style: TextStyle(color: sandyBrown)),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: Text('No', style: TextStyle(color: sage)),
                                      ),
                                    ],
                                  ),
                                ).then((value) async {
                                  if (value == true) {
                                    await FirestoreService().removeAllArticlesFromUser(userid);
                                    setState(() {});
                                  }
                                });
                              },
                              icon: Icon(Icons.delete, color: sandyBrown),
                              label: Text("Clear All", style: TextStyle(color: sandyBrown)),
                              style: TextButton.styleFrom(
                                backgroundColor: cream.withOpacity(0.5),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: userData!.favoriteArticles.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'You have no favorite articles yet',
                                    style: TextStyle(
                                      fontSize: 24,
                                      letterSpacing: -0.3,
                                      color: sage,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Go back to the articles screen and add some!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: -0.3,
                                      color: sage.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: userData!.favoriteArticles.length,
                              itemBuilder: (context, index) {
                                var article = userData!.favoriteArticles[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    confirmDismiss: (_) {
                                      return showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: cream,
                                          title: Text('Remove article?', style: TextStyle(color: sage)),
                                          content: Text(
                                            'Are you sure you want to remove this article from your favorites?',
                                            style: TextStyle(color: sage.withOpacity(0.8)),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: Text('Yes', style: TextStyle(color: sandyBrown)),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text('No', style: TextStyle(color: sage)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onDismissed: (_) async {
                                      await FirestoreService().removeArticleFromFavorites(userid, article);
                                      setState(() {});
                                    },
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [Colors.white, cream.withOpacity(0.3)],
                                          ),
                                        ),
                                        child: Center(
                                          child: ListTile(
                                            leading: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                article.urlToImage,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            title: Text(
                                              article.title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: TextStyle(
                                                color: sage,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => ArticleDetailsScreen(
                                                  article: article,
                                                ),
                                              ))
                                                  .then((_) {
                                                setState(() {});
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: sandyBrown,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}