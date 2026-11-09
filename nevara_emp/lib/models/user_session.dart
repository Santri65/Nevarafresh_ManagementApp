/// Manages the current authenticated user session in the store.
class UserSession {
  static String currentUsername = 'carlos.mendoza';
  static String currentName = 'Carlos Andrés Mendoza';
  static String currentEmail = 'carlos.mendoza@nevarafresh.com';
  static String currentPassword = 'password123';
  static String currentRole = 'Encargado de inventario';
  static String currentStoreId = 'TDA-003';
  static String currentStoreName = 'Sede Principal Centro';
  static bool isLoggedIn = true;

  /// Logs in a user, setting active session variables.
  static void login({
    required String username,
    required String password,
  }) {
    currentUsername = username.trim().isEmpty ? 'carlos.mendoza' : username.trim();
    currentPassword = password.trim().isEmpty ? 'password123' : password.trim();
    isLoggedIn = true;

    if (currentUsername.contains('@')) {
      currentEmail = currentUsername.toLowerCase();
      final localPart = currentEmail.split('@').first;
      currentName = _formatName(localPart);
    } else {
      currentEmail = '${currentUsername.toLowerCase()}@nevarafresh.com';
      currentName = _formatName(currentUsername);
    }
  }

  /// Clears the active session upon logout.
  static void logout() {
    isLoggedIn = false;
    currentUsername = '';
    currentEmail = '';
    currentPassword = '';
    currentName = 'Invitado';
  }

  /// Validates if provided email and password match the active session credentials.
  static bool validateCredentials(String email, String password) {
    final normalizedInputEmail = email.trim().toLowerCase();
    final normalizedSessionEmail = currentEmail.trim().toLowerCase();
    final cleanInputPassword = password.trim();

    return normalizedInputEmail == normalizedSessionEmail &&
        cleanInputPassword == currentPassword;
  }

  static String _formatName(String raw) {
    final parts = raw.replaceAll(RegExp(r'[._-]'), ' ').split(' ');
    final capitalized = parts.where((p) => p.isNotEmpty).map(
      (word) => '${word[0].toUpperCase()}${word.substring(1)}',
    );
    return capitalized.isEmpty ? 'Usuario Tienda' : capitalized.join(' ');
  }
}
