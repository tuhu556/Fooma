class Constants {
  static const String patternPassword =
      r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,30}$";
  static const String patternTextwithoutIcon =
      r'^[a-zA-Z]{4,}(?: [a-zA-Z]+){0,5}$';
  static const String patternTextForEmail = r'[A-Za-z0-9@.-_]';
  static const String patternPhone =
      r'([\+84|84|0]+(3|5|7|8|9|1[2|6|8|9]))+([0-9]{8})\b';
  static const String patternNumber = r'[0-9]';
  static const String patternUserAndPhone =
      r'(^(?=.*[a-z])[a-z0-9]{​​​​​​6,12}​​​​​​$)|(^[0-9]{​​​​​​11,11}​​​​​​$)';
  static const String patternUserId = r"^[A-Za-z][A-Za-z0-9_]{6,20}$";
  static const String patternEmail =
      r"^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$";
  static const kAnimationDuration = Duration(milliseconds: 200);
}
