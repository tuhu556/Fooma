import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/data/data.dart';
import 'package:foodhub/features/favorite_post/models/favorite_post_entity.dart';
import 'package:foodhub/features/user_profile/model/my_post_entity.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:readmore/readmore.dart';

import '../../../config/routes.dart';
import '../../../helper/helper.dart';
import '../../../session/session.dart';
import '../../../widgets/detail_screen.dart';
import '../../social/bloc/interact_post_bloc.dart';
import '../../social/models/comment_entity.dart';
import '../bloc/favorite_post_bloc.dart';

class FavoritePostDetail extends StatefulWidget {
  final FavoritePost? post;
  final int? index;
  final Function(int)? onTap;
  const FavoritePostDetail({
    Key? key,
    this.post,
    this.index,
    this.onTap,
  }) : super(key: key);

  @override
  _FavoritePostDetailState createState() => _FavoritePostDetailState();
}

class _FavoritePostDetailState extends State<FavoritePostDetail> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MyFavoritePostBloc()
            ..add(const MyFavoritePost())
            ..add(GetPostDetail(widget.post!.postId)),
        ),
        BlocProvider(
          create: (_) =>
              InteractPostBloc()..add(ListPostComment(widget.post!.postId, 1)),
        ),
      ],
      child: FavoritePostDetailView(
        post: widget.post!,
        index: widget.index,
        onTap: widget.onTap,
      ),
    );
  }
}

class FavoritePostDetailView extends StatefulWidget {
  final FavoritePost post;
  final int? index;
  final Function(int)? onTap;
  const FavoritePostDetailView({
    Key? key,
    required this.post,
    this.index,
    this.onTap,
  }) : super(key: key);

  @override
  State<FavoritePostDetailView> createState() => _FavoritePostDetailViewState();
}

class _FavoritePostDetailViewState extends State<FavoritePostDetailView> {
  String? validationContent;
  final GlobalKey<FormState> _contentForm = GlobalKey();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _editContentController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();
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

  final DateFormat formatterYMD = DateFormat('yyyy-MM-dd');
  final DateFormat formatterYMDHMS = DateFormat('yyyy-MM-dd HH:mm:ss');
  String formattedYMD = '';
  DateTime? timeAgo;
  var difference;

  List<FavoritePost> favoritePost = [];
  bool _check = false;
  GlobalKey<FormState> _postForm = GlobalKey();
  MyPost postDetail = MyPost(
      "id",
      "userID",
      "name",
      "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png",
      "title",
      "content",
      "publishedDate",
      "USER",
      "",
      false,
      false,
      1,
      0,
      0, []);

  List<Comment> postComment = [];
  int page = 1;
  int totalPage = 1;

