import 'package:flutter/material.dart';
import 'package:echo_flutter_news/models/article.dart';
import 'package:echo_flutter_news/widgets/custom_chip.dart';
import 'package:intl/intl.dart';

class NewsBody extends StatelessWidget {
  const NewsBody(this.article, {super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    DateTime articleDate =
        DateFormat("yyyy-MM-DDTHH:mm:s").parse(article.publishedAt);

    var formattedDate = DateFormat.yMMMMd().format(articleDate);

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomChip(
                borderRadius: BorderRadius.circular(20.0),
                backgroundColor: const Color(0xFFF7BD5F), // Custom color
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: const Color(0xFF84A59D), // Custom color
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formattedDate,
                    style: const TextStyle(color: Color(0xFF84A59D)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                article.description,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF84A59D), // Custom color
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                article.content,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      height: 1.5,
                      color: const Color.fromARGB(255, 17, 16, 17),
                    ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7BD5F), // Custom color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),
                    child: const Text(
                      'Read More',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF84A59D), // Custom color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),
                    child: const Text(
                      'Bookmark',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
