import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlesRepository {

  Future<List<Map<String, String>>> fetchArticleData() async {
    try {
      final articlesRef = FirebaseFirestore.instance.collection('articles');
      final articlesSnapshot = await articlesRef.get();

      // Extract data from documents
      final articlesData = articlesSnapshot.docs.map((doc) {
        return {
          'imageURL': doc['imageURL'] as String,
          'externalLink': doc['externalLink'] as String,
          'name': doc['name'] as String,
        };
      }).toList();

      return articlesData;
    } catch (error) {
      rethrow;
    }
  }
}