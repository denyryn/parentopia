import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRepository {

  Future<List<Map<String, String>>> fetchCarouselData() async {
    try {
      // Reference to the "carousel" collection in Firestore
      final carouselRef = FirebaseFirestore.instance.collection('carousels');

      // Fetch documents from the "carousel" collection
      final carouselSnapshot = await carouselRef.get();

      // Extract data from documents
      final carouselData = carouselSnapshot.docs.map((doc) {
        return {
          'imageUrl': doc['imageURL'] as String,  // Use 'imageUrl' instead of 'imageURL'
          'externalLink': doc['externalLink'] as String,
        };
      }).toList();

      return carouselData;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, String>>> fetchPopularArticleData() async {
    try {
      // Reference to the "popularArticle" collection in Firestore
      final popularArticleRef = FirebaseFirestore.instance.collection('popularArticles');

      // Fetch documents from the "popularArticle" collection
      final popularArticleSnapshot = await popularArticleRef.get();

      // Extract data from documents
      final popularArticleData = popularArticleSnapshot.docs.map((doc) {
        return {
          'imageUrl': doc['imageURL'] as String,  // Use 'imageUrl' instead of 'imageURL'
          'externalLink': doc['externalLink'] as String,
        };
      }).toList();

      return popularArticleData;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, String>>> fetchClassesData() async {
    try {
      // Reference to the "classes" collection in Firestore
      final classesRef = FirebaseFirestore.instance.collection('classes');

      // Fetch documents from the "classes" collection
      final classesSnapshot = await classesRef.get();

      // Extract data from documents
      final classesData = classesSnapshot.docs.map((doc) {
        return {
          'imageUrl': doc['imageURL'] as String,  // Use 'imageUrl' instead of 'imageURL'
          'externalLink': doc['externalLink'] as String,
        };
      }).toList();

      return classesData;
    } catch (error) {
      rethrow;
    }
  }

  // You can create additional methods for other data sources if needed
}
