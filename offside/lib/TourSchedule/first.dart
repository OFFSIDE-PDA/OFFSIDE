import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../MainPage/home_page.dart';

class GetLocation extends StatelessWidget {
  const GetLocation(
      {super.key,
      required this.context,
      required this.title,
      required this.text});
  final BuildContext context;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                title == "NOW"
                    ? const Icon(
                        Icons.location_on_outlined,
                        size: 22,
                      )
                    : const Icon(Icons.location_on,
                        size: 22, color: Color.fromRGBO(14, 32, 87, 1)),
                const SizedBox(width: 5),
                Text(title,
                    style: TextStyle(
                      color: const Color.fromRGBO(14, 32, 87, 1),
                      fontWeight: FontWeight.w600,
                      fontSize: const AdaptiveTextSize()
                          .getadaptiveTextSize(context, 13),
                    )),
              ]),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text(text,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 12),
                  color: const Color.fromRGBO(128, 122, 122, 1),
                )),
          )
        ]);
  }
}
