import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/article_controller.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String endpoint;

  const DetailPage({super.key, required this.id, required this.endpoint});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ArticleController articleController;

  @override
  void initState() {
    super.initState();
    String tag = '${widget.endpoint}_${widget.id}';
    articleController = Get.put(ArticleController(), tag: tag);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      articleController.fetchArticleDetail(widget.endpoint, widget.id);
    });
  }

  @override
  void dispose() {
    String tag = '${widget.endpoint}_${widget.id}';
    Get.delete<ArticleController>(tag: tag);
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Tidak dapat membuka URL',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membuka URL: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Obx(() {
        if (articleController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final article = articleController.selectedArticle.value;

        if (article == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    articleController.fetchArticleDetail(
                      widget.endpoint,
                      widget.id,
                    );
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.imageUrl.isNotEmpty)
                Image.network(
                  article.imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 64, color: Colors.grey),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      ),
                    );
                  },
                ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          article.publishedAt,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      article.summary,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    SizedBox(height: 16),
                    if (article.newsSite.isNotEmpty)
                      Chip(
                        label: Text(article.newsSite),
                        avatar: Icon(Icons.public, size: 16),
                        backgroundColor: Colors.blue[50],
                      ),
                    SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        final article = articleController.selectedArticle.value;
        if (article != null && article.url.isNotEmpty) {
          return FloatingActionButton.extended(
            onPressed: () => _launchURL(article.url),
            icon: Icon(Icons.open_in_browser),
            label: Text('Open Web'),
          );
        }
        return SizedBox.shrink();
      }),
    );
  }
}
