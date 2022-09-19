import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:readmore/readmore.dart';

import '../config/routes.dart';
import '../constants/color.dart';
import '../features/social/bloc/interact_recipe_bloc.dart';
import '../features/social/screens/view_recipe_screen.dart';
import '../features/upload_recipe/screens/edit_recipe.dart';
import '../helper/helper.dart';
import '../session/session.dart';

class BuildRecipeScreen extends StatefulWidget {
  final Recipe recipe;
  final int index;
  final Function(int)? onTap;
  const BuildRecipeScreen(
      {Key? key, required this.recipe, required this.index, this.onTap})
      : super(key: key);

  @override
  State<BuildRecipeScreen> createState() => _BuildRecipeScreenState();
}

class _BuildRecipeScreenState extends State<BuildRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InteractRecipeBloc(),
      child: BuildRecipeView(
        recipe: widget.recipe,
        index: widget.index,
        onTap: widget.onTap,
      ),
    );
  }
}

class BuildRecipeView extends StatefulWidget {
  final Recipe recipe;
  final int index;
  final Function(int)? onTap;
  const BuildRecipeView(
      {Key? key, required this.recipe, required this.index, this.onTap})
      : super(key: key);

  @override
  State<BuildRecipeView> createState() => _BuildRecipeViewState();
}

