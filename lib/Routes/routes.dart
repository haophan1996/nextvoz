part of 'pages.dart';

abstract class Routes{
  Routes._();
  static const Home = '/HomePage';
  static const Thread = '/ThreadPage';
  static const View = '/ViewPage';
  static const Alerts = '/Alerts';
  static const Conversation = '/AlertsInbox';
  static const Profile = '/UserProfile';
  static const Youtube = '/Youtube';
  static const AddReply = '/PostStatus';
  static const Settings = '/Settings';
  static const Login = '/Login';
  static const BrowserLogin = '/BrowserLogin'; ///todo
  static const SearchPage = '/searchPage';
  static const SearchResult = '/searchResult';
  static const AlertPlus = '/AlertPlus';
  static const UserFollIgr = '/UserFollowAndIgnore'; ///todo Display who is following, follower, ignoring
  static const ProfilePost = '/ProfilePost'; ///todo Latest profile post
}

