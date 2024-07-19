import 'package:flutter/material.dart';
class GetLocationWidget extends StatelessWidget {
  const GetLocationWidget({
    super.key,
    required TextEditingController locationController,
  }) : _locationController = locationController;

  final TextEditingController _locationController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: _locationController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Enter Your Location',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            fillColor: Colors
                .transparent, // Set the fill color to transparent
            filled: true,
          ),
        ),
      ),
    );
  }
}
