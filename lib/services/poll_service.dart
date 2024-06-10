import 'package:shared_preferences/shared_preferences.dart';

import '../models/poll_item_model.dart';

class PollService {
  static const _key = 'poll';

  Future<void> savePoll(PollItem pollItem) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, pollItem.toString());
  }

  Future<PollItem?> getSavedPoll() async {
    final prefs = await SharedPreferences.getInstance();
    final pollString = prefs.getString(_key);
    return pollString != null ? PollItem.fromString(pollString) : null;
  }
}