import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:echo_flutter_news/screens/articles/article_screen/article_screen.dart';
import 'package:echo_flutter_news/services/firestore_service.dart';
import 'package:echo_flutter_news/models/article.dart';
import 'package:echo_flutter_news/widgets/custom_chip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

/// List item representing a single Article
class ArticleListItem extends StatelessWidget {
  const ArticleListItem({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    if (article.urlToImage.isEmpty) {
      return const SizedBox.shrink(); // Ne pas afficher si l'image est manquante
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        shadowColor: const Color(0xFF84A59D).withOpacity(0.4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  // Image avec effet de fondu
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: _loadImage(article.urlToImage),
                  ),
                  // Titre de l'article
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        article.title,
                        style: GoogleFonts.lora(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFF333333), // Texte sombre
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
              // Badge avec le nom de la source
              Positioned(
                bottom: 15,
                left: 16,
                child: CustomChip(
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: const Color(0xFFF7BD5F).withOpacity(0.9),
                  children: [
                    Text(
                      article.source.name,
                      style: GoogleFonts.ubuntu(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEFE9AE),
                      ),
                    ),
                  ],
                ),
              ),
              // Enveloppe tactile pour navigation
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: const Color(0xFF84A59D).withOpacity(0.3),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailsScreen(
                            article: article,
                          ),
                        ),
                      );
                      if (FirebaseAuth.instance.currentUser != null) {
                        FirestoreService().addArticleToOpened(
                          FirebaseAuth.instance.currentUser!.uid,
                          article,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Charge une image avec effet de fondu. Affiche une image par défaut si erreur.
  Widget _loadImage(String urlToImage) {
    const placeHolderImage = AssetImage('assets/images/placeholder.png');
    return FadeInImage(
      fit: BoxFit.cover,
      width: double.infinity,
      image: NetworkImage(urlToImage),
      placeholder: MemoryImage(kTransparentImage),
      imageErrorBuilder: (context, error, stackTrace) => const Image(
        image: placeHolderImage,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}
