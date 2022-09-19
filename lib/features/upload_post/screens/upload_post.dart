import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodhub/config/cloudinary.dart';
import 'package:foodhub/features/upload_post/bloc/upload_post_bloc.dart';
import 'package:foodhub/features/upload_post/models/upload_post_entity.dart';
import 'package:foodhub/widgets/loading_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../constants/color.dart';
import '../../../helper/helper.dart';
import '../../../widgets/detail_screen.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({Key? key}) : super(key: key);

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(),
      child: PostView(),
    );
  }
}

class PostView extends StatefulWidget {
  const PostView({Key? key}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  GlobalKey<FormState> _postForm = GlobalKey();
  TextEditingController _titlePostController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  bool isLoading = false;
  File? imageFile;
  final picker = ImagePicker();

  String imageUrl = "";

  String? validationContent;

  bool _validate = false;
  List<String> urlImg = [];
  List<PostImages> postsImage = [];
  List<String> urlImage = [];

  Future<void> chooseImage(ImageSource src) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: src);

    final image = Image.network(pickedImage!.path);

    print("image is $image");
    setState(() {
      isLoading = true;
    });
    Navigator.pop(context);
    final cloudinary = Cloudinary.full(
      apiKey: CoudinaryFull.shared.apiKey,
      apiSecret: CoudinaryFull.shared.apiSecret,
      cloudName: CoudinaryFull.shared.cloudName,
    );

    final response = await cloudinary.uploadResource(
      CloudinaryUploadResource(
        filePath: pickedImage.path,
        fileBytes: await pickedImage.readAsBytes(),
        resourceType: CloudinaryResourceType.image,
        folder: "Fooma",
        fileName: pickedImage.name,
        progressCallback: (count, total) {
          setState(() {
            isLoading = true;
          });
        },
      ),
    );
    if (response.isSuccessful) {
      print('Get your image from with ${response.secureUrl}');
      setState(() {
        imageUrl = response.secureUrl!;
        urlImage.add(imageUrl);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Upload image Failed!"),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state.status == PostStatus.Processing) {
        } else if (state.status == PostStatus.Failed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == PostStatus.Success) {
          Helpers.shared.showDialogSuccess(context,
              message: "Thêm bài viết thành công",
              title: "Bài viết", okFunction: () {
            Navigator.pop(context);
          });
          //
        }
      },
      child: Scaffold(
        backgroundColor: FoodHubColors.colorF0F5F9,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: FoodHubColors.colorF0F5F9,
          leading: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: FoodHubColors.color0B0C0C,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Thêm bài viết",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: FoodHubColors.color0B0C0C),
          ),
        ),
        body: KeyboardDismisser(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Form(
                key: _postForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    urlImage.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.22,
                              child: GestureDetector(
                                child: SvgPicture.asset(
                                  'assets/images/upload.svg',
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  updateImage(context);
                                },
                              ),
                            ),
                          )
                        : Container(),
                    urlImage.isNotEmpty
                        ? GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: urlImage.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    GestureDetector(
                                      child: LoadingImage(
                                        urlImg: urlImage[index],
                                      ),
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return DetailScreen(
                                            image: urlImage[index],
                                          );
                                        }));
                                      },
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: InkWell(
                                        child: Opacity(
                                            opacity: 0.5,
                                            child: ClipOval(
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                    color: FoodHubColors
                                                        .color0B0C0C),
                                                child: Center(
                                                    child: SvgPicture.asset(
                                                  'assets/icons/multi.svg',
                                                  width: 17,
                                                  height: 17,
                                                  color:
                                                      FoodHubColors.colorFFFFFF,
                                                )),
                                              ),
                                            )),
                                        onTap: () {
                                          Helpers.shared.showDialogConfirm(
                                              context,
                                              message:
                                                  "Bạn có muốn xóa ảnh này không?",
                                              okFunction: () {
                                            setState(() {
                                              urlImage.removeAt(index);
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                        : Container(),
                    urlImage.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              color: FoodHubColors.colorFFFFFF,
                              child: InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/upload_icon.svg',
                                    // fit: BoxFit.fill,
                                  ),
                                ),
                                onTap: () {
                                  updateImage(context);
                                },
                              ),
                            ),
                          )
                        : Container(),
                    Visibility(
                      visible: _validate,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Vui lòng thêm hình ảnh bài đăng",
                            style: TextStyle(
                                color: FoodHubColors.colorCC0000,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Helpers.shared.textFieldNameOfPost(context,
                        controllerText: _titlePostController),
                    const SizedBox(
                      height: 20,
                    ),
                    textInputDescription(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          validationContent ?? "",
                          style: TextStyle(
                              color: FoodHubColors.colorCC0000, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Container(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: FoodHubColors.colorFC6011,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                setState(() {
                  postsImage.clear();
                });
                if (urlImage.isNotEmpty) {
                  setState(() {
                    _validate = false;
                  });
                } else {
                  setState(() {
                    _validate = true;
                  });
                }
                for (int i = 0; i < postsImage.length; i++) {
                  print(postsImage[i].imageUrl);
                }
                if (_postForm.currentState!.validate()) {
                  if (!_validate) {
                    for (int i = 0; i < urlImage.length; i++) {
                      postsImage.add(PostImages(i + 1, urlImage[i], true));
                    }

                    final bloc = context.read<PostBloc>();
                    bloc.add(
                      CreatePostEvent(
                        title: _titlePostController.text.trim(),
                        content: _descriptionController.text.trim(),
                        hashtag: "String",
                        postImages: postsImage,
                      ),
                    );
                  }
                }
              },
              child: Text(
                "THÊM",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: FoodHubColors.colorFFFFFF,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textInputDescription() {
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
                setState(() {
                  validationContent = "Vui lòng nhập mô tả";
                });
                return "Vui lòng nhập mô tả";
              } else {
                setState(() {
                  validationContent = "";
                });
                return null;
              }
            },
            keyboardType: TextInputType.multiline,
            maxLines: 8,
          ),
        ),
      ],
    );
  }

  void updateImage(context) {
    showModalBottomSheet(
      backgroundColor: FoodHubColors.colorFC6011,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.15,
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: FoodHubColors.colorFFFFFF,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Chụp ảnh mới",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.colorFFFFFF),
                      ),
                    ],
                  ),
                  onTap: () {
                    chooseImage(ImageSource.camera);
                  },
                ),
              ),
              Container(
                height: 0.5,
                color: FoodHubColors.colorFFFFFF,
              ),
              Expanded(
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_album_outlined,
                        color: FoodHubColors.colorFFFFFF,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Chọn ảnh từ thư viện",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.colorFFFFFF),
                      ),
                    ],
                  ),
                  onTap: () {
                    chooseImage(ImageSource.gallery);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
