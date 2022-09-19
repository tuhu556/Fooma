import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/social/models/comment_entity.dart';
import 'package:foodhub/features/social/models/method_recipe_entity.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import 'package:foodhub/features/upload_recipe/screens/edit_recipe.dart';
import 'package:foodhub/features/upload_recipe/screens/reup_recipe.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';

import '../../../config/routes.dart';
import '../../../data/data.dart';
import '../../../helper/helper.dart';
import '../../../session/session.dart';
import '../../../widgets/detail_screen.dart';
import '../bloc/interact_recipe_bloc.dart';

class ViewRecipeScreen extends StatefulWidget {
  final Recipe? recipe;
  final String? timeAgo;
  final int? index;
  final Function(int)? onTap;
  const ViewRecipeScreen({
    Key? key,
    this.recipe,
    this.timeAgo,
    this.index,
    this.onTap,
  }) : super(key: key);

  @override
  _ViewRecipeScreenState createState() => _ViewRecipeScreenState();
}

class _ViewRecipeScreenState extends State<ViewRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: widget.recipe!.status == 1
          ? (_) => InteractRecipeBloc()
            // ..add(const MyFavoriteSocialRecipe())
            ..add(ListRecipeComment(widget.recipe!.id, 1))
            ..add(GetMethodRecipe(widget.recipe!.id))
          : (_) =>
              InteractRecipeBloc()..add(GetMethodRecipe(widget.recipe!.id)),
      child: ViewRecipeView(
        recipe: widget.recipe!,
        timeAgo: widget.timeAgo!,
        onTap: widget.onTap,
        index: widget.index!,
      ),
    );
  }
}

class ViewRecipeView extends StatefulWidget {
  final Recipe? recipe;
  final String? timeAgo;
  final int? index;
  final Function(int)? onTap;
  const ViewRecipeView(
      {Key? key, this.recipe, this.timeAgo, this.index, this.onTap})
      : super(key: key);

  @override
  State<ViewRecipeView> createState() => _ViewRecipeViewState();
}

class _ViewRecipeViewState extends State<ViewRecipeView> {
  final GlobalKey<FormState> _commentKey = GlobalKey();
  TextEditingController _contentController = new TextEditingController();
  TextEditingController _editContentController = new TextEditingController();

  final GlobalKey<FormState> _contentForm = GlobalKey();
  final DateFormat formatterYMDHMS = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  String formattedYMD = '';
  String formattedHMS = '';

  DateTime? timeAgo;
  var difference;
  int _current = 0;
  String? validationContent;
  final CarouselController _controller = CarouselController();
  TextEditingController _descriptionController = new TextEditingController();
  String titleOfReport = '';
  List<String?> report = [
    'Ảnh không phù hợp',
    'Ngôn từ đả kích/gây thù ghét',
    'Spam',
    'Nội dung sai sự thật',
    'Khác'
  ];

  List<Comment> recipeComment = [];
  int totalPage = 1;

  int page = 1;

  List<Method> methodRecipe = [];

  List<Recipe> favoriteRecipe = [];
  bool _check = false;

  GlobalKey<FormState> _postForm = GlobalKey();

