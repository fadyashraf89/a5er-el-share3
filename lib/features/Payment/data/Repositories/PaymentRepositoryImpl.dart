import 'package:a5er_elshare3/features/Payment/domain/Repositories/PaymentRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/Constants/constants.dart';
import '../../../../core/utils/validators/validators.dart';
import '../../../Passenger/data/Entities/PassengerEntity.dart';
import '../../../Passenger/domain/models/Passenger.dart';
import '../../../Trip/domain/models/trip.dart';
import '../../domain/Cards.dart';
import '../../presentation/CardPaymentScreen.dart';

class PaymentRepositoryImpl implements PaymentRepository{
  @override
  Future<void> addCard(Cards card, Passenger passenger) async {
    try {
      CollectionReference cardsCollection =
      FirebaseFirestore.instance.collection(kCardsCollection);

      String documentId = passenger.email ?? '';
      if (documentId.isEmpty) {
        throw Exception("Passenger email is required to save card.");
      }
      await cardsCollection.doc(documentId).set({
        'cards': FieldValue.arrayUnion([]),
      }, SetOptions(merge: true));

      await cardsCollection.doc(documentId).update({
        'cards': FieldValue.arrayUnion([card.toMap()]),
      });

      print("Card added successfully for $documentId");
    } catch (e) {
      print("Failed to add card: $e");
      throw Exception("Error adding card: $e");
    }
  }
  @override
  dynamic CardPayment(PassengerEntity passenger, Trip trip) {
    return (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardPaymentScreen(
            selectedPaymentMethod: "Card",
            passenger: passenger,
            trip: trip,
          ),
        ),
      );
    };
  }

  @override
  dynamic CashPayment(PassengerEntity passenger, Trip trip){
    print("Payment By Cash");
  }
  @override
  dynamic PointsPayment(PassengerEntity passenger, Trip trip){
    Validators validators = Validators();
    if (validators.validatePoints(trip.points ?? 0, passenger.points ?? 0)) {
      return "Validated";
    } else {
      return "Not Validated";
    }
  }

}