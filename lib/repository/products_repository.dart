import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsRepository {
  Future<List<Map<String, String>>> fetchProductData() async {
    try {
      final productsRef = FirebaseFirestore.instance.collection('products');
      final productsSnapshot = await productsRef.get();

      // Extract data from documents
      final productData = productsSnapshot.docs.map((doc) {
        return {
          'imageURL': doc['imageURL'] as String,
          'externalLinkTokopedia': doc['externalLinkTokopedia'] as String,
          'externalLinkShopee': doc['externalLinkShopee'] as String,
          'name': doc['name'] as String,
        };
      }).toList();

      return productData;
    } catch (error) {
      rethrow;
    }
  }
}