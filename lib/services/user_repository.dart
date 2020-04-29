import 'package:meet_queue_volunteer/api_base_helper.dart';
import 'package:meet_queue_volunteer/response/user_response.dart';

class UserRepository {
  // final String baseUrl = 'https://api.queue.freshturfengineering.com/';
  ApiBaseHelper _apiHelper = ApiBaseHelper();

  // Future<List<User>> getUsers() async{
  
  //   final response = await _helper.get("user");
  //   if (response.statusCode == 200)
  //     return UserResponse.fromJson(response.body).data;
  //   else {
  //     print(response.body);
  //     throw Exception('Error from getUsers');
  //   }
  // }

  Future<UserData> searchUser(String nric) async{
  
    Map reqBody = {
      "nric": nric
    };

    final response = await _apiHelper.post("user/search", reqBody);
    if (response.statusCode == 200)
      return UserResponse.fromJson(response.body).data;
    else {
      print(response.body);
      throw Exception('Error from searching user');
    }
  }
}