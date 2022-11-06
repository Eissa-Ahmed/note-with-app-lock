import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app_2022/controller/cubitNote/add_note_cubit.dart';
import 'package:note_app_2022/model/addNoteModel.dart';

class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var cubit = AddNoteCubit.get(context);
    // List<AddNoteModel> searchItem = [];
    final List<AddNoteModel> searchItem = cubit.notes.where((e) {
      return e.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return searchItem.isEmpty
        ? Center(
            child: LottieBuilder.asset("assets/images/search.json"),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.75,
            ),
            itemBuilder: (context, i) {
              return item(context, searchItem, i);
            },
            itemCount: searchItem.length,
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var cubit = AddNoteCubit.get(context);
    // List<AddNoteModel> searchItem = [];
    final List<AddNoteModel> searchItem = cubit.notes.where((e) {
      return e.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return searchItem.isEmpty
        ? Center(
            child: LottieBuilder.asset("assets/images/search.json"),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.75,
            ),
            itemBuilder: (context, i) {
              return item(context, searchItem, i);
            },
            itemCount: searchItem.length,
          );
  }

  Padding item(BuildContext context, List<AddNoteModel> searchItem, int i) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          color: Color(searchItem[i].color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            searchItem[i].image == ""
                ? Container()
                : ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      searchItem[i].image,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      searchItem[i].title,
                      textDirection: TextDirection.rtl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      searchItem[i].note,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      softWrap: false,
                      maxLines: 5,
                      style: const TextStyle(
                        height: 1,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(
                          255,
                          231,
                          231,
                          231,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
