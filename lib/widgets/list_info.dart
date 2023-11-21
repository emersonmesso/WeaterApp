import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListInfo extends StatelessWidget {
  const ListInfo(
      {Key? key,
      required this.title,
      required this.value,
      required this.corText})
      : super(key: key);
  final String title;
  final String value;
  final Color corText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                style: GoogleFonts.smoochSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: corText,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: GoogleFonts.smoochSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: corText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
