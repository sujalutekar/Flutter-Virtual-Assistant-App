import 'package:flutter/material.dart';

class Images extends StatelessWidget {
  final List<dynamic> imageUrl;

  const Images({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: imageUrl
          .map(
            (url) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(url),
              ),
            ),
          )
          .toList(),
    );
    // return SizedBox(
    //   child: ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     itemCount: imageUrl.length,
    //     itemBuilder: (ctx, i) => Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(15),
    //         child: Image.network(imageUrl[i]),
    //       ),
    //     ),
    //   ),
    // );
  }
}
