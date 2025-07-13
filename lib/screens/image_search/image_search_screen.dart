import 'package:flutter/material.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/services/web_image_search_service.dart';

class ImageSearchScreen extends StatefulWidget {
  final String initialQuery;
  const ImageSearchScreen({super.key, required this.initialQuery});

  @override
  State<ImageSearchScreen> createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen> {
  late String _query;
  List<String> _imageUrls = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _searchImages();
  }

  Future<void> _searchImages() async {
    setState(() {
      _loading = true;
      _error = null;
      _imageUrls = [];
    });
    try {
      final service = WebImageSearchService();
      _imageUrls = await service.searchImages(_query);
    } catch (e) {
      _error = 'Failed to load images.';
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        title: Text(
          'Search Images',
          style: const TextStyle(color: AppColors.primaryText),
        ),
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: _query),
                    onChanged: (value) => _query = value,
                    onSubmitted: (_) => _searchImages(),
                    decoration: InputDecoration(
                      hintText: 'Search for a game cover...',
                      hintStyle: const TextStyle(color: AppColors.primaryText),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    style: const TextStyle(color: AppColors.primaryText),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: AppColors.primaryPurple,
                  ),
                  onPressed: _searchImages,
                ),
              ],
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryPurple),
      );
    }
    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: AppColors.primaryText),
        ),
      );
    }
    if (_imageUrls.isEmpty) {
      return Center(
        child: Text(
          'No images found.',
          style: const TextStyle(color: AppColors.primaryText),
        ),
      );
    }
    return _buildGrid();
  }

  Widget _buildGrid() {
    final validUrls =
        _imageUrls.where((url) => url.isNotEmpty).take(9).toList();
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: validUrls.length,
      itemBuilder: (context, index) {
        final url = validUrls[index];
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(url),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryPurple.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.collapsibleSection,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: AppColors.primaryPurple,
                        size: 32,
                      ),
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
