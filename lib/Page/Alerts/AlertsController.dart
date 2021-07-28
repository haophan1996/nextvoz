import 'package:get/get.dart';
import '/GlobalController.dart';

class AlertsController extends GetxController{

  refreshList() async {
    GlobalController.i.alertList.clear();
    await GlobalController.i.getAlert();
  }

}