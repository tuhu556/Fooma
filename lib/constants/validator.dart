//EMAIL
const String kEmailNullError = "Vui lòng nhập email";
const String kInvalidEmailError = "Vui lòng nhập đúng định dạng Email";
//PASSWORD
const String kPassNullError = "Vui lòng nhập mật khẩu";
const String kShortPassError = "Mật khẩu quá ngắn";
const String kMatchPassError = "Mật khẩu không khớp";
const String kMatchOldPassError = "Mật khẩu mới phải khác mật khẩu cũ";
const String kPassError = "Mật khẩu phải viết hoa chữ cái đầu, từ 8->30 kí tự";
//NAME
const String kNamelNullError = "Vui lòng nhập tên của bạn";
//CAMERA
const String kCameraError = "Không thể truy cập thư viện ảnh và máy ảnh";
const String kUploadImageError = "Tải ảnh không thành công";
bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool isIntNumeric(String s) {
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}
