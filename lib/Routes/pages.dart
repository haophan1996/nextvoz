import 'package:the_next_voz/Page/Login/AccountList/AccountListBindings.dart';
import 'package:the_next_voz/Page/Login/AccountList/AccountListUI.dart';
import 'package:the_next_voz/Page/Login/BrowserLogin/BrowserLoginBindings.dart';
import 'package:the_next_voz/Page/Login/BrowserLogin/BrowserLoginSigninUI.dart';
import 'package:the_next_voz/Page/View/ViewUITab.dart';

import '/Page/PostStatus/Create/CreatePostUI.dart';
import '/Page/Profile/UserFollIgr/UserFollIgrBindings.dart';
import '/Page/Profile/UserFollIgr/UserFollIgrUI.dart';
import '/Page/TermPolicy/TermBindings.dart';
import '/Page/TermPolicy/TermUI.dart';
import '/Page/Profile/AlertPlus/AlertPlusBindings.dart';
import '/Page/Profile/AlertPlus/AlertPlusUI.dart';
import '/Page/Profile/ProfilePost/ProfilePostBindings.dart';
import '/Page/Profile/ProfilePost/ProfilePostUI.dart';
import '/Page/Alert_Inbox/InboxBindings.dart';
import '/Page/Alert_Inbox/InboxUI.dart';
import '/Page/Alerts/AlertUI.dart';
import '/Page/Alerts/AlertsBinding.dart';
import '/Page/Login/LoginBindings.dart';
import '/Page/Login/LoginUI.dart';
import '/Page/PostStatus/PostStatusBindings.dart';
import '/Page/PostStatus/Post/PostStatusUI.dart';
import '/Page/Profile/UserProfile/UserProfileBinding.dart';
import '/Page/Profile/UserProfile/UserProfileUI.dart';
import '/Page/Search/Search/SearchBinding.dart';
import '/Page/Search/Search/SearchUI.dart';
import '/Page/Search/SearchResult/SearchResultBindings.dart';
import '/Page/Search/SearchResult/SearchResultUI.dart';
import '/Page/Settings/SettingsBinding.dart';
import '/Page/Settings/SettingsUI.dart';
import '/Page/Thread/ThreadBinding.dart';
import '/Page/Thread/ThreadUI.dart';
import '/Page/View/ViewBinding.dart';
import '/Page/View/ViewUI.dart';
import '/Page/home/homeBinding.dart';
import '/Page/home/homeUI.dart';
import '/Page/youtubeView/ViewYoutube.dart';
import '/Page/youtubeView/YoutubeBinding.dart';
import 'package:get/get.dart';

part 'routes.dart';

class AppPage {
  static const INITIAL = Routes.Home;

  static final pages = [
    GetPage(
        name: Routes.Home,
        page: () => HomePageUI(),
        // transition: Transition.topLevel,
        // transitionDuration: Duration(milliseconds: 200),
        fullscreenDialog: true,
        popGesture: true,
        binding: HomeBinding(),
        maintainState: false),
    GetPage(
        name: Routes.Term,
        page: () => TermUI(),
        transition: Transition.topLevel,
        transitionDuration: Duration(milliseconds: 200),
        popGesture: false,
        binding: TermBindings(),
        maintainState: false),
    GetPage(
        name: Routes.Thread,
        page: () => ThreadUI(),
        popGesture: true,
        binding: ThreadBinding(),
        gestureWidth: (context) => context.width * 0.8,
        maintainState: false),
    GetPage(
        name: Routes.View,
        page: () => ViewUITab(),
        binding: ViewBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: 200),
        popGesture: true,
        maintainState: false),
    GetPage(
        name: Routes.Alerts,
        page: () => AlertsUI(),
        transition: Transition.topLevel,
        transitionDuration: Duration(milliseconds: 200),
        binding: PopBinding(),
        gestureWidth: (context) => context.width,
        popGesture: true),
    GetPage(
        name: Routes.Conversation,
        page: () => InboxUI(),
        transition: Transition.topLevel,
        transitionDuration: Duration(milliseconds: 200),
        binding: InboxBindings(),
        gestureWidth: (context) => context.width,
        popGesture: true),
    GetPage(
        name: Routes.Profile,
        page: () => UserProfileUI(),
        binding: UserProfileBinding(),
        gestureWidth: (context) => context.width,
        popGesture: true,
        transition: Transition.topLevel,
        transitionDuration: Duration(milliseconds: 200),
        maintainState: false),
    GetPage(name: Routes.Youtube, page: () => YoutubeView(), binding: YoutubeBinding(), popGesture: true),
    GetPage(
        name: Routes.AddReply,
        page: () => PostStatusUI(),
        popGesture: false,
        binding: PostStatusBindings(),
        transition: Transition.topLevel,
        transitionDuration: Duration(milliseconds: 200),
        maintainState: false),
    GetPage(
        name: Routes.CreatePost,
        page: () => CreatePostUI(),
        popGesture: false,
        binding: PostStatusBindings(),
        transition: Transition.topLevel,
        transitionDuration: Duration(milliseconds: 200),
        maintainState: false),
    GetPage(name: Routes.Settings, page: () => SettingsUI(), popGesture: true, binding: SettingsBinding(), maintainState: false),
    GetPage(
      name: Routes.Login,
      page: () => LoginUI(),
      binding: LoginBindings(),
      transition: Transition.topLevel,
      transitionDuration: Duration(milliseconds: 200),
      gestureWidth: (context) => context.width,
      popGesture: true,
    ),
    GetPage(
      name: Routes.SearchPage,
      page: () => SearchUI(),
      binding: SearchBindings(),
      gestureWidth: (context) => context.width,
      popGesture: true,
    ),
    GetPage(
      name: Routes.SearchResult,
      page: () => SearchResultUI(),
      binding: SearchResultBindings(),
      gestureWidth: (context) => context.width,
      popGesture: true,
    ),
    GetPage(
      name: Routes.AlertPlus,
      page: () => AlertPlusUI(),
      binding: AlertPlusBindings(),
      gestureWidth: (context) => context.width,
      popGesture: true,
    ),
    GetPage(
      name: Routes.ProfilePost,
      page: () => ProfilePostUI(),
      binding: ProfilePostBindings(),
      popGesture: true,
    ),
    GetPage(
      name: Routes.UserFollIgr,
      page: () => UserFollIgrUI(),
      binding: UserFollIgrBindings(),
      gestureWidth: (context) => context.width,
      popGesture: true,
    ),
    GetPage(
      name: Routes.BrowserLogin,
      page: () => BrowserLoginUI(),
      binding: BrowserLoginBindings(),
      //gestureWidth: (context) => context.width,
      popGesture: true,
    ),
    GetPage(
      name: Routes.AccountLoginList,
      page: () => AccountListUI(),
      binding: AccountListBindings(),
      gestureWidth: (context) => context.width,
      popGesture: true,
    )
  ];
}
