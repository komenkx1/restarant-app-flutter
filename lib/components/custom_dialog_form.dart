import 'package:flutter/material.dart';

class CustomFormDialog extends StatelessWidget {
  const CustomFormDialog(
      {Key? key,
      required this.namaPelangganController,
      required this.reviewController,
      this.onConfirm})
      : super(key: key);

  final TextEditingController namaPelangganController;
  final TextEditingController reviewController;
  final Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: namaPelangganController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: reviewController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Review',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        onConfirm?.call();
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
