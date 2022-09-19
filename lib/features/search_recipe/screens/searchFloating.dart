import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';

import 'package:foodhub/widgets/default_button.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchFloatingScreen extends StatefulWidget {
  const SearchFloatingScreen({Key? key}) : super(key: key);

  @override
  State<SearchFloatingScreen> createState() => _SearchFloatingScreenState();
}

class _SearchFloatingScreenState extends State<SearchFloatingScreen> {
  static const historyLength = 5;

  List<String> _searchHistory = [];

  late List<String> filteredSearchHistory;

  String selectedTerm = '';
  //////////////
  GlobalKey<FormState> _searchKeyForm = GlobalKey();
  TextEditingController _searchController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPress = false;
  bool _timeToCook = false;
  double _value = 0;
  int valueTime = 0;
  String nameCuisine = 'tất cả';
  String nameMethod = 'tất cả';
  List<String?> cuisine = [
    'tất cả',
    'món Việt',
    'món Thái',
    'món Hoa',
    'món Âu',
    'món Mexico'
  ];
  List<String?> method = [
    'tất cả',
    'chiên',
    'xào',
    'hấp',
    'nướng',
  ];
  List<String> categories = [
    'món sáng',
    'món trưa',
    'món chay',
    'món tráng miệng',
    'Hữu Phú'
  ];
  List<String> tags = [];
  List<String> filterSearchTerms({
    required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController =
              TextEditingController();
          bool? isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Bộ lọc tìm kiếm",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            'Thời gian chế biến',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                              color: FoodHubColors.color0B0C0C,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          valueTime.toString() + ' min',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            color: FoodHubColors.color0B0C0C,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.maxFinite,
                      child: CupertinoSlider(
                        min: 0,
                        max: 120,
                        value: _value,
                        divisions: 12,
                        activeColor: FoodHubColors.colorFC6011,
                        thumbColor: FoodHubColors.colorFC6011,
                        onChanged: (value) {
                          setState(
                            () {
                              _value = value;
                              valueTime = _value.toInt();
                              if (value == 0) {
                                _timeToCook = true;
                              } else {
                                _timeToCook = false;
                              }
                            },
                          );
                        },
                        //label: "$_value",
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.02,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Vùng ẩm thực',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: FoodHubColors.colorFFFFFF),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton(
                            dropdownColor: FoodHubColors.colorFFFFFF,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FoodHubColors.color0B0C0C,
                            ),
                            isExpanded: true,
                            value: nameCuisine,
                            onChanged: (newValue) {
                              setState(() {
                                nameCuisine = newValue.toString();
                              });
                            },
                            items: cuisine.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.toString(),
                                  style: TextStyle(
                                    color: FoodHubColors.color0B0C0C,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  ),
                                ),
                              );
                            }).toList(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.04,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Phương thức chế biến',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: FoodHubColors.colorFFFFFF),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton(
                            dropdownColor: FoodHubColors.colorFFFFFF,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FoodHubColors.color0B0C0C,
                            ),
                            isExpanded: true,
                            value: nameMethod,
                            onChanged: (newValue) {
                              setState(() {
                                nameMethod = newValue.toString();
                              });
                            },
                            items: method.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.toString(),
                                  style: TextStyle(
                                    color: FoodHubColors.color0B0C0C,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  ),
                                ),
                              );
                            }).toList(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Danh mục',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    ChipsChoice<String>.multiple(
                      value: tags,
                      onChanged: (val) => setState(() => tags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: categories,
                        value: (i, v) => v,
                        label: (i, v) => v,
                      ),
                      choiceActiveStyle: const C2ChoiceStyle(
                        showCheckmark: false,
                        color: Colors.white,
                        borderColor: Colors.orange,
                        backgroundColor: Colors.deepOrange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      choiceStyle: const C2ChoiceStyle(
                        showCheckmark: false,
                        color: Colors.deepOrange,
                        backgroundColor: Colors.white,
                        borderColor: Colors.deepOrange,
                        borderRadius:
                            BorderRadius.all(const Radius.circular(20)),
                      ),
                      wrapped: true,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.04,
                    ),
                    const Divider(
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                DefaultButton(
                  width: 90,
                  text: "HỦY",
                  press: () {
                    Navigator.of(context).pop();
                  },
                ),
                DefaultButton(
                  width: 150,
                  text: "ÁP DỤNG",
                  press: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    // const int page = 1;
    // const int size = 30;
    // const String sortOption = 'desc';
    // const int role = 1;
    // const String search = "";
    // const String method = "";
    // const String country = "";
    // const String category = "";
    return Scaffold(
      floatingActionButton: _builFloatingButton(),
      body: FloatingSearchBar(
        controller: controller,
        // body: const FloatingSearchBarScrollNotifier(
        //   // child: SearchRecipeScreen(),
        // ),
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        title: Text(
          selectedTerm,
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search and find out...',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        '...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          selectedTerm = controller.query;
                        });
                        controller.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistory
                          .map(
                            (term) => ListTile(
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  putSearchTermFirst(term);
                                  selectedTerm = term;
                                });
                                controller.close();
                              },
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _builFloatingButton() => FloatingActionButton(
        backgroundColor: FoodHubColors.colorFC6011,
        child: const Icon(
          Icons.filter_list,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () async {
          await showInformationDialog(context);
        },
      );
}

// class SearchResultsListView extends StatelessWidget {
//   final String searchTerm;

//   const SearchResultsListView({
//     required this.searchTerm,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (searchTerm == null) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.search,
//               size: 64,
//             ),
//             Text(
//               'Start searching',
//               style: Theme.of(context).textTheme.headline5,
//             )
//           ],
//         ),
//       );
//     }
//     return ListView(
//       children: List.generate(
//         50,
//         (index) => ListTile(
//           title: Text('$searchTerm search resultttttttttt'),
//           subtitle: Text(index.toString()),
//         ),
//       ),
//     );
//   }
// }
