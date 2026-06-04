class ApiConfig {
  static const baseUrl = 'http://localhost:3000';

  static String getApiUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  static String getUploadUrl(String filename) {
    return '$baseUrl/uploads/$filename';
  }
}
