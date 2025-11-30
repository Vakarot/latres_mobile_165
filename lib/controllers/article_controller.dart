import 'package:get/get.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';

class ArticleController extends GetxController {
  final ApiService _apiService = ApiService();

  var articles = <Article>[].obs;
  var isLoading = false.obs;
  var selectedArticle = Rxn<Article>();

  // Reset data saat controller di-dispose
  @override
  void onClose() {
    articles.clear();
    selectedArticle.value = null;
    super.onClose();
  }

  Future<void> fetchArticles(String endpoint) async {
    try {
      isLoading.value = true;
      articles.clear(); // Clear previous data
      articles.value = await _apiService.fetchArticles(endpoint);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchArticleDetail(String endpoint, int id) async {
    try {
      isLoading.value = true;
      selectedArticle.value = null; // Clear previous data
      selectedArticle.value = await _apiService.fetchArticleDetail(
        endpoint,
        id,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat detail: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
