import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '/Page/Search/SearchType.dart';
import '/Routes/pages.dart';
import '../../reuseWidget.dart';

class SearchController extends GetxController {
  TextEditingController keywords = TextEditingController(),
      postBy = TextEditingController(),
      replies = TextEditingController(),
      postedOnTheProfileOfMember = TextEditingController();
  ExpandableController expandableController = ExpandableController();
  bool isSearchTitlesOnly = false, visible = true;
  String dateTime = '', radioGroup = 'relevance';
  DateTime newDateTime = DateTime.now();
  int selectPrefix = 0, selectSearchInForum = 0;
  ScrollController scrollController = ScrollController();
  final itemKey = GlobalKey();
  final List<GlobalObjectKey<FormState>> formKeyList = List.generate(55, (index) => GlobalObjectKey<FormState>(index));


  @override
  onReady() {
    super.onReady();
    expandableController.addListener(() {
      if (expandableController.value == true) {
        visible = false;
        update(['visibleTitlesOnly']);
      } else {
        visible = true;
        update(['visibleTitlesOnly']);
      }
    });
  }

  @override
  onClose() {
    expandableController.removeListener(() => print('ascascsacas'));
    expandableController.dispose();
    keywords.dispose();
    replies.dispose();
    postBy.dispose();
    prefix.clear();
    searchInForums.clear();
    super.onClose();
  }

  void handleRadioValueChange(Object value) {
    radioGroup = value.toString();
    // switch (radioGroup) {
    //   case '1':
    //     break;
    //   case '2':
    //     break;
    //   case '3':
    //     break;
    // }
    update(['updateGroupRadio']);
  }

  getSearchType() {
    return expandableController.value == true
        ? SearchType.SearchProfilePosts
        : replies.text == '' && selectPrefix == 0 && selectSearchInForum == 0 && radioGroup != 'replies'
            ? SearchType.SearchEverything
            : SearchType.SearchThreads;
  }

  search() {
    if (keywords.text.isEmpty && postBy.text.isEmpty) {
      setDialogError('Please specify a search query or the name of a member.');
    } else {
      Get.toNamed(Routes.SearchResult, arguments: [
        getSearchType(),
        {
          'keywords': keywords.text,
          'postBy': postBy.text,
          'isSearchTitlesOnly': isSearchTitlesOnly ? '1' : '',
          'dateTime': dateTime,
          'prefix': prefix.elementAt(selectPrefix)['id'],
          'searchInForums': searchInForums.elementAt(selectSearchInForum)['id'],
          'min_reply_count': radioGroup == 'replies' && replies.text == '' ? '0' : replies.text,
          'order': radioGroup,
          'profile_users' : postedOnTheProfileOfMember.text,
        }
      ]);
    }
  }

  List prefix = [
    {'name': '(Any)', 'id': ''},
    {'name': 'g??p ??', 'id': '4'},
    {'name': 'b??o l???i', 'id': '5'},
    {'name': 'th???c m???c', 'id': '6'},
    {'name': 'ch?? ??', 'id': '7'},
    {'name': 'TQ', 'id': '18'},
    {'name': 'HN', 'id': '8'},
    {'name': 'SG', 'id': '9'},
    {'name': 'DN', 'id': '10'},
    {'name': 'kh??c', 'id': '11'},
    {'name': 'th???o lu???n', 'id': '12'},
    {'name': 'tin t???c', 'id': '13'},
    {'name': '????nh gi??', 'id': '14'},
    {'name': 'khoe', 'id': '15'},
    {'name': 'th???c m???c', 'id': '16'},
    {'name': 'ki???n th???c', 'id': '17'},
    {'name': 'download', 'id': '19'},
  ];

