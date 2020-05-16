
import 'package:flutter/material.dart';
import 'package:perks_card/response/get_ca_response.dart';
import 'package:perks_card/services/mambu_repository.dart';


class HomeBloc {

  MambuRepository _mambuRepository;
  String balance = "";
  TextEditingController subjectController, languageController, descriptionController;

  HomeBloc() {
      _mambuRepository = new MambuRepository();
    }

  Future<String> getCABalance() async {
    try {
    GetCaResponse response = await _mambuRepository.getCurrentAccount();
    return balance = response.balance;
    } catch(err) {
      throw err;
    }
  }
}