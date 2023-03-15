import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/post_model/user_post_model.dart';

part 'user_repository.g.dart';

@riverpod
UsersRepository userRepository(UserRepositoryRef ref) => UsersRepository();

class UsersRepository {
  UsersRepository();
  static final Dio client = Dio();

  // create new user
  static Future<UserModel> createUser(
      {required String userName,
      required String email,
      required String fullName,
      required String photoUrl,
      required String mobileNumber}) async {
    final response =
        await client.post('https://onecrore.deno.dev/users', data: {
      'user_name': userName,
      'email': email,
      'full_name': fullName,
      'photo_url': photoUrl,
      'mobile_number': mobileNumber
    });
    return UserModel.fromJson(response.data);
  }

 
  static Future<UserModel> getUserByEmail(String email) async {
    final response = await client.get('https://onecrore.deno.dev/users/$email');
    return UserModel.fromJson(response.data);
  }
}
