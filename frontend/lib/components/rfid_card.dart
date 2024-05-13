import 'package:flutter/material.dart';

class RfidCard extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;

  const RfidCard({
    Key? key,
    required this.cardNumber,
    required this.cardHolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blueGrey,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RFID Card',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Card ID: $cardNumber',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Card Holder: $cardHolder',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
