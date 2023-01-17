import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/my_post/screens/edit_post.dart';
import 'package:foodhub/features/my_post/screens/reup_post.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';

import '../../../config/routes.dart';
import '../../../data/data.dart';
import '../../../helper/helper.dart';
import '../../../session/session.dart';
import '../../../widgets/detail_screen.dart';
import '../../favorite_post/models/favorite_post_entity.dart';
import '../../user_profile/model/my_post_entity.dart';
import '../bloc/interact_post_bloc.dart';
import '../models/comment_entity.dart';

class ViewPostScreen extends StatefulWidget {
  final MyPost? post;
  final String? timeAgo;
  final int? index;
  final Function(int)? onTap;

  const ViewPostScreen({
    Key? key,
    this.post,
    this.timeAgo,
    this.onTap,
    this.index,
  }) : super(key: key);

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: widget.post!.status == 1
          ? (_) => InteractPostBloc()
            // ..add(const MyFavoriteSocialPost())
            ..add(ListPostComment(widget.post!.id, 1))
          : (_) => InteractPostBloc(),
      child: ViewPostView(
        post: widget.post!,
        timeAgo: widget.timeAgo!,
        onTap: widget.onTap,
        index: widget.index!,
      ),
    );
  }
}

class ViewPostView extends StatefulWidget {
  final MyPost post;
  final String timeAgo;
  final int? index;
  final Function(int)? onTap;
  const ViewPostView(
      {Key? key,
      required this.post,
      required this.timeAgo,
      this.onTap,
      this.index})
      : super(key: key);

  @override
  State<ViewPostView> createState() => _ViewPostViewState();
}

class _ViewPostViewState extends State<ViewPostView> {
  String? validationContent;
  TextEditingController _descriptionController = new TextEditingController();
  String titleOfReport = '';
  List<String?> report = [
    'Ảnh không phù hợp',
    'Ngôn từ đả kích/gây thù ghét',
    'Spam',
    'Nội dung sai sự thật',
    'Khác'
  ];

  final DateFormat formatterYMDHMS = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  String formattedYMD = '';
  String formattedHMS = '';
  DateTime? timeAgo;

  var difference;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  List<FavoritePost> favoritePost = [];
  List<Comment> postComment = [];
  bool _check = false;
  int page = 1;
  int totalPage = 1;

  final GlobalKey<FormState> _commentKey = GlobalKey();
  GlobalKey<FormState> _postForm = GlobalKey();

  TextEditingController _contentController = new TextEditingController();
  TextEditingController _editContentController = new TextEditingController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  GlobalKey _refresherKey = GlobalKey();
  bool enablePullUp = true;

