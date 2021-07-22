import 'package:get/get.dart';
import 'package:vozforums/GlobalController.dart';

class AlertsController extends GetxController{

  refreshList() async {
    GlobalController.i.alertList.clear();
    GlobalController.i.getAlert();
  }

}