import 'package:get/get.dart';
import 'package:pruksa/models/act_model.dart';
import 'package:pruksa/models/member_model.dart';
import 'package:pruksa/models/risk_model.dart';
import 'package:pruksa/models/user_model.dart';

class AppController extends GetxController {
  RxList<UserModel> usermodels = <UserModel>[].obs;
  RxList<bool> chooseUserModels = <bool>[].obs;
  RxList<RiskModel> riskModels = <RiskModel>[].obs;
  RxList<ActModel> actModels = <ActModel>[].obs;
  RxList<MemberModel> memberModels = <MemberModel>[].obs;
}
