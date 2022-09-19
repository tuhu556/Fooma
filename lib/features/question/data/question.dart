import 'package:foodhub/features/question/models/question.dart';

class Data {
  static List<Question> questions = [
    Question(
      id: 1,
      expandedValue:
          'Nếu bạn muốn chỉnh sửa tên người dùng của mình, vui lòng truy cập trang Hồ sơ, nhấp vào nút chỉnh sửa trang cá nhân, và sau đó bạn có thể chỉnh sửa tên người dùng và hình ảnh.',
      headerValue: 'Làm thế nào có thể thay đổi tên tài khoản của tôi',
    ),
    Question(
      id: 2,
      expandedValue:
          'Hãy đặt lại mật khẩu của bạn ở ngoài giao diện đăng nhập tài khoản (Quên mật khẩu?)',
      headerValue: 'Tôi không thể đăng nhập',
    ),
    Question(
      id: 3,
      expandedValue:
          'Bạn có thể gửi email cho chúng tôi tại fooma.info@gmail.com',
      headerValue: 'Làm thế nào để liên hệ với Fooma',
    ),
    Question(
      id: 4,
      expandedValue:
          'Nếu bạn đang sử dụng ứng dụng, vui lòng truy cập Trang chủ và nhấn nút 3 dấu gạch ngang bên trái trên màn hình. Sau đó, nhấp vào quản lý nguyên liệu và tiếp tục chọn thêm nguyên liệu',
      headerValue: 'Làm thế nào để thêm nguyên liệu mới',
    ),
    Question(
      id: 5,
      expandedValue:
          'Nếu bạn đang sử dụng ứng dụng, vui lòng truy cập Cộng đồng và chọn vào khung "Bạn muốn chia sẻ điều gì không?".',
      headerValue: 'Làm thế nào để thêm món mới',
    ),
    Question(
      id: 6,
      expandedValue:
          'Nếu bạn đang sử dụng ứng dụng, vui lòng truy cập Cộng đồng và chọn tab thứ 2. Sau đó nhấp vào khung "Hãy chia sẻ công thức tới mọi người nào!"',
      headerValue: 'Làm thế nào để thêm công thức mới',
    ),
  ];
}
