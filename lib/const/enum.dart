enum UserType {
  N("normal", "일반회원"),
  O("owner", "사업주");

  /// 영문명 <br/>
  /// N  normal
  /// O owner
  final String engName;

  /// 한글명<br/>
  /// N : 일반회원
  /// O : 사업주
  final String korName;

  const UserType(this.engName, this.korName);
}

class UserTypeBuilder {
  static UserType create(String userTypeStr) {
    UserType userType = UserType.N;
    switch (userTypeStr) {
      case 'N':
        userType = UserType.N;
        break;
      case 'O':
        userType = UserType.O;
        break;
    }
    return userType;
  }
}

enum HttpMethod { get, post }

enum AppBarType { isSigned, isNotSigned }