  @override
  void initState() {
    titleOfReport = 'Ảnh không phù hợp';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InteractRecipeBloc, InteractRecipeState>(
      listener: (context, state) {
        if (state.status == InteractRecipeStatus.SaveProcessing) {
        } else if (state.status == InteractRecipeStatus.SaveFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.SaveSuccess) {
          if (state.code == 200) {
          } else {
            setState(() {
              widget.recipe!.isSaved = !widget.recipe!.isSaved;
            });
          }
        } else if (state.status == InteractRecipeStatus.UnSaveProcessing) {
        } else if (state.status == InteractRecipeStatus.UnSaveFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.UnSaveSuccess) {
          if (state.code == 200) {
          } else {
            setState(() {
              widget.recipe!.isSaved = !widget.recipe!.isSaved;
            });
          }
        } else if (state.status == InteractRecipeStatus.DeleteProcessing) {
        } else if (state.status == InteractRecipeStatus.DeleteFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.DeleteSuccess) {
          if (widget.index != 987456123) {
            widget.onTap!(widget.index!);
          }
          Helpers.shared.showDialogSuccess(context,
              message: "Xóa bài viết thành công", title: "Xóa", okFunction: () {
            Navigator.pop(context);
          });
        } else if (state.status == InteractRecipeStatus.ListCommentProcessing) {
        } else if (state.status == InteractRecipeStatus.ListCommentFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.ListCommentSuccess) {
          for (int i = 0; i < state.commentRecipe!.comment.length; i++) {
            setState(() {
              recipeComment.add(state.commentRecipe!.comment[i]);
            });
          }
          setState(() {
            totalPage = state.commentRecipe!.totalPage;
          });
        } else if (state.status == InteractRecipeStatus.CommentProcessing) {
        } else if (state.status == InteractRecipeStatus.CommentFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.CommentSuccess) {
          setState(() {
            recipeComment.clear();
            page = 1;
          });
          final bloc = context.read<InteractRecipeBloc>();
          bloc.add(ListRecipeComment(widget.recipe!.id, 1));
          setState(() {
            widget.recipe!.totalComment++;
          });
        } else if (state.status ==
            InteractRecipeStatus.DeleteCommentProcessing) {
        } else if (state.status == InteractRecipeStatus.DeleteCommentFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.DeleteCommentSuccess) {
          setState(() {
            widget.recipe!.totalComment--;
          });
        } else if (state.status == InteractRecipeStatus.EditCommentProcessing) {
        } else if (state.status == InteractRecipeStatus.EditCommentFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.EditCommentSuccess) {
        } else if (state.status == InteractRecipeStatus.ReactRecipeProcessing) {
        } else if (state.status == InteractRecipeStatus.ReactRecipeFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.ReactRecipeSuccess) {
          if (state.code == 200) {
            setState(() {
              widget.recipe!.totalReact++;
            });
          } else {
            setState(() {
              widget.recipe!.isReacted = !widget.recipe!.isReacted;
            });
          }
        } else if (state.status ==
            InteractRecipeStatus.UnReactRecipeProcessing) {
        } else if (state.status == InteractRecipeStatus.UnReactRecipeFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.UnReactRecipeSuccess) {
          if (state.code == 200) {
            setState(() {
              widget.recipe!.totalReact--;
            });
          } else {
            setState(() {
              widget.recipe!.isReacted = !widget.recipe!.isReacted;
            });
          }
        } else if (state.status ==
            InteractRecipeStatus.MethodRecipeProcessing) {
        } else if (state.status == InteractRecipeStatus.MethodRecipeFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.MethodRecipeSuccess) {
          for (int i = 0; i < state.methodRecipe!.method.length; i++) {
            setState(() {
              methodRecipe.add(state.methodRecipe!.method[i]);
            });
          }
        } else if (state.status ==
            InteractRecipeStatus.ReportRecipeProcessing) {
        } else if (state.status == InteractRecipeStatus.ReportRecipeFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.ReportRecipeSuccess) {
          setState(() {
            _descriptionController.clear();
            titleOfReport == report[0];
          });
          Navigator.pop(context);
          Helpers.shared.showDialogSuccess(context,
              message: "Cảm ơn bạn đã gửi báo cáo",
              subMessage:
                  "Chúng tôi sẽ xem xét báo cáo và thông báo cho bạn về quyết định của mình.");
        }
      },
      child: KeyboardDismisser(
        child: Scaffold(
          backgroundColor: FoodHubColors.colorF0F5F9,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back_ios),
                                      iconSize: 30.0,
                                      color: Colors.black,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: ListTile(
                                      leading: GestureDetector(
                                        child: Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black45,
                                                offset: Offset(0, 2),
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            child: ClipOval(
                                              child: Image(
                                                height: 50.0,
                                                width: 50.0,
                                                image: NetworkImage(widget
                                                    .recipe!.userImageUrl),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: widget.recipe!.userID ==
                                                ApplicationSesson
                                                    .shared.credential?.nameid
                                            ? () {
                                                Navigator.pushNamed(
                                                    context, Routes.mainTab,
                                                    arguments: 4);
                                              }
                                            : () {
                                                Navigator.pushNamed(context,
                                                    Routes.othersUserProfile,
                                                    arguments:
                                                        widget.recipe!.userID);
                                              },
                                      ),
                                      title: Row(
                                        children: [
                                          InkWell(
                                            child: Text(
                                              widget.recipe!.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onTap: widget.recipe!.userID ==
                                                    ApplicationSesson.shared
                                                        .credential?.nameid
                                                ? () {
                                                    Navigator.pushNamed(
                                                        context, Routes.mainTab,
                                                        arguments: 4);
                                                  }
                                                : () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        Routes
                                                            .othersUserProfile,
                                                        arguments: widget
                                                            .recipe!.userID);
                                                  },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          widget.recipe!.role == "MANAGER"
                                              ? Container(
                                                  height: 20,
                                                  width: 20,
                                                  child: Image.asset(
                                                      'assets/images/tick.png'))
                                              : Container(),
                                        ],
                                      ),
                                      subtitle: Text(widget.timeAgo!),
                                      trailing: widget.recipe!.status == 1 ||
                                              widget.recipe!.status == 2
                                          ? Theme(
                                              data: Theme.of(context).copyWith(
                                                  iconTheme: IconThemeData(
                                                      color: FoodHubColors
                                                          .color0B0C0C)),
                                              child: PopupMenuButton<int>(
                                                color:
                                                    FoodHubColors.colorFFFFFF,
                                                itemBuilder: (context) {
                                                  return ApplicationSesson
                                                              .shared
                                                              .credential!
                                                              .nameid ==
                                                          widget.recipe!.userID
                                                      ? [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.edit,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  "Chỉnh sửa",
                                                                  style:
                                                                      TextStyle(
                                                                    color: FoodHubColors
                                                                        .color0B0C0C,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          PopupMenuItem<int>(
                                                            value: 1,
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.delete,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  "Xóa",
                                                                  style:
                                                                      TextStyle(
                                                                    color: FoodHubColors
                                                                        .color0B0C0C,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]
                                                      : [
                                                          PopupMenuItem<int>(
                                                            value: 0,
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.edit,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  "Báo cáo",
                                                                  style:
                                                                      TextStyle(
                                                                    color: FoodHubColors
                                                                        .color0B0C0C,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ];
                                                },
                                                onSelected: (item) =>
                                                    selectedItem(context, item,
                                                        widget.index!),
                                              ),
                                            )
                                          : Container(
                                              height: 3,
                                              width: 3,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return DetailScreen(
                                      image: widget.recipe!.thumbnail,
                                    );
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: 400,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            widget.recipe!.thumbnail,
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.recipe!.recipeName,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: FoodHubColors.color0B0C0C),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        detailCooking(
                                            'assets/icons/time_to_cook.svg',
                                            widget.recipe!.cookingTime
                                                    .toString() +
                                                ' phút'),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        // detailCooking(
                                        //     'assets/icons/calories.svg',
                                        //     double.parse(widget.recipe!.calories
                                        //                     .toString()) %
                                        //                 1 !=
                                        //             0
                                        //         ? widget.recipe!.calories
                                        //                 .toString() +
                                        //             ' calories'
                                        //         : widget.recipe!.calories
                                        //                 .toInt()
                                        //                 .toString() +
                                        //             ' calories'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        detailCooking(
                                            'assets/icons/person.svg',
                                            widget.recipe!.serves.toString() +
                                                ' người'),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Nguồn gốc:',
                                      style: TextStyle(
                                        color: FoodHubColors.color0B0C0C,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.recipe!.originName,
                                      style: TextStyle(
                                        color: FoodHubColors.color0B0C0C,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Phương thức chế biến:',
                                      style: TextStyle(
                                        color: FoodHubColors.color0B0C0C,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.recipe!.cookingMethodName,
                                      style: TextStyle(
                                        color: FoodHubColors.color0B0C0C,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Danh mục:',
                                      style: TextStyle(
                                        color: FoodHubColors.color0B0C0C,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: List.generate(
                                          widget
                                              .recipe!
                                              .manyToManyRecipeCategories
                                              .length,
                                          (i) => Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(
                                                  widget
                                                      .recipe!
                                                      .manyToManyRecipeCategories[
                                                          i]
                                                      .recipeCategoryName,
                                                  style: TextStyle(
                                                    color: FoodHubColors
                                                        .color0B0C0C,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Mô tả:',
                                      style: TextStyle(
                                        color: FoodHubColors.color0B0C0C,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ReadMoreText(
                                      widget.recipe!.description,
                                      style: TextStyle(
                                        color: FoodHubColors.color52616B,
                                        fontSize: 16,
                                      ),
                                      trimLines: 3,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Xem thêm',
                                      trimExpandedText: ' Thu gọn',
                                      moreStyle: TextStyle(
                                          fontSize: 16,
                                          color: FoodHubColors.colorFC6011),
                                      lessStyle: TextStyle(
                                          fontSize: 16,
                                          color: FoodHubColors.colorFC6011),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Nguyên liệu:',
                                      style: TextStyle(
                                        color: FoodHubColors.color0B0C0C,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ingredientField(
                                          double.parse(widget.recipe!.calories
                                                          .toString()) %
                                                      1 !=
                                                  0
                                              ? widget.recipe!.ingredient[index]
                                                      .quantity
                                                      .toString() +
                                                  " " +
                                                  widget.recipe!
                                                      .ingredient[index].unit
                                              : widget.recipe!.ingredient[index]
                                                      .quantity
                                                      .toInt()
                                                      .toString() +
                                                  " " +
                                                  widget.recipe!
                                                      .ingredient[index].unit,
                                          widget.recipe!.ingredient[index]
                                              .ingredientName,
                                          widget
                                              .recipe!.ingredient[index].isMain,
                                        );
                                      },
                                      itemCount:
                                          widget.recipe!.ingredient.length,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Cách làm:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: FoodHubColors.color0B0C0C,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: methodRecipe.length,
                                      itemBuilder: (context, index) {
                                        return stepToCook(
                                          methodRecipe[index]
                                              .recipeMethodImages[0]
                                              .imageUrl,
                                          'Bước ' + (index + 1).toString(),
                                          methodRecipe[index].content,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              widget.recipe!.status == 1
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              widget.recipe!.status == 1
                                                  ? IconButton(
                                                      icon: widget
                                                              .recipe!.isReacted
                                                          ? Icon(
                                                              Icons.favorite,
                                                              color: FoodHubColors
                                                                  .colorFC6011,
                                                            )
                                                          : const Icon(Icons
                                                              .favorite_border),
                                                      iconSize: 30.0,
                                                      onPressed:
                                                          widget.recipe!
                                                                  .isReacted
                                                              ? () {
                                                                  final bloc =
                                                                      context.read<
                                                                          InteractRecipeBloc>();
                                                                  bloc.add(UnReactRecipe(
                                                                      widget
                                                                          .recipe!
                                                                          .id));
                                                                  setState(() {
                                                                    widget.recipe!
                                                                            .isReacted =
                                                                        !widget
                                                                            .recipe!
                                                                            .isReacted;
                                                                  });
                                                                }
                                                              : () {
                                                                  final bloc =
                                                                      context.read<
                                                                          InteractRecipeBloc>();
                                                                  bloc.add(ReactRecipe(
                                                                      widget
                                                                          .recipe!
                                                                          .id));
                                                                  setState(() {
                                                                    widget.recipe!
                                                                            .isReacted =
                                                                        !widget
                                                                            .recipe!
                                                                            .isReacted;
                                                                  });
                                                                },
                                                    )
                                                  : const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Icon(Icons
                                                          .favorite_border),
                                                    ),
                                              Text(
                                                widget.recipe!.totalReact
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 20.0),
                                              Row(
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons.chat,
                                                    size: 30.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    widget.recipe!.totalComment
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          widget.recipe!.status == 1
                                              ? IconButton(
                                                  icon: widget.recipe!.isSaved
                                                      ? Icon(
                                                          Icons.bookmark,
                                                          color: FoodHubColors
                                                              .colorFC6011,
                                                        )
                                                      : const Icon(
                                                          Icons.bookmark_border,
                                                          // color: FoodHubColors.colorFC6011,
                                                        ),
                                                  iconSize: 30.0,
                                                  onPressed: () {
                                                    const saveText =
                                                        "Đã lưu công thức này";
                                                    const cancelText =
                                                        "Bỏ lưu công thức này";

                                                    if (widget
                                                        .recipe!.isSaved) {
                                                      final bloc = context.read<
                                                          InteractRecipeBloc>();
                                                      bloc.add(
                                                          UnSaveRecipeSocial(
                                                              widget
                                                                  .recipe!.id));
                                                      const snackBar = SnackBar(
                                                        content:
                                                            Text(cancelText),
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    } else {
                                                      final bloc = context.read<
                                                          InteractRecipeBloc>();
                                                      bloc.add(SaveRecipeSocial(
                                                          widget.recipe!.id));
                                                      const snackBar = SnackBar(
                                                        content: Text(saveText),
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                    setState(() {
                                                      widget.recipe!.isSaved =
                                                          !widget
                                                              .recipe!.isSaved;
                                                    });
                                                  },
                                                )
                                              : const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                      Icons.bookmark_border),
                                                ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    widget.recipe!.status == 1 || widget.recipe!.status == 2
                        ? Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: recipeComment.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return _buildComment(index);
                                    },
                                  ),
                                  page < totalPage
                                      ? TextButton(
                                          onPressed: () {
                                            setState(() {
                                              page++;
                                            });
                                            final bloc = context
                                                .read<InteractRecipeBloc>();
                                            bloc.add(ListRecipeComment(
                                                widget.recipe!.id, page));
                                          },
                                          child: Text(
                                            "Xem thêm bình luận...",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    FoodHubColors.colorFC6011),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: FoodHubColors.colorFFFFFF,
                                borderRadius: BorderRadius.circular(25)),
                            child: (Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Lý do từ chối: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: FoodHubColors.colorFC6011),
                                    ),
                                    TextSpan(
                                      text: widget.recipe!.reason,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: FoodHubColors.color0B0C0C),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: widget.recipe!.status == 1
              ? Transform.translate(
                  offset: Offset(
                      0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    // height: 100.0,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, -2),
                          blurRadius: 6.0,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        key: _commentKey,
                        child: TextFormField(
                          enabled: widget.recipe!.status == 1 ? true : false,
                          controller: _contentController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vui lòng nhập bình luận của bạn";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            contentPadding: const EdgeInsets.all(20.0),
                            hintText: 'Thêm bình luận',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                width: 48.0,
                                height: 48.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(0, 2),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  child: ClipOval(
                                    child: Image(
                                      height: 48.0,
                                      width: 48.0,
                                      image: NetworkImage(Data.avatar),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            suffixIcon: Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 70.0,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: FoodHubColors.colorFC6011,
                                onPressed: () {
                                  if (_commentKey.currentState!.validate()) {
                                    final bloc =
                                        context.read<InteractRecipeBloc>();
                                    bloc.add(CommentRecipe(widget.recipe!.id,
                                        _contentController.text));
                                    setState(() {
                                      _contentController.clear();
                                    });

                                    Helpers.shared.hideKeyboard(context);
                                  }
                                },
                                child: const Icon(
                                  Icons.send,
                                  size: 25.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : widget.recipe!.status == 3
                  ? TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: FoodHubColors.colorFC6011,
                        shape: const RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.pushNamed(context, Routes.reupRecipe,
                        //     arguments: widget.recipe);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReupRecipeScreen(
                                recipe: widget.recipe,
                                index: widget.index,
                                onTap: (int value) {
                                  widget.onTap!(value);
                                }),
                          ),
                        );
                      },
                      child: Text(
                        "ĐĂNG LẠI CÔNG THỨC",
                        style: TextStyle(color: FoodHubColors.colorFFFFFF),
                      ))
                  : null,
        ),
      ),
    );
  }

  Widget ingredientField(String weight, String name, bool isMain) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(
              Icons.circle,
              size: 7,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            weight,
            style: TextStyle(
              color: FoodHubColors.color0B0C0C,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            name,
            style: TextStyle(
              color: isMain
                  ? FoodHubColors.colorFC6011
                  : FoodHubColors.color0B0C0C,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50.0,
                width: 50.0,
                image: NetworkImage(recipeComment[index].userImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          recipeComment[index].name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadMoreText(
              recipeComment[index].content,
              style: TextStyle(
                color: FoodHubColors.color52616B,
                fontSize: 16,
              ),
              trimLines: 3,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Xem thêm',
              trimExpandedText: ' Thu gọn',
              moreStyle:
                  TextStyle(fontSize: 16, color: FoodHubColors.colorFC6011),
              lessStyle:
                  TextStyle(fontSize: 16, color: FoodHubColors.colorFC6011),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              timePost(recipeComment[index].createDate),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: ApplicationSesson.shared.credential!.nameid ==
                recipeComment[index].userID
            ? Theme(
                data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(color: FoodHubColors.color0B0C0C)),
                child: PopupMenuButton<int>(
                  color: FoodHubColors.colorFFFFFF,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Chỉnh sửa",
                              style: TextStyle(
                                color: FoodHubColors.color0B0C0C,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Xóa",
                              style: TextStyle(
                                color: FoodHubColors.color0B0C0C,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (item) => selectedItemComment(
                      context, item, index, recipeComment[index].content),
                ),
              )
            : null,
      ),
    );
  }

  void selectedItemComment(BuildContext context, item, index, comment) {
    setState(() {
      _editContentController.text = comment;
    });
    switch (item) {
      case 0:
        Helpers.shared.showDialogEditContent(
          context,
          title: "Chỉnh sửa bình luận",
          widget: Form(
            key: _contentForm,
            child: Helpers.shared.textFieldContent(
              context,
              controllerText: _editContentController,
              suffixIcon: IconButton(
                onPressed: () {
                  _editContentController.clear();
                },
                icon: const Icon(
                  Icons.cancel,
                ),
              ),
              colorBox: FoodHubColors.colorE1E4E8,
            ),
          ),
          okFunction: () {
            if (_contentForm.currentState!.validate()) {
              final bloc = context.read<InteractRecipeBloc>();
              bloc.add(EditCommentRecipe(
                  recipeComment[index].id, _editContentController.text));
              setState(
                () {
                  recipeComment[index].content = _editContentController.text;
                },
              );
              Navigator.pop(context);
            }
          },
        );
        break;
      case 1:
        Helpers.shared.showDialogConfirm(context,
            message: 'Bạn có muốn xóa bình luận này hay không?',
            title: 'Xóa', okFunction: () {
          final bloc = context.read<InteractRecipeBloc>();
          bloc.add(DeleteCommentRecipe(recipeComment[index].id));
          setState(() {
            recipeComment.removeAt(index);
          });
        });
        break;
    }
  }

  Widget stepToCook(String image, String step, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: FoodHubColors.colorFC6011,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              step,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: FoodHubColors.colorFFFFFF,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(
                image: image,
              );
            }));
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ReadMoreText(
          description,
          style: TextStyle(color: FoodHubColors.color0B0C0C, fontSize: 16),
          trimLines: 3,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Xem thêm',
          trimExpandedText: ' Thu gọn',
          moreStyle: TextStyle(fontSize: 16, color: FoodHubColors.colorFC6011),
          lessStyle: TextStyle(fontSize: 16, color: FoodHubColors.colorFC6011),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget hashtagCooking(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: FoodHubColors.colorF0F5F9,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: FoodHubColors.color52616B,
          ),
        ),
      ),
    );
  }

  Widget detailCooking(String image, String text) {
    return Row(
      children: [
        SvgPicture.asset(
          image,
          height: 15,
          width: 15,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: FoodHubColors.color0B0C0C,
          ),
        )
      ],
    );
  }

  void selectedItem(BuildContext context, item, int index) {
    switch (item) {
      case 0:
        ApplicationSesson.shared.credential!.nameid == widget.recipe!.userID
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRecipeScreen(
                    recipe: widget.recipe,
                    index: widget.index,
                    onTap: (int value) {
                      widget.onTap!(index);
                    },
                    pop: 2,
                  ),
                ))
            : reportRecipe(context);
        break;
      case 1:
        Helpers.shared.showDialogConfirm(
          context,
          title: "Xác nhận",
          message: "Bạn có muốn xóa bài viết này không?",
          okFunction: () {
            final bloc = context.read<InteractRecipeBloc>();
            bloc.add(DeleteMyRecipe(id: widget.recipe!.id));
          },
        );
        break;
    }
  }

  void reportRecipe(_) {
    showModalBottomSheet(
      backgroundColor: FoodHubColors.colorF0F5F9,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (_, StateSetter mystate) {
          return KeyboardDismisser(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _postForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Báo cáo công thức",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: FoodHubColors.color0B0C0C,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: FoodHubColors.colorFFFFFF),
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: DropdownButton(
                                dropdownColor: FoodHubColors.colorFFFFFF,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: FoodHubColors.color0B0C0C,
                                ),
                                isExpanded: true,
                                value: titleOfReport,
                                onChanged: (newValue) {
                                  mystate(() {
                                    titleOfReport = newValue.toString();
                                  });
                                },
                                items: report.map((e) {
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
                        const SizedBox(
                          height: 20,
                        ),
                        textInputDescription(mystate),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: FoodHubColors.colorFC6011,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              if (_postForm.currentState!.validate()) {
                                final bloc = context.read<InteractRecipeBloc>();
                                bloc.add(ReportRecipe(
                                    widget.recipe!.id,
                                    titleOfReport,
                                    _descriptionController.text));
                              }
                            },
                            child: Text(
                              "GỬI",
                              style: TextStyle(
                                fontSize: 16,
                                color: FoodHubColors.colorFFFFFF,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget textInputDescription(mystate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.7,
          child: Text(
            'Nội dung',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              color: FoodHubColors.color0B0C0C,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FoodHubColors.colorFFFFFF),
          child: TextFormField(
            style: TextStyle(color: FoodHubColors.color0B0C0C, fontSize: 16),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(15),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorStyle: TextStyle(color: Colors.transparent, height: 0),
            ),
            controller: _descriptionController,
            validator: (value) {
              if (value!.isEmpty) {
                mystate(() {
                  validationContent = "Vui lòng nhập nội dung";
                });
                return "Vui lòng nhập nội dung";
              } else {
                mystate(() {
                  validationContent = "";
                });
                return null;
              }
            },
            keyboardType: TextInputType.multiline,
            maxLines: 5,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, top: 5, bottom: 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              validationContent ?? "",
              style: TextStyle(color: FoodHubColors.colorCC0000, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  String timePost(String publishedDate) {
    var parsedDate = DateTime.parse(publishedDate);

    formattedYMD = formatterYMDHMS.format(parsedDate);
    timeAgo = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(formattedYMD);

    final dayAgo = DateTime.now()
        // .add(const Duration(seconds: 1))
        .difference(timeAgo!)
        .inDays;
    final hourAgo = DateTime.now()
        // .add(const Duration(seconds: 1))
        .difference(timeAgo!)
        .inHours;
    final minuteAgo = DateTime.now()
        // .add(const Duration(seconds: 1))
        .difference(timeAgo!)
        .inMinutes;
    final secondAgo = DateTime.now()
        // .add(const Duration(seconds: 1))
        .difference(timeAgo!)
        .inSeconds;
    if (dayAgo <= 0) {
      if (hourAgo <= 0) {
        if (minuteAgo <= 0) {
          difference = secondAgo.toString() + " giây trước";
        } else {
          difference = minuteAgo.toString() + " phút trước";
        }
      } else {
        difference = hourAgo.toString() + " giờ trước";
      }
    } else {
      if (dayAgo >= 30) {
        difference = (dayAgo / 30).toInt().toString() + " tháng trước";
      } else {
        difference = dayAgo.toString() + " ngày trước";
      }
    }
    return difference;
  }
}
