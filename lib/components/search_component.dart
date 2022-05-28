import 'package:flutter/material.dart';

class SearchComponent extends StatelessWidget {
  const SearchComponent({Key? key, this.onChanged, this.hint})
      : super(key: key);
  final ValueChanged<String>? onChanged;
  final String? hint;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.5),
        child: TextField(
            style: const TextStyle(color: Color(0xff636370)),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(color: Color(0xff282833), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(color: Color(0xff282833), width: 2.0),
                ),
                hintStyle: const TextStyle(color: Color(0xff636370)),
                hintText: hint,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xff636370),
                )),
            onChanged: onChanged));
  }
}