  final GlobalKey<FormState> _contentForm = GlobalKey();
  @override
  void initState() {
    titleOfReport = 'Ảnh không phù hợp';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          if (widget.index != 987456123) {
            widget.onTap!(widget.index!);
          }
          Helpers.shared.showDialogSuccess(context,
              message: "Xóa bài viết thành công", title: "Xóa", okFunction: () {
            Navigator.pop(context);
          });
        } else if (state.status == InteractPostStatus.ListCommentProcessing) {
        } else if (state.status == InteractPostStatus.ListCommentFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.ListCommentSuccess) {
          for (int i = 0; i < state.commentPost!.comment.length; i++) {
            setState(() {
              postComment.add(state.commentPost!.comment[i]);
            });
          }
          setState(() {
            totalPage = state.commentPost!.totalPage;
          });
        } else if (state.status == InteractPostStatus.CommentProcessing) {
        } else if (state.status == InteractPostStatus.CommentFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.CommentSuccess) {
          setState(() {
            postComment.clear();
            page = 1;
          });
          final bloc = context.read<InteractPostBloc>();
          bloc.add(ListPostComment(widget.post.id, 1));
          setState(() {
            widget.post.totalComment++;
          });
        } else if (state.status == InteractPostStatus.DeleteCommentProcessing) {
        } else if (state.status == InteractPostStatus.DeleteCommentFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.DeleteCommentSuccess) {
          setState(() {
            widget.post.totalComment--;
          });
        } else if (state.status == InteractPostStatus.EditCommentProcessing) {
        } else if (state.status == InteractPostStatus.EditCommentFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.EditCommentSuccess) {
        } else if (state.status == InteractPostStatus.ReactPostProcessing) {
        } else if (state.status == InteractPostStatus.ReactPostFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.ReactPostSuccess) {
          if (state.code == 200) {
            setState(() {
              widget.post.totalReact++;
            });
          } else {
            setState(() {
              widget.post.isReacted = !widget.post.isReacted;
            });
          }
        } else if (state.status == InteractPostStatus.UnReactPostProcessing) {
        } else if (state.status == InteractPostStatus.UnReactPostFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == InteractPostStatus.UnReactPostSuccess) {
          if (state.code == 200) {
            setState(() {
              widget.post.totalReact--;
            });
          } else {
            setState(() {
              widget.post.isReacted = !widget.post.isReacted;
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
                                              const BoxShadow(
                                                color: Colors.black45,
                                                offset: const Offset(0, 2),
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            child: ClipOval(
                                              child: Image(
                                                height: 50.0,
                                                width: 50.0,
                                                image: NetworkImage(
                                                    widget.post.userImageUrl),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: widget.post.userID ==
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
                                                        widget.post.userID);
                                              },
                                      ),
                                      title: Row(
                                        children: [
                                          InkWell(
                                            child: Text(
                                              widget.post.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onTap: widget.post.userID ==
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
                                                        arguments:
                                                            widget.post.userID);
                                                  },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          widget.post.role == "MANAGER"
                                              ? Container(
                                                  height: 20,
                                                  width: 20,
                                                  child: Image.asset(
                                                      'assets/images/tick.png'))
                                              : Container(),
                                        ],
                                      ),
                                      subtitle: Text(widget.timeAgo),
                                      trailing: widget.post.status == 1 ||
                                              widget.post.status == 2
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
                                                          widget.post.userID
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
                                              height: 5,
                                              width: 5,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                // height: 400,
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
                                  items: widget.post.postImages
                                      .map(
                                        (item) => InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return DetailScreen(
                                                image: item.imageUrl,
                                              );
                                            }));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: widget.post.postImages
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _controller.animateToPage(entry.key),
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black)
                                              .withOpacity(_current == entry.key
                                                  ? 0.9
                                                  : 0.4)),
                                    ),
                                  );
                                }).toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.post.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: FoodHubColors.color0B0C0C,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ReadMoreText(
                                      widget.post.content,
                                      style: TextStyle(
                                          color: FoodHubColors.color0B0C0C,
                                          fontSize: 16),
                                      trimLines: 3,
                                      colorClickableText: Colors.pink,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Xem thêm',
                                      trimExpandedText: 'Thu gọn',
                                      moreStyle: TextStyle(
                                          fontSize: 15,
                                          color: FoodHubColors.colorFC6011),
                                    ),
                                  ],
                                ),
                              ),
                              widget.post.status == 1
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  widget.post.status == 1
                                                      ? IconButton(
                                                          icon: widget.post
                                                                  .isReacted
                                                              ? Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: FoodHubColors
                                                                      .colorFC6011,
                                                                )
                                                              : const Icon(Icons
                                                                  .favorite_border),
                                                          iconSize: 30.0,
                                                          onPressed:
                                                              widget.post
                                                                      .isReacted
                                                                  ? () {
                                                                      final bloc =
                                                                          context
                                                                              .read<InteractPostBloc>();
                                                                      bloc.add(UnReactPost(widget
                                                                          .post
                                                                          .id));
                                                                      setState(
                                                                          () {
                                                                        widget.post.isReacted = !widget
                                                                            .post
                                                                            .isReacted;
                                                                      });
                                                                    }
                                                                  : () {
                                                                      final bloc =
                                                                          context
                                                                              .read<InteractPostBloc>();
                                                                      bloc.add(ReactPost(widget
                                                                          .post
                                                                          .id));
                                                                      setState(
                                                                          () {
                                                                        widget.post.isReacted = !widget
                                                                            .post
                                                                            .isReacted;
                                                                      });
                                                                    },
                                                        )
                                                      : const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Icon(Icons
                                                              .favorite_border),
                                                        ),
                                                  Text(
                                                    widget.post.totalReact
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
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
                                                    widget.post.totalComment
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
                                          widget.post.status == 1
                                              ? IconButton(
                                                  icon: widget.post.isSaved
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

                                                    setState(
                                                      () {
                                                        widget.post.isSaved =
                                                            !widget
                                                                .post.isSaved;
                                                        print(widget
                                                            .post.isSaved);
                                                        if (widget
                                                            .post.isSaved) {
                                                          final bloc = context.read<
                                                              InteractPostBloc>();
                                                          bloc.add(
                                                              SavePostSocial(
                                                                  widget.post
                                                                      .id));
                                                          const snackBar =
                                                              SnackBar(
                                                            content:
                                                                Text(saveText),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    500),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        } else {
                                                          final bloc = context.read<
                                                              InteractPostBloc>();
                                                          bloc.add(
                                                              UnSavePostSocial(
                                                                  widget.post
                                                                      .id));
                                                          const snackBar =
                                                              SnackBar(
                                                            content: Text(
                                                                cancelText),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    500),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        }
                                                      },
                                                    );
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
                    widget.post.status == 1 || widget.post.status == 2
                        ? Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: postComment.length,
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
                                                .read<InteractPostBloc>();
                                            bloc.add(ListPostComment(
                                                widget.post.id, page));
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
                                      text: widget.post.reason,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: FoodHubColors.color0B0C0C),
                                    ),
                                  ],
                                ),
                              ),
                            )))

                    // Center(
                    //     child: Text(
                    //       "Không có bình luận",
                    //       style: TextStyle(
                    //           color: FoodHubColors.color0B0C0C,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.normal),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: widget.post.status == 1
              ? Transform.translate(
                  offset: Offset(
                      0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    // height: 100.0,
                    decoration: const BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      boxShadow: [
                        const BoxShadow(
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
                          enabled: widget.post.status == 1 ? true : false,
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
                                    const BoxShadow(
                                      color: Colors.black45,
                                      offset: const Offset(0, 2),
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
                              color: Colors.red,
                              // child: FlatButton(
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(30.0),
                              //   ),
                              //   color: FoodHubColors.colorFC6011,
                              //   onPressed: () {
                              //     if (_commentKey.currentState!.validate()) {
                              //       final bloc =
                              //           context.read<InteractPostBloc>();
                              //       bloc.add(CommentPost(widget.post.id,
                              //           _contentController.text));
                              //       setState(() {
                              //         _contentController.clear();
                              //       });

                              //       Helpers.shared.hideKeyboard(context);
                              //     }
                              //   },
                              //   child: const Icon(
                              //     Icons.send,
                              //     size: 25.0,
                              //     color: Colors.white,
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : widget.post.status == 3
                  ? TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: FoodHubColors.colorFC6011,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.pushNamed(context, Routes.reupPost,
                        //     arguments: widget.post);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReupPostScreen(
                              post: widget.post,
                              index: widget.index,
                              onTap: (int value) {
                                if (widget.index != 987456123) {
                                  widget.onTap!(value);
                                }
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "ĐĂNG LẠI BÀI VIẾT",
                        style: TextStyle(color: FoodHubColors.colorFFFFFF),
                      ))
                  : null,
        ),
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
                image: NetworkImage(postComment[index].userImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          postComment[index].name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadMoreText(
              postComment[index].content,
              style: TextStyle(
                color: FoodHubColors.color0B0C0C,
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
              timePost(postComment[index].createDate),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: ApplicationSesson.shared.credential!.nameid ==
                postComment[index].userID
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
                      context, item, index, postComment[index].content),
                ),
              )
            : null,

        //  ApplicationSesson.shared.credential!.nameid ==
        //         postComment[index].userID
        //     ? IconButton(
        //         icon: const Icon(
        //           Icons.delete_outline,
        //         ),
        //         color: Colors.grey,
        //         onPressed: () {
        //           Helpers.shared.showDialogConfirm(context,
        //               message: 'Bạn có muốn xóa bình luận này hay không?',
        //               title: 'Xóa', okFunction: () {
        //             final bloc = context.read<InteractPostBloc>();
        //             bloc.add(DeleteCommentPost(postComment[index].id));
        //             setState(() {
        //               postComment.removeAt(index);
        //             });
        //           });
        //         },
        //       )
        //     : null,
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
              final bloc = context.read<InteractPostBloc>();
              bloc.add(EditCommentPost(
                  postComment[index].id, _editContentController.text));
              setState(
                () {
                  postComment[index].content = _editContentController.text;
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
          final bloc = context.read<InteractPostBloc>();
          bloc.add(DeleteCommentPost(postComment[index].id));
          setState(() {
            postComment.removeAt(index);
          });
        });
        break;
    }
  }

  void selectedItem(BuildContext context, item, int index) {
    switch (item) {
      case 0:
        ApplicationSesson.shared.credential!.nameid == widget.post.userID
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditPostScreen(
                    post: widget.post,
                    index: widget.index,
                    onTap: (int value) {
                      widget.onTap!(index);
                    },
                    pop: 2,
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
            bloc.add(DeleteMyPost(id: widget.post.id));
          },
        );
        break;
    }
  }

  void reportPost(_) {
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
                                final bloc = context.read<InteractPostBloc>();
                                bloc.add(ReportPost(
                                    widget.post.id,
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
