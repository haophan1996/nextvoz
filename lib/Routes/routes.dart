part of 'pages.dart';

abstract class Routes{
  Routes._();
  static const Home = '/HomePage';
  static const Term = '/Term';
  static const Thread = '/ThreadPage';
  static const View = '/ViewPage';
  static const Alerts = '/Alerts';
  static const Conversation = '/AlertsInbox';
  static const Profile = '/UserProfile';
  static const Youtube = '/Youtube';
  static const AddReply = '/PostStatus';
  static const CreatePost = '/CreatePost'; /// Create thread and profile post
  static const Settings = '/Settings';
  static const Login = '/Login';
  static const BrowserLogin = '/BrowserLogin';
  static const SearchPage = '/searchPage';
  static const SearchResult = '/searchResult';
  static const AlertPlus = '/AlertPlus';
  static const UserFollIgr = '/UserFollowAndIgnore';
  static const AccountLoginList = '/AccountLoginList';
  static const ProfilePost = '/ProfilePost'; ///todo Latest profile post
}

