import 'dart:convert';
import 'guide_content.dart';

extension ContentBlockSerialization on ContentBlock {
  static ContentBlock fromJson(Map<String, dynamic> json) => ContentBlock(
    content: json['content'] as String,
    preformatted: json['preformatted'] as bool? ?? false,
  );
}

extension ContentSectionSerialization on ContentSection {
  static ContentSection fromJson(Map<String, dynamic> json) => ContentSection(
    title: json['title'] as String,
    blocks: (json['blocks'] as List)
        .map((b) => ContentBlockSerialization.fromJson(b as Map<String, dynamic>))
        .toList(),
  );
}

extension GuideContentSerialization on GuideContent {
  static GuideContent fromJson(Map<String, dynamic> json) => GuideContent(
    title: json['title'] as String,
    author: json['author'] as String,
    url: json['url'] as String?,
    sections: (json['sections'] as List)
        .map((s) => ContentSectionSerialization.fromJson(s as Map<String, dynamic>))
        .toList(),
  );

  static GuideContent fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return fromJson(json);
  }
}
