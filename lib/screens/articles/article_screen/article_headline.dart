import 'package:flutter/material.dart';
import 'package:echo_flutter_news/models/article.dart';
import 'package:echo_flutter_news/widgets/custom_chip.dart';

class NewsHeadline extends StatelessWidget {
  const NewsHeadline(this.article, {super.key});
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image de l'article en arrière-plan
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(article.urlToImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Overlay avec dégradé
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withAlpha(0),
                Colors.black.withAlpha(150),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source de l'article avec CustomChip
                CustomChip(
                  borderRadius: BorderRadius.circular(20.0),
                  backgroundColor: const Color(0xFFF7BD5F).withOpacity(0.9),
                  children: [
                    Text(
                      article.source.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Titre de l'article
                Text(
                  article.title,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEFE9AE),
                        height: 1.25,
                      ),
                ),
                const SizedBox(height: 10),
                // Auteur de l'article
                Text(
                  article.author,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color(0xFF84A59D),
                        height: 1.25,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
