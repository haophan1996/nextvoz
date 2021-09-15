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
    {'name': 'góp ý', 'id': '4'},
    {'name': 'báo lỗi', 'id': '5'},
    {'name': 'thắc mắc', 'id': '6'},
    {'name': 'chú ý', 'id': '7'},
    {'name': 'TQ', 'id': '18'},
    {'name': 'HN', 'id': '8'},
    {'name': 'SG', 'id': '9'},
    {'name': 'DN', 'id': '10'},
    {'name': 'khác', 'id': '11'},
    {'name': 'thảo luận', 'id': '12'},
    {'name': 'tin tức', 'id': '13'},
    {'name': 'đánh giá', 'id': '14'},
    {'name': 'khoe', 'id': '15'},
    {'name': 'thắc mắc', 'id': '16'},
    {'name': 'kiến thức', 'id': '17'},
    {'name': 'download', 'id': '19'},
  ];

  List searchInForums = [
    {'name': 'All forums', 'id': ''},
    {'name': 'Đại sảnh', 'id': '1'},
    {'name': '\t\t\tThông báo', 'id': '2'},
    {'name': '\t\t\tGóp ý', 'id': '3'},
    {'name': 'Máy tính', 'id': '5'},
    {'name': '\t\t\tTư vấn cấu hình', 'id': '70'},
    {'name': '\t\t\tOverclocking & Cooling & Modding', 'id': '6'},
    {'name': '\t\t\tAMD', 'id': '25'},
    {'name': '\t\t\tIntel', 'id': '24'},
    {'name': '\t\t\tGPU & Màn hình', 'id': '8'},
    {'name': '\t\t\tPhần cứng chung', 'id': '9'},
    {'name': '\t\t\tThiết bị ngoại vi & Phụ kiện & Mạng', 'id': '30'},
    {'name': '\t\t\tServer / NAS / Render Farm', 'id': '83'},
    {'name': '\t\t\tSmall Form Factor PC', 'id': '61'},
    {'name': '\t\t\tHackintosh', 'id': '62'},
    {'name': '\t\t\tMáy tính xách tay', 'id': '47'},
    {'name': 'Phần mềm & Games', 'id': '20'},
    {'name': '\t\t\tPhần mềm', 'id': '13'},
    {'name': '\t\t\tApp di động', 'id': '21'},
    {'name': '\t\t\t\t\t\tLiên Minh Mobile', 'id': '88'},
    {'name': '\t\t\tPC Gaming', 'id': '11'},
    {'name': '\t\t\t\t\t\tLiên Minh Huyền Thoại', 'id': '87'},
    {'name': '\t\t\tConsole Gaming', 'id': '22'},
    {'name': 'Sản phẩm công nghệ', 'id': '46'},
    {'name': '\t\t\tAndroid', 'id': '32'},
    {'name': '\t\t\tApple', 'id': '36'},
    {'name': '\t\t\tMultimedia', 'id': '31'},
    {'name': '\t\t\tĐồ điện tử & Thiết bị gia dụng', 'id': '10'},
    {'name': '\t\t\tChụp ảnh & Quay phim', 'id': '75'},
    {'name': 'Học tập & Sự nghiệp', 'id': '89'},
    {'name': '\t\t\tNgoại ngữ', 'id': '90'},
    {'name': '\t\t\tLập trình / CNTT', 'id': '91'},
    {'name': '\t\t\tKinh tế / Luật', 'id': '92'},
    {'name': '\t\t\tMake Money Online', 'id': '93'},
    {'name': '\t\t\tTiền điện tử', 'id': '94'},
    {'name': 'Khu vui chơi giả trí', 'id': '16'},
    {'name': '\t\t\tChuyện trò linh tinh™', 'id': '17'},
    {'name': '\t\t\tĐiểm báo', 'id': '33'},
    {'name': '\t\t\t4 bánh', 'id': '38'},
    {'name': '\t\t\t2 bánh', 'id': '39'},
    {'name': '\t\t\tThể dục thể thao', 'id': '63'},
    {'name': '\t\t\tẨm thực & Du lịch', 'id': '64'},
    {'name': '\t\t\tPhim / Nhạc / Sách', 'id': '65'},
    {'name': '\t\t\tThời trang & Làm đẹp', 'id': '66'},
    {'name': '\t\t\tCác thú chơi khác', 'id': '67'},
    {'name': 'Khu thương mại', 'id': '84'},
    {'name': '\t\t\tMáy tính để bàn', 'id': '68'},
    {'name': '\t\t\tMáy tính xách tay', 'id': '72'},
    {'name': '\t\t\tĐiện thoại di động', 'id': '76'},
    {'name': '\t\t\tXe các loại', 'id': '77'},
    {'name': '\t\t\tThời trang & Làm đẹp', 'id': '78'},
    {'name': '\t\t\tBất động sản', 'id': '79'},
    {'name': '\t\t\tĂn uống & Du lịch', 'id': '81'},
    {'name': '\t\t\tSIM số & Đồ phong thuỷ', 'id': '82'},
    {'name': '\t\t\tSản phẩm & Dịch vụ khác', 'id': '80'},
  ];
}
