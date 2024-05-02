class PocketBaseConstants {
  static const String endPoint = 'http://127.0.0.1:8090';

  static String imageUrl({
    required String collectionName,
    required String userId,
    required String image,
    String size = '100x300',
  }) {
    return '$endPoint/api/files/$collectionName/$userId/$image?thumb=$size';
  }
}
