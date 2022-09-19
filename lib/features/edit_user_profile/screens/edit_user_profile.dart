import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/cloudinary.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/data/data.dart';
import 'package:foodhub/features/edit_user_profile/bloc/edit_user_profile_bloc.dart';
import 'package:foodhub/features/user_profile/model/user_profile_entity.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/color.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UserProfileResponse;
    return BlocProvider(
      create: (_) => EditUserProfileBloc(),
      child: EditUserProfileView(
        userProfile: args,
      ),
    );
  }
}

class EditUserProfileView extends StatefulWidget {
  final UserProfileResponse userProfile;
  const EditUserProfileView({Key? key, required this.userProfile})
      : super(key: key);

  @override
  State<EditUserProfileView> createState() => _EditUserProfileViewState();
}

class _EditUserProfileViewState extends State<EditUserProfileView> {
  final GlobalKey<FormState> _userNameForm = GlobalKey();
  final GlobalKey<FormState> _bioForm = GlobalKey();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String userName = '';
  String bio = '';

  File? imageFile;
  final picker = ImagePicker();
  String urlImg = '';
  String url = '';

  String? validationContent;

  XFile? _image;
  bool _validate = false;
  bool isLoading = false;
  chooseImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(source: src);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        imageFile = File(pickedFile.path);
        _validate = false;
      });
    }
    Navigator.pop(context);
    // var storageImg;
    // try {
    //   print(imageFile!.path);
    //   storageImg = FirebaseStorage.instance.ref().child(imageFile!.path);
    //   var task = storageImg.putFile(imageFile!);
    //   url = await (await task.whenComplete(() => null)).ref.getDownloadURL();
    // } catch (e) {}
  }

  @override
  void initState() {
    _userNameController.text = widget.userProfile.name!;
    _bioController.text = widget.userProfile.bio!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditUserProfileBloc, EditUserProfileState>(
      listener: (context, state) async {
        if (state.status == EditUserProfileStatus.Processing) {
          // Helpers.shared.showDialogProgress(context);
        } else if (state.status == EditUserProfileStatus.Failed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == EditUserProfileStatus.Success) {
          // Helpers.shared.hideDialogProgress(context);

          Navigator.pushNamed(context, Routes.mainTab, arguments: 4);
          Helpers.shared
              .showDialogSuccess(context, message: "Cập nhật hồ sơ thành công");
        }
      },
      child: Scaffold(
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
              Helpers.shared.showDialogConfirm(
                context,
                message: "Bạn chưa lưu thay đổi. Bạn có chắc muốn hủy không?",
                title: "Xác nhận",
                okText: "Có",
                cancelText: "Không",
                okFunction: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          centerTitle: true,
          title: Text(
            "Chỉnh sửa trang cá nhân",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: FoodHubColors.color0B0C0C),
          ),
          actions: [
            InkWell(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Icon(
                    Icons.done,
                    size: 30,
                  ),
                ),
              ),
              onTap: () async {
                var storageImg;
                if (_image != null) {
                  // try {
                  //   print(File(_image!.path).path);
                  //   storageImg = FirebaseStorage.instance
                  //       .ref()
                  //       .child(File(_image!.path).path);
                  //   var task = storageImg.putFile(File(_image!.path));
                  //   url = await (await task.whenComplete(() => null))
                  //       .ref
                  //       .getDownloadURL();
                  //   print(url);
                  // } catch (e) {}
                  final cloudinary = Cloudinary.full(
                    apiKey: CoudinaryFull.shared.apiKey,
                    apiSecret: CoudinaryFull.shared.apiSecret,
                    cloudName: CoudinaryFull.shared.cloudName,
                  );

                  final response = await cloudinary.uploadResource(
                    CloudinaryUploadResource(
                      filePath: _image!.path,
                      fileBytes: await _image!.readAsBytes(),
                      resourceType: CloudinaryResourceType.image,
                      folder: "Fooma",
                      fileName: _image!.name,
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
                      url = response.secureUrl!;
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
                } else {
                  setState(() {
                    url = widget.userProfile.imageUrl!;
                  });
                }

                final bloc = context.read<EditUserProfileBloc>();
                bloc.add(
                  EditUserProfileEvent(
                    name: _userNameController.text,
                    bio: _bioController.text,
                    birthDate: '2022-04-28T03:49:11.698Z',
                    imageUrl: url,
                    phoneNumber: "0123456789",
                  ),
                );
                setState(() {
                  Data.avatar = url;
                });
              },
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _image != null
                            ? Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                widget.userProfile.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: InkWell(
                      highlightColor: FoodHubColors.colorF0F5F9,
                      splashColor: FoodHubColors.colorF0F5F9,
                      child: Text(
                        "Thay đổi ảnh đại diện",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: FoodHubColors.colorFC6011,
                        ),
                      ),
                      onTap: () {
                        updateImage(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: FoodHubColors.colorFC7F401,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 35,
                              ),
                              Expanded(
                                child: Text(
                                  widget.userProfile.email.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: FoodHubColors.color0B0C0C,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "Tên",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: FoodHubColors.colorFC7F401,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 55,
                              ),
                              Expanded(
                                child: Text(
                                  _userNameController.text,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: FoodHubColors.color0B0C0C,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                splashRadius: 20,
                                iconSize: 30,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Helpers.shared.showDialogEditUserName(
                                    context,
                                    title: 'Tên tài khoản',
                                    widget: Form(
                                      key: _userNameForm,
                                      child: Helpers.shared.textFieldUserName(
                                        context,
                                        colorBox: FoodHubColors.colorE1E4E8,
                                        controllerText: _userNameController,
                                        onChange: (name) {
                                          userName = name ?? "";
                                        },
                                      ),
                                    ),
                                    okFunction: () {
                                      if (_userNameForm.currentState!
                                          .validate()) {
                                        setState(
                                          () {
                                            if (userName.isEmpty) {
                                              _userNameController.text =
                                                  widget.userProfile.name!;
                                            } else {
                                              _userNameController.text =
                                                  userName;
                                            }
                                          },
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "Tiểu sử",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: FoodHubColors.colorFC7F401,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  _bioController.text,
                                  maxLines: 5,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: FoodHubColors.color0B0C0C,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                splashRadius: 20,
                                iconSize: 30,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Helpers.shared.showDialogEditBio(
                                    context,
                                    title: 'Tiểu sử',
                                    widget: Form(
                                      key: _bioForm,
                                      child: Helpers.shared.textFieldBio(
                                        context,
                                        colorBox: FoodHubColors.colorE1E4E8,
                                        controllerText: _bioController,
                                        onChange: (string) {
                                          bio = string ?? "";
                                        },
                                      ),
                                    ),
                                    okFunction: () {
                                      if (_bioForm.currentState!.validate()) {
                                        setState(
                                          () {
                                            if (bio.isEmpty) {
                                              _bioController.text =
                                                  widget.userProfile.bio!;
                                            } else {
                                              _bioController.text = bio;
                                            }
                                          },
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
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