class _BuildRecipeViewState extends State<BuildRecipeView>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _descriptionController = new TextEditingController();
  String? validationContent;
  int tab = 0;

  String titleOfReport = '';
  List<String?> report = [
    'Ảnh không phù hợp',
    'Ngôn từ đả kích/gây thù ghét',
    'Spam',
    'Nội dung sai sự thật',
    'Khác'
  ];

  final DateFormat formatterYMDHMS = DateFormat('yyyy-MM-dd HH:mm:ss');

  String formattedYMD = '';
  String formattedHMS = '';

  DateTime? timeAgo;
  var difference;

  List<Recipe> favoriteRecipe = [];
  bool _check = false;

  @override
  bool get wantKeepAlive => true;

  GlobalKey<FormState> _postForm = GlobalKey();

  @override
  void initState() {
    titleOfReport = 'Ảnh không phù hợp';
    difference = timePost(widget.recipe.publishedDate);
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
              widget.recipe.isSaved = !widget.recipe.isSaved;
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
              widget.recipe.isSaved = !widget.recipe.isSaved;
            });
          }
        } else if (state.status == InteractRecipeStatus.DeleteProcessing) {
        } else if (state.status == InteractRecipeStatus.DeleteFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.DeleteSuccess) {
          widget.onTap!(widget.index);
          Helpers.shared.showDialogSuccess(context,
              message: "Xóa bài viết thành công", title: "Xóa");
        } else if (state.status == InteractRecipeStatus.ReactRecipeProcessing) {
        } else if (state.status == InteractRecipeStatus.ReactRecipeFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.ReactRecipeSuccess) {
          if (state.code == 200) {
            setState(() {
              widget.recipe.totalReact++;
            });
          } else {
            setState(() {
              widget.recipe.isReacted = !widget.recipe.isReacted;
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
              widget.recipe.totalReact--;
            });
          } else {
            setState(() {
              widget.recipe.isReacted = !widget.recipe.isReacted;
            });
          }
        } else if (state.status == InteractRecipeStatus.DeleteProcessing) {
        } else if (state.status == InteractRecipeStatus.DeleteFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractRecipeStatus.DeleteSuccess) {
          Helpers.shared.showDialogSuccess(context,
              message: "Xóa bài viết thành công", title: "Xóa");
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
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
                                image: NetworkImage(widget.recipe.userImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        onTap: widget.recipe.userID ==
                                ApplicationSesson.shared.credential?.nameid
                            ? () {
                                Navigator.pushNamed(context, Routes.mainTab,
                                    arguments: 4);
                              }
                            : () {
                                Navigator.pushNamed(
                                    context, Routes.othersUserProfile,
                                    arguments: widget.recipe.userID);
                              },
                      ),
                      title: Row(
                        children: [
                          InkWell(
                            child: Text(
                              widget.recipe.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: widget.recipe.userID ==
                                    ApplicationSesson.shared.credential?.nameid
                                ? () {
                                    Navigator.pushNamed(context, Routes.mainTab,
                                        arguments: 4);
                                  }
                                : () {
                                    Navigator.pushNamed(
                                        context, Routes.othersUserProfile,
                                        arguments: widget.recipe.userID);
                                  },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          widget.recipe.role == "MANAGER"
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset('assets/images/tick.png'))
                              : Container(),
                        ],
                      ),
                      subtitle: Text(
                        difference.toString(),
                      ),
                      trailing: Theme(
                        data: Theme.of(context).copyWith(
                            iconTheme: IconThemeData(
                                color: FoodHubColors.color0B0C0C)),
                        child: PopupMenuButton<int>(
                          color: FoodHubColors.colorFFFFFF,
                          itemBuilder: (context) {
                            return ApplicationSesson
                                        .shared.credential!.nameid ==
                                    widget.recipe.userID
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
                                            style: TextStyle(
                                              color: FoodHubColors.color0B0C0C,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ];
                          },
                          onSelected: (item) =>
                              selectedItem(context, item, widget.index),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .add(const EdgeInsets.only(top: 10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recipe.recipeName,
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
                                widget.recipe.cookingTime.toString() + ' phút',
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              // detailCooking(
                              //   'assets/icons/calories.svg',
                              //   double.parse(widget.recipe.calories
                              //                   .toString()) %
                              //               1 !=
                              //           0
                              //       ? widget.recipe.calories.toString() +
                              //           ' calories'
                              //       : widget.recipe.calories
                              //               .toInt()
                              //               .toString() +
                              //           ' calories',
                              // ),
                              // const SizedBox(
                              //   height: 15,
                              // ),
                              detailCooking(
                                'assets/icons/person.svg',
                                widget.recipe.serves.toString() + ' người',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReadMoreText(
                            widget.recipe.description,
                            style: TextStyle(
                                color: FoodHubColors.color0B0C0C, fontSize: 16),
                            trimLines: 3,
                            colorClickableText: Colors.pink,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Xem thêm',
                            trimExpandedText: 'Thu gọn',
                            moreStyle: TextStyle(
                                fontSize: 15, color: FoodHubColors.colorFC6011),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onDoubleTap: widget.recipe.isReacted
                          ? () {
                              final bloc = context.read<InteractRecipeBloc>();
                              bloc.add(UnReactRecipe(widget.recipe.id));
                              setState(() {
                                widget.recipe.isReacted =
                                    !widget.recipe.isReacted;
                              });
                            }
                          : () {
                              final bloc = context.read<InteractRecipeBloc>();
                              bloc.add(ReactRecipe(widget.recipe.id));
                              setState(() {
                                widget.recipe.isReacted =
                                    !widget.recipe.isReacted;
                              });
                            },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewRecipeScreen(
                              recipe: widget.recipe,
                              timeAgo: difference,
                              index: widget.index,
                              onTap: (int value) {
                                widget.onTap!(widget.index);
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(
                                  widget.recipe.thumbnail,
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: widget.recipe.isReacted
                                        ? Icon(
                                            Icons.favorite,
                                            color: FoodHubColors.colorFC6011,
                                          )
                                        : const Icon(Icons.favorite_border),
                                    iconSize: 30.0,
                                    onPressed: widget.recipe.isReacted
                                        ? () {
                                            final bloc = context
                                                .read<InteractRecipeBloc>();
                                            bloc.add(UnReactRecipe(
                                                widget.recipe.id));
                                            setState(() {
                                              widget.recipe.isReacted =
                                                  !widget.recipe.isReacted;
                                            });
                                          }
                                        : () {
                                            final bloc = context
                                                .read<InteractRecipeBloc>();
                                            bloc.add(
                                                ReactRecipe(widget.recipe.id));
                                            setState(
                                              () {
                                                widget.recipe.isReacted =
                                                    !widget.recipe.isReacted;
                                              },
                                            );
                                          },
                                  ),
                                  Text(
                                    widget.recipe.totalReact.toString(),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20.0),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.chat),
                                    iconSize: 30.0,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ViewRecipeScreen(
                                            recipe: widget.recipe,
                                            timeAgo: difference,
                                            index: widget.index,
                                            onTap: (int value) {
                                              widget.onTap!(widget.index);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    widget.recipe.totalComment.toString(),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          widget.recipe.status == 1
                              ? IconButton(
                                  icon: widget.recipe.isSaved
                                      ? Icon(
                                          Icons.bookmark,
                                          color: FoodHubColors.colorFC6011,
                                        )
                                      : const Icon(
                                          Icons.bookmark_border,
                                          // color: FoodHubColors.colorFC6011,
                                        ),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    const saveText = "Đã lưu công thức này";
                                    const cancelText = "Bỏ lưu công thức này";

                                    if (widget.recipe.isSaved) {
                                      final bloc =
                                          context.read<InteractRecipeBloc>();
                                      bloc.add(
                                          UnSaveRecipeSocial(widget.recipe.id));
                                      const snackBar = SnackBar(
                                        content: Text(cancelText),
                                        duration: Duration(milliseconds: 500),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      final bloc =
                                          context.read<InteractRecipeBloc>();
                                      bloc.add(
                                          SaveRecipeSocial(widget.recipe.id));
                                      const snackBar = SnackBar(
                                        content: Text(saveText),
                                        duration: Duration(milliseconds: 500),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    setState(() {
                                      widget.recipe.isSaved =
                                          !widget.recipe.isSaved;
                                    });
                                  },
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.bookmark_border),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, item, int index) {
    switch (item) {
      case 0:
        ApplicationSesson.shared.credential!.nameid == widget.recipe.userID
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRecipeScreen(
                    recipe: widget.recipe,
                    index: widget.index,
                    onTap: (int value) {
                      widget.onTap!(index);
                    },
                    pop: 1,
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
            bloc.add(DeleteMyRecipe(id: widget.recipe.id));
          },
        );
        break;
    }
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

  void reportRecipe(BuildContext context2) {
    showModalBottomSheet(
      backgroundColor: FoodHubColors.colorF0F5F9,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter mystate) {
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
                                final bloc =
                                    context2.read<InteractRecipeBloc>();
                                bloc.add(ReportRecipe(
                                    widget.recipe.id,
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
              counterText: "",
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
          margin: const EdgeInsets.only(left: 15, top: 5),
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

    final dayAgo = DateTime.now().difference(timeAgo!).inDays;
    final hourAgo = DateTime.now().difference(timeAgo!).inHours;
    final minuteAgo = DateTime.now().difference(timeAgo!).inMinutes;
    final secondAgo = DateTime.now().difference(timeAgo!).inSeconds;
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
