import 'package:a5er_elshare3/dependency_injection.dart';
import 'package:a5er_elshare3/features/Passenger/domain/UseCases/FetchPassengerDataUseCase.dart';
import 'package:a5er_elshare3/features/Payment/data/Database/CardStorage.dart';
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
    FetchPassengerDataUseCase fetchPassengerDataUseCase = sl<FetchPassengerDataUseCase>();

    return Scaffold(
      appBar: AppBar(title: const Text('Card Payment')),
      body: FutureBuilder<Passenger>(
          future: fetchPassengerDataUseCase.fetchPassengerData(),
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
                      String cardNumber = cardNumberController.text.trim();
                      String expirationDate =
                          expirationDateController.text.trim();
                      String cvv = cvvController.text.trim();

                      if (cardNumber.isEmpty ||
                          expirationDate.isEmpty ||
                          cvv.isEmpty) {
                        print("Please complete all fields.");
                        return;
                      }

                      Cards card = Cards(
                        CardNumber: cardNumber,
                        ExpiryDate: expirationDate,
                        CVV: cvv,
                        passenger: passenger,
                      );
                      CardStorage storage = CardStorage();
                      await storage.addCard(card, passenger);
                      print('Processing payment for card number $cardNumber');

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


}
