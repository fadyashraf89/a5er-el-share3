import 'package:a5er_elshare3/features/Payment/domain/Repositories/CardRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/constants.dart';
import '../../../Passenger/domain/models/Passenger.dart';
import '../../domain/Cards.dart';

class CardRepositoryImpl implements CardRepository{
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
}