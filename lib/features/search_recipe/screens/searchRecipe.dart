import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/home/bloc/recipe_app/recipe_app_bloc.dart';
import 'package:foodhub/features/search_recipe/model/recipeSuggest_entity.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class SearchRecipeScreen extends StatefulWidget {
  const SearchRecipeScreen({Key? key}) : super(key: key);

  @override
  State<SearchRecipeScreen> createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<SearchRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => RecipeAppBloc(),
      ),
    ], child: const SearchRecipeView());
  }
}

class SearchRecipeView extends StatefulWidget {
  const SearchRecipeView({Key? key}) : super(key: key);

  @override
  State<SearchRecipeView> createState() => _SearchRecipeViewState();
}

class _SearchRecipeViewState extends State<SearchRecipeView> {
  bool _onTap = false;
  final controller = TextEditingController();
  String search = "";
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodHubColors.colorF0F5F9,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: FoodHubColors.colorF0F5F9,
        leading: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.close,
              color: FoodHubColors.color0B0C0C,
              size: 33,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Tìm kiếm",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: FoodHubColors.color0B0C0C),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RecipeAppBloc, RecipeAppState>(
            listener: (context, state) {
              print(state.status);
              if (state.status == RecipeAppStatus.Processing) {
                print("Processing");
              } else if (state.status == RecipeAppStatus.Failed) {
                print("Failed");
              } else if (state.status == RecipeAppStatus.Success) {
                print("Success");
              }
            },
          ),
        ],
        child: KeyboardDismisser(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    child: _searchField(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchField() => TypeAheadFormField<recipeSuggestModel?>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        onSubmitted: (value) {
          Navigator.pushNamed(context, Routes.resultSearch,
              arguments: {"search": value});
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixIcon: Icon(
            Icons.search,
            size: 35,
            color: FoodHubColors.colorFC6011,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        color: Colors.white,
        elevation: 4.0,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      debounceDuration: const Duration(milliseconds: 400),
      noItemsFoundBuilder: (context) => Container(
            height: 50,
            child: const Center(
                child: Text(
              "",
              style: TextStyle(fontSize: 16),
            )),
          ),
      onSuggestionSelected: (recipeSuggestModel? suggestion) {
        controller.text = suggestion!.recipeName;
        Navigator.pushNamed(context, Routes.recipeDetail,
            arguments: {'recipeId': suggestion.id});
      },
      getImmediateSuggestions: true,
      suggestionsCallback: RecipeSuggestionService.getRecipeSuggestions,
      itemBuilder: (context, recipeSuggestModel? suggestion) {
        final recipe = suggestion!;
        return ListTile(
          leading: Image.network(
            recipe.thumbnail,
            width: 60,
          ),
          title: Text(recipe.recipeName),
        );
      });
}
