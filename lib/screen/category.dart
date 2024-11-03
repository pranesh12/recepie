import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recepie_app/constant/api_endpoint.dart';
import 'package:recepie_app/provider/tag_provider.dart';
import 'package:recepie_app/screen/tag_recipe.dart';
import 'package:recepie_app/widgets/category_card.dart';
import 'package:http/http.dart' as http;

class Category extends ConsumerStatefulWidget {
  const Category({super.key});

  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends ConsumerState<Category> {
  @override
  void initState() {
    super.initState();
    setState(() {
      fetchTags();
    });
  }

  List<dynamic> tags = [];
  Future<void> fetchTags() async {
    try {
      final res = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/tags"));

      if (res.statusCode == 200) {
        setState(() {
          tags = (jsonDecode(res.body));
          ref.read(tagProvider.notifier).setTags(tags);
        });
      } else {
        print("something went wrong");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          toolbarHeight: 90,
        ),
        body: tags.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 2,
                          ),
                          itemCount: tags.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TagRecipe(
                                      tagName: tags[index].toString(),
                                    ), // Replace YourWidget with the widget you want to navigate to
                                  ),
                                );
                              },
                              child: CategoryCard(
                                tagName: tags[index],
                              ),
                            );
                          }))
                ],
              ));
  }
}
