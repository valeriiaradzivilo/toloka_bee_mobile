class AuthenticateUserUsecase {
  Future<bool> call(String username, String password) async {
    // Implement your authentication logic here
    // Return true if authentication is successful, otherwise false
    return username == 'user' && password == 'password';
  }
}
