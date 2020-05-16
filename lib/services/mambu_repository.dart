
import 'package:perks_card/api_base_helper.dart';
import 'package:perks_card/constants.dart';
import 'package:perks_card/response/get_ca_response.dart';
import 'package:perks_card/response/transfer_response.dart';

import '../helper.dart';

class MambuRepository {
  // final String baseUrl = 'https://api.queue.freshturfengineering.com/';
  ApiBaseHelper _apiHelper = ApiBaseHelper();
  Helper helper = Helper();


  Future<GetCaResponse> getCurrentAccount() async{
    try{
      final response = await _apiHelper.getBasicAuth(M_URL + 'savings/' + M_ACCOUNT_ID, M_USERNAME, M_PASSWORD);
      return GetCaResponse.fromJson(response);
    } catch (err) {
      throw err;
    }
  }

  Future<TransferResponse> transferMoney(String amount) async{
    try{
      final response = await _apiHelper.postBasicAuth(M_URL + 'savings/' + M_ACCOUNT_ID + '/transactions', amount, M_USERNAME, M_PASSWORD);
      return TransferResponse.fromJson(response);
    } catch (err) {
      throw err;
    }
  }
}