import 'package:get/get.dart';
import 'package:pruksa/models/user_model.dart';

class AppController extends GetxController {
  RxList<UserModel> usermodels = <UserModel>[].obs;
  RxList<bool> chooseUserModels = <bool>[].obs;
}
