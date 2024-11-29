sealed class AccountResult {
  factory AccountResult.success() = AccountSuccess; // Option

  factory AccountResult.error(String e) = AccountError; // Option
}

class AccountSuccess implements AccountResult {
  AccountSuccess();
}

class AccountError implements AccountResult {
  final String e;

  AccountError(this.e);
}