  @override
  void initState() {
    var parsedDate = DateTime.parse(widget.post.postResponse.publishedDate);
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
    titleOfReport = 'Ảnh không phù hợp';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyFavoritePostBloc, MyFavoritePostState>(
          listener: (context, state) {
            if (state.status == MyFavoritePostStatus.SaveProcessing) {
            } else if (state.status == MyFavoritePostStatus.SaveFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == MyFavoritePostStatus.SaveSuccess) {
            } else if (state.status == MyFavoritePostStatus.UnSaveProcessing) {
            } else if (state.status == MyFavoritePostStatus.UnSaveFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == MyFavoritePostStatus.UnSaveSuccess) {
            } else if (state.status == MyFavoritePostStatus.Processing) {
            } else if (state.status == MyFavoritePostStatus.Failed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == MyFavoritePostStatus.Success) {
              favoritePost.clear();
              setState(() {
                favoritePost = state.myFavoritePost!.favoritePost;
                for (int i = 0; i < favoritePost.length; i++) {
                  if (favoritePost[i].postId == widget.post.postId) {
                    setState(() {
                      _check = true;
                    });
                    break;
                  } else {
                    setState(() {
                      _check = false;
                    });
                  }
                }
              });
            }

            if (state.status == MyFavoritePostStatus.PostDetailProcessing) {
            } else if (state.status == MyFavoritePostStatus.SaveFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == MyFavoritePostStatus.PostDetailSuccess) {
              setState(() {
                postDetail = state.postDetail!;
              });
            }
          },
        ),
        BlocListener<InteractPostBloc, InteractPostState>(
          listener: (context, state) {
            if (state.status == InteractPostStatus.DeleteProcessing) {
            } else if (state.status == InteractPostStatus.DeleteFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == InteractPostStatus.DeleteSuccess) {
              widget.onTap!(widget.index!);
              Helpers.shared.showDialogSuccess(context,
                  message: "Xóa bài viết thành công",
                  title: "Xóa", okFunction: () {
                Navigator.pop(context);
              });
            } else if (state.status ==
                InteractPostStatus.ListCommentProcessing) {
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
              bloc.add(ListPostComment(widget.post.postId, 1));
              setState(() {
                widget.post.postResponse.totalComment++;
              });
            } else if (state.status ==
                InteractPostStatus.DeleteCommentProcessing) {
            } else if (state.status == InteractPostStatus.DeleteCommentFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status ==
                InteractPostStatus.DeleteCommentSuccess) {
              setState(() {
                widget.post.postResponse.totalComment--;
              });
            } else if (state.status ==
                InteractPostStatus.EditCommentProcessing) {
            } else if (state.status == InteractPostStatus.EditCommentFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == InteractPostStatus.EditCommentSuccess) {
            } else if (state.status ==
                InteractPostStatus.ReportPostProcessing) {
            } else if (state.status == InteractPostStatus.ReportPostFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == InteractPostStatus.ReportPostSuccess) {
              setState(() {
                _descriptionController.clear();
                titleOfReport == report[0];
              });
              Navigator.pop(context);
            }
          },
        ),
      ],
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
                                                    postDetail.userImageUrl),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: widget
                                                    .post.postResponse.userId ==
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
                                                    arguments: widget.post
                                                        .postResponse.userId);
                                              },
                                      ),
                                      title: Row(
                                        children: [
                                          InkWell(
                                            child: Text(
                                              widget.post.postResponse.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onTap: widget.post.postResponse
                                                        .userId ==
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
                                                            .post
                                                            .postResponse
                                                            .userId);
                                                  },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          widget.post.postResponse.role ==
                                                  "USER"
                                              ? Container()
                                              : Container(
                                                  height: 20,
                                                  width: 20,
                                                  child: Image.asset(
                                                      'assets/images/tick.png')),
                                        ],
                                      ),
                                      subtitle: Text(difference),
                                      trailing: Theme(
                                        data: Theme.of(context).copyWith(
                                            iconTheme: IconThemeData(
                                                color:
                                                    FoodHubColors.color0B0C0C)),
                                        child: PopupMenuButton<int>(
                                          color: FoodHubColors.colorFFFFFF,
                                          itemBuilder: (context) {
                                            return ApplicationSesson.shared
                                                        .credential!.nameid ==
                                                    widget.post.postResponse
                                                        .userId
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
                                                            style: TextStyle(
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
                                                            style: TextStyle(
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
                                              selectedItem(context, item),
                                        ),
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
                                  items: widget.post.postResponse.postImages
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
                                children: widget.post.postResponse.postImages
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
                                child: ReadMoreText(
                                  widget.post.postResponse.content,
                                  style: TextStyle(
                                    color: FoodHubColors.color0B0C0C,
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
                              ),
                              Padding(
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
                                            IconButton(
                                              icon: postDetail.isReacted
                                                  ? Icon(
                                                      Icons.favorite,
                                                      color: FoodHubColors
                                                          .colorFC6011,
                                                    )
                                                  : Icon(Icons.favorite_border),
                                              iconSize: 30.0,
                                              onPressed: postDetail.isReacted
                                                  ? () {
                                                      final bloc = context.read<
                                                          InteractPostBloc>();
                                                      bloc.add(UnReactPost(
                                                          widget.post.postId));
                                                      setState(() {
                                                        postDetail.isReacted =
                                                            !postDetail
                                                                .isReacted;
                                                        widget.post.postResponse
                                                            .totalReact--;
                                                      });
                                                    }
                                                  : () {
                                                      final bloc = context.read<
                                                          InteractPostBloc>();
                                                      bloc.add(ReactPost(
                                                          widget.post.postId));
                                                      setState(() {
                                                        postDetail.isReacted =
                                                            !postDetail
                                                                .isReacted;
                                                        widget.post.postResponse
                                                            .totalReact++;
                                                      });
                                                    },
                                            ),
                                            Text(
                                              widget
                                                  .post.postResponse.totalReact
                                                  .toString(),
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
                                            const Icon(
                                              Icons.chat,
                                              size: 30.0,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              widget.post.postResponse
                                                  .totalComment
                                                  .toString(),
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
                                      icon: _check
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
                                        const cancelText =
                                            "Bỏ lưu bài viết này";

                                        setState(
                                          () {
                                            _check = !_check;
                                            if (_check) {
                                              final bloc = context
                                                  .read<MyFavoritePostBloc>();
                                              bloc.add(
                                                  SavePost(widget.post.postId));
                                              const snackBar = SnackBar(
                                                content: Text(saveText),
                                                duration:
                                                    Duration(milliseconds: 500),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            } else {
                                              final bloc = context
                                                  .read<MyFavoritePostBloc>();
                                              bloc.add(UnSavePost(
                                                  widget.post.postId));
                                              const snackBar = SnackBar(
                                                content: Text(cancelText),
                                                duration:
                                                    Duration(milliseconds: 500),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
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
                              physics: const NeverScrollableScrollPhysics(),
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
                                      final bloc =
                                          context.read<InteractPostBloc>();
                                      bloc.add(ListPostComment(
                                          widget.post.postId, page));
                                    },
                                    child: Text(
                                      "Xem thêm bình luận...",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: FoodHubColors.colorFC6011),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Transform.translate(
            offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 100.0,
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
                child: TextField(
                  controller: _contentController,
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
                      //     final bloc = context.read<InteractPostBloc>();
                      //     bloc.add(CommentPost(
                      //         postDetail.id, _contentController.text));
                      //     setState(() {
                      //       _contentController.clear();
                      //     });

                      //     Helpers.shared.hideKeyboard(context);
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

  void selectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        ApplicationSesson.shared.credential!.nameid ==
                widget.post.postResponse.userId
            ? Navigator.pushNamed(context, Routes.editPost,
                arguments: postDetail)
            : reportPost(context);
        break;
      case 1:
        Helpers.shared.showDialogConfirm(
          context,
          title: "Xác nhận",
          message: "Bạn có muốn xóa bài viết này không?",
          okFunction: () {
            final bloc = context.read<InteractPostBloc>();
            bloc.add(DeleteMyPost(id: widget.post.postId));
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
