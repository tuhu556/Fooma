import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/social/bloc/interact_post_bloc.dart';
import 'package:foodhub/features/user_profile/model/my_post_entity.dart';
import 'package:foodhub/session/session.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:readmore/readmore.dart';

import '../features/favorite_post/models/favorite_post_entity.dart';
import '../features/my_post/screens/edit_post.dart';
import '../features/social/screens/view_post_screen.dart';
import '../helper/helper.dart';
import 'detail_screen.dart';

class BuildPostScreen extends StatefulWidget {
  final MyPost posts;
  final int index;
  final Function(int)? onTap;
  const BuildPostScreen(
      {Key? key, required this.posts, this.onTap, required this.index})
      : super(key: key);

  @override
  State<BuildPostScreen> createState() => _BuildPostScreenState();
}

class _BuildPostScreenState extends State<BuildPostScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InteractPostBloc(),
      // ..add(const MyFavoriteSocialPost()),
      child: BuildPostView(
        posts: widget.posts,
        onTap: widget.onTap,
        index: widget.index,
      ),
    );
  }
}

class BuildPostView extends StatefulWidget {
  final MyPost posts;
  final int index;
  final Function(int)? onTap;
  const BuildPostView({
    Key? key,
    required this.posts,
    this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  State<BuildPostView> createState() => _BuildPostViewState();
}

class _BuildPostViewState extends State<BuildPostView>
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
  int _current = 0;
  final CarouselController _controller = CarouselController();

  // final DateFormat formatterYMD = DateFormat('yyyy-MM-dd');
  // final DateFormat formatterHMS = DateFormat('HH:mm:ss');
  final DateFormat formatterYMDHMS = DateFormat('yyyy-MM-dd HH:mm:ss');

  String formattedYMD = '';
  String formattedHMS = '';

  DateTime? timeAgo;
  var difference;

  List<FavoritePost> favoritePost = [];
  bool _check = false;
  @override
  bool get wantKeepAlive => true;

  GlobalKey<FormState> _postForm = GlobalKey();
  @override
  void initState() {
    titleOfReport = 'Ảnh không phù hợp';
    difference = timePost(widget.posts.publishedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.posts.postImages
        .map((item) => Container(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    child: Stack(
                  children: <Widget>[
                    Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ],
                )),
              ),
            ))
        .toList();

    return BlocListener<InteractPostBloc, InteractPostState>(
      listener: (context, state) {
        if (state.status == InteractPostStatus.SaveProcessing) {
        } else if (state.status == InteractPostStatus.SaveFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.SaveSuccess) {
        } else if (state.status == InteractPostStatus.UnSaveProcessing) {
        } else if (state.status == InteractPostStatus.UnSaveFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.UnSaveSuccess) {
        } else if (state.status == InteractPostStatus.DeleteProcessing) {
        } else if (state.status == InteractPostStatus.DeleteFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.DeleteSuccess) {
          widget.onTap!(widget.index);
          Helpers.shared.showDialogSuccess(context,
              message: "Xóa bài viết thành công", title: "Xóa");
        } else if (state.status == InteractPostStatus.ReactPostProcessing) {
        } else if (state.status == InteractPostStatus.ReactPostFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.ReactPostSuccess) {
          if (state.code == 200) {
            setState(() {
              widget.posts.totalReact++;
            });
          } else {
            setState(() {
              widget.posts.isReacted = !widget.posts.isReacted;
            });
          }
        } else if (state.status == InteractPostStatus.UnReactPostProcessing) {
        } else if (state.status == InteractPostStatus.UnReactPostFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.UnReactPostSuccess) {
          if (state.code == 200) {
            setState(() {
              widget.posts.totalReact--;
            });
          } else {
            setState(() {
              widget.posts.isReacted = !widget.posts.isReacted;
            });
          }
        } else if (state.status == InteractPostStatus.ReportPostProcessing) {
        } else if (state.status == InteractPostStatus.ReportPostFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.ReportPostSuccess) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                image: NetworkImage(widget.posts.userImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        onTap: widget.posts.userID ==
                                ApplicationSesson.shared.credential?.nameid
                            ? () {
                                Navigator.pushNamed(context, Routes.mainTab,
                                    arguments: 4);
                              }
                            : () {
                                Navigator.pushNamed(
                                    context, Routes.othersUserProfile,
                                    arguments: widget.posts.userID);
                              },
                      ),
                      title: Row(
                        children: [
                          InkWell(
                            child: Text(
                              widget.posts.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: widget.posts.userID ==
                                    ApplicationSesson.shared.credential?.nameid
                                ? () {
                                    Navigator.pushNamed(context, Routes.mainTab,
                                        arguments: 4);
                                  }
                                : () {
                                    Navigator.pushNamed(
                                        context, Routes.othersUserProfile,
                                        arguments: widget.posts.userID);
                                  },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          widget.posts.role == "MANAGER"
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
                                    widget.posts.userID
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
                          .add(const EdgeInsets.only(bottom: 10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.posts.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: FoodHubColors.color0B0C0C,
                            ),
                          ),
                          ReadMoreText(
                            widget.posts.content,
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
                    InkWell(
                      onDoubleTap: widget.posts.isReacted
                          ? () {
                              final bloc = context.read<InteractPostBloc>();
                              bloc.add(UnReactPost(widget.posts.id));
                              setState(() {
                                widget.posts.isReacted =
                                    !widget.posts.isReacted;
                              });
                            }
                          : () {
                              final bloc = context.read<InteractPostBloc>();
                              bloc.add(ReactPost(widget.posts.id));
                              setState(() {
                                widget.posts.isReacted =
                                    !widget.posts.isReacted;
                              });
                            },
                      child: Container(
                        width: double.infinity,
                        child: CarouselSlider(
                          carouselController: _controller,
                          options: CarouselOptions(
                            height: 300,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          items: widget.posts.postImages
                              .map(
                                (item) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ViewPostScreen(
                                          post: widget.posts,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              item.imageUrl,
                                            ),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          widget.posts.postImages.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
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
                                    icon: widget.posts.isReacted
                                        ? Icon(
                                            Icons.favorite,
                                            color: FoodHubColors.colorFC6011,
                                          )
                                        : const Icon(Icons.favorite_border),
                                    iconSize: 30.0,
                                    onPressed: widget.posts.isReacted
                                        ? () {
                                            final bloc = context
                                                .read<InteractPostBloc>();
                                            bloc.add(
                                                UnReactPost(widget.posts.id));
                                            setState(() {
                                              widget.posts.isReacted =
                                                  !widget.posts.isReacted;
                                            });
                                          }
                                        : () {
                                            final bloc = context
                                                .read<InteractPostBloc>();
                                            bloc.add(
                                                ReactPost(widget.posts.id));
                                            setState(() {
                                              widget.posts.isReacted =
                                                  !widget.posts.isReacted;
                                            });
                                          },
                                  ),
                                  Text(
                                    widget.posts.totalReact.toString(),
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
                                          builder: (_) => ViewPostScreen(
                                            post: widget.posts,
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
                                    widget.posts.totalComment.toString(),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: widget.posts.isSaved
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
                              const saveText = "Đã lưu bài viết này";
                              const cancelText = "Bỏ lưu bài viết này";

                              setState(() {
                                widget.posts.isSaved = !widget.posts.isSaved;
                                print(widget.posts.isSaved);
                                if (widget.posts.isSaved) {
                                  final bloc = context.read<InteractPostBloc>();
                                  bloc.add(SavePostSocial(widget.posts.id));
                                  const snackBar = SnackBar(
                                    content: Text(saveText),
                                    duration: Duration(milliseconds: 500),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  final bloc = context.read<InteractPostBloc>();
                                  bloc.add(UnSavePostSocial(widget.posts.id));
                                  const snackBar = SnackBar(
                                    content: Text(cancelText),
                                    duration: Duration(milliseconds: 500),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              });
                            },
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
        ApplicationSesson.shared.credential!.nameid == widget.posts.userID
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditPostScreen(
                    post: widget.posts,
                    index: widget.index,
                    onTap: (int value) {
                      widget.onTap!(index);
                    },
                    pop: 1,
                  ),
                ))
            : reportPost(context);
        break;
      case 1:
        Helpers.shared.showDialogConfirm(
          context,
          title: "Xác nhận",
          message: "Bạn có muốn xóa bài viết này không?",
          okFunction: () {
            final bloc = context.read<InteractPostBloc>();
            bloc.add(DeleteMyPost(id: widget.posts.id));
          },
        );
        break;
    }
  }

  void reportPost(BuildContext context2) {
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
                          "Báo cáo bài viết",
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
                                final bloc = context2.read<InteractPostBloc>();
                                bloc.add(ReportPost(
                                    widget.posts.id,
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
