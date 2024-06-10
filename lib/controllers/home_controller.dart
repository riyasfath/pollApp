import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poll_item_model.dart';
import '../services/create_poll_popup.dart';
import '../views/view_votes_screen.dart';

class HomeController extends GetxController {
  RxList<PollItem> polls = <PollItem>[].obs; // List to store all polls
  Rx<String?> selectedOption = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadPolls();
  }

  void showCreatePollPopup(BuildContext context) async {
    CreatePollBottomSheet(onPollCreated: (poll) {
      polls.add(poll);
      savePolls(); // Save polls after creation
    }).show(context);
  }

  void voteForOption(String option, int pollIndex) {
    if (polls.length > pollIndex && polls[pollIndex] != null) {
      selectedOption.value = option;
      polls[pollIndex].voteForOption(option);
      savePolls();
    }
  }

  Future<void> savePolls() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedPolls = polls.map((poll) => poll.toString()).toList();
    await prefs.setStringList('polls', encodedPolls); // Save all polls as a list
  }

  void viewVotes(int pollIndex) {
    if (polls.length > pollIndex && polls[pollIndex] != null) {
      Get.to(() =>ViewVotesPage(polls[pollIndex])); // Pass the selected poll object
    } else {
      Get.snackbar('Error', 'No poll available');
    }
  }

  Future<void> loadPolls() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedPolls = prefs.getStringList('polls');
    if (encodedPolls != null) {
      polls.value = encodedPolls.map((data) => PollItem.fromString(data)).toList();
    }
  }

  void deletePoll(int pollIndex) {
    if(polls.length > pollIndex && polls [pollIndex] != null){
      polls.removeAt(pollIndex);
      savePolls();
    }

  }
}