  List searchInForums = [
    {'name': 'All forums', 'id': ''},
    {'name': '?????i s???nh', 'id': '1'},
    {'name': '\t\t\tTh??ng b??o', 'id': '2'},
    {'name': '\t\t\tG??p ??', 'id': '3'},
    {'name': 'M??y t??nh', 'id': '5'},
    {'name': '\t\t\tT?? v???n c???u h??nh', 'id': '70'},
    {'name': '\t\t\tOverclocking & Cooling & Modding', 'id': '6'},
    {'name': '\t\t\tAMD', 'id': '25'},
    {'name': '\t\t\tIntel', 'id': '24'},
    {'name': '\t\t\tGPU & M??n h??nh', 'id': '8'},
    {'name': '\t\t\tPh???n c???ng chung', 'id': '9'},
    {'name': '\t\t\tThi???t b??? ngo???i vi & Ph??? ki???n & M???ng', 'id': '30'},
    {'name': '\t\t\tServer / NAS / Render Farm', 'id': '83'},
    {'name': '\t\t\tSmall Form Factor PC', 'id': '61'},
    {'name': '\t\t\tHackintosh', 'id': '62'},
    {'name': '\t\t\tM??y t??nh x??ch tay', 'id': '47'},
    {'name': 'Ph???n m???m & Games', 'id': '20'},
    {'name': '\t\t\tPh???n m???m', 'id': '13'},
    {'name': '\t\t\tApp di ?????ng', 'id': '21'},
    {'name': '\t\t\t\t\t\tLi??n Minh Mobile', 'id': '88'},
    {'name': '\t\t\tPC Gaming', 'id': '11'},
    {'name': '\t\t\t\t\t\tLi??n Minh Huy???n Tho???i', 'id': '87'},
    {'name': '\t\t\tConsole Gaming', 'id': '22'},
    {'name': 'S???n ph???m c??ng ngh???', 'id': '46'},
    {'name': '\t\t\tAndroid', 'id': '32'},
    {'name': '\t\t\tApple', 'id': '36'},
    {'name': '\t\t\tMultimedia', 'id': '31'},
    {'name': '\t\t\t????? ??i???n t??? & Thi???t b??? gia d???ng', 'id': '10'},
    {'name': '\t\t\tCh???p ???nh & Quay phim', 'id': '75'},
    {'name': 'H???c t???p & S??? nghi???p', 'id': '89'},
    {'name': '\t\t\tNgo???i ng???', 'id': '90'},
    {'name': '\t\t\tL???p tr??nh / CNTT', 'id': '91'},
    {'name': '\t\t\tKinh t??? / Lu???t', 'id': '92'},
    {'name': '\t\t\tMake Money Online', 'id': '93'},
    {'name': '\t\t\tTi???n ??i???n t???', 'id': '94'},
    {'name': 'Khu vui ch??i gi??? tr??', 'id': '16'},
    {'name': '\t\t\tChuy???n tr?? linh tinh???', 'id': '17'},
    {'name': '\t\t\t??i???m b??o', 'id': '33'},
    {'name': '\t\t\t4 b??nh', 'id': '38'},
    {'name': '\t\t\t2 b??nh', 'id': '39'},
    {'name': '\t\t\tTh??? d???c th??? thao', 'id': '63'},
    {'name': '\t\t\t???m th???c & Du l???ch', 'id': '64'},
    {'name': '\t\t\tPhim / Nh???c / S??ch', 'id': '65'},
    {'name': '\t\t\tTh???i trang & L??m ?????p', 'id': '66'},
    {'name': '\t\t\tC??c th?? ch??i kh??c', 'id': '67'},
    {'name': 'Khu th????ng m???i', 'id': '84'},
    {'name': '\t\t\tM??y t??nh ????? b??n', 'id': '68'},
    {'name': '\t\t\tM??y t??nh x??ch tay', 'id': '72'},
    {'name': '\t\t\t??i???n tho???i di ?????ng', 'id': '76'},
    {'name': '\t\t\tXe c??c lo???i', 'id': '77'},
    {'name': '\t\t\tTh???i trang & L??m ?????p', 'id': '78'},
    {'name': '\t\t\tB???t ?????ng s???n', 'id': '79'},
    {'name': '\t\t\t??n u???ng & Du l???ch', 'id': '81'},
    {'name': '\t\t\tSIM s??? & ????? phong thu???', 'id': '82'},
    {'name': '\t\t\tS???n ph???m & D???ch v??? kh??c', 'id': '80'},
  ];
}
