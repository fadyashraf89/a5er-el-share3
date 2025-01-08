import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Passenger/data/Database/FirebasePassengerStorage.dart';
import '../../Passenger/domain/models/Passenger.dart';
import '../../Trip/domain/models/trip.dart';
import '../domain/Cards.dart';

class CardPaymentScreen extends StatefulWidget {
  final String selectedPaymentMethod;
  final Passenger passenger;
  final Trip trip;

  const CardPaymentScreen({super.key, 
    required this.selectedPaymentMethod,
    required this.passenger,
    required this.trip,
  });

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationDateController =
      TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  FirebasePassengerStorage PStorage = FirebasePassengerStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Payment')),
      body: FutureBuilder<Passenger>(
          future: PStorage.fetchPassengerData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading user data"));
            }

            final passenger = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter Card Information'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: cardNumberController,
                    decoration: const InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: expirationDateController,
                    decoration:
                        const InputDecoration(labelText: 'Expiration Date (MM/YY)'),
                    keyboardType: TextInputType.datetime,
                  ),
                  TextField(
                    controller: cvvController,
                    decoration: const InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Retrieve user input
                      String cardNumber = cardNumberController.text.trim();
                      String expirationDate =
                          expirationDateController.text.trim();
                      String cvv = cvvController.text.trim();

                      // Validate input
                      if (cardNumber.isEmpty ||
                          expirationDate.isEmpty ||
                          cvv.isEmpty) {
                        print("Please complete all fields.");
                        return;
                      }

                      // Create a card object
                      Cards card = Cards(
                        CardNumber: cardNumber,
                        ExpiryDate: expirationDate,
                        CVV: cvv,
                        passenger: passenger,
                      );

                      // Save the card details
                      await addCard(card, passenger);

                      // Process the payment
                      print('Processing payment for card number $cardNumber');

                      // Navigate back after payment or show success
                      Navigator.pop(context);
                    },
                    child: const Text('Save and Pay'),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future<void> addCard(Cards card, Passenger passenger) async {
    try {
      CollectionReference cardsCollection =
          FirebaseFirestore.instance.collection('Cards');

      String documentId = passenger.email ?? '';
      if (documentId.isEmpty) {
        throw Exception("Passenger email is required to save card.");
      }

      // Merge existing cards or create a new array
      await cardsCollection.doc(documentId).set({
        'cards': FieldValue.arrayUnion([]),
      }, SetOptions(merge: true));

      // Update the card list with the new card
      await cardsCollection.doc(documentId).update({
        'cards': FieldValue.arrayUnion([card.toMap()]),
      });

      print("Card added successfully for $documentId");
    } catch (e) {
      print("Failed to add card: $e");
      throw Exception("Error adding card: $e");
    }
  }
}
