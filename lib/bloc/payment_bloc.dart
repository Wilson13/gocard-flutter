
import 'package:flutter/material.dart';
import 'package:perks_card/response/transfer_response.dart';
import 'package:perks_card/services/mambu_repository.dart';


class PaymentBloc {

  MambuRepository _mambuRepository;
  String balance = "";
  TextEditingController subjectController, languageController, descriptionController;

  PaymentBloc() {
      _mambuRepository = new MambuRepository();
    }

  Future<String> makePayment(String amount) async {
    try {
    TransferResponse response = await _mambuRepository.transferMoney(amount);
    return balance = response.balance;
    } catch(err) {
      throw err;
    }
  }
}