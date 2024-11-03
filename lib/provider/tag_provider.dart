import 'package:hooks_riverpod/hooks_riverpod.dart';

// The TagNotifier manages a list of tags as strings
class TagNotifier extends StateNotifier<List<dynamic>> {
  TagNotifier() : super([]);

  // Set the list of tags
  void setTags(List<dynamic> tags) {
    state = tags;
  }
}

// Create a StateNotifierProvider for the TagNotifier
final tagProvider = StateNotifierProvider<TagNotifier, List<dynamic>>((ref) {
  return TagNotifier();
});
