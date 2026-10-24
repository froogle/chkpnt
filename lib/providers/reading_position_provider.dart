import 'dart:async';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/repositories/guide_repository.dart';
import 'package:chkpnt/services/guide_parser/guide_content.dart';
import 'package:chkpnt/services/guide_storage_service.dart';
import 'package:chkpnt/providers/guide_provider.dart';

part 'reading_position_provider.g.dart';

sealed class GuideListItem {}

class SectionHeaderItem extends GuideListItem {
  final String title;
  SectionHeaderItem(this.title);
}

class ContentBlockItem extends GuideListItem {
  final ContentBlock block;
  ContentBlockItem(this.block);
}

class SectionSpacerItem extends GuideListItem {}

class TextGuideReading {
  final List<GuideListItem> items;
  final int startIndex;

  const TextGuideReading({required this.items, required this.startIndex});
}

typedef _Place = ({int section, int block});

@riverpod
class ReadingPosition extends _$ReadingPosition {
  static const saveDelay = Duration(milliseconds: 500);

  late GuideRepository _repository;
  List<_Place> _places = [];
  _Place? _unsavedPlace;
  Timer? _saveTimer;

  @override
  Future<TextGuideReading> build(GuideId guideId) async {
    _repository = ref.watch(guideRepositoryProvider);
    final storage = ref.watch(guideStorageServiceProvider);
    ref.onDispose(_save);

    final guide = await _repository.getGuideById(guideId);
    if (guide == null) throw GuideNotFoundException(guideId);

    final json = await storage.loadGuideJson(guide.fileName);
    final content = GuideContent.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
    final items = _flatten(content);
    return TextGuideReading(
      items: items,
      startIndex: _indexOf(items, (
        section: guide.lastReadSection,
        block: guide.lastReadBlock,
      )),
    );
  }

  void moveTo(int topIndex) {
    _unsavedPlace = _places[topIndex];
    _saveTimer?.cancel();
    _saveTimer = Timer(saveDelay, _save);
  }

  void _save() {
    _saveTimer?.cancel();
    final place = _unsavedPlace;
    if (place == null) return;
    _unsavedPlace = null;
    _repository
        .updateGuideReadPosition(guideId, place.section, place.block)
        .ignore();
  }

  List<GuideListItem> _flatten(GuideContent content) {
    final items = <GuideListItem>[];
    _places = [];
    void add(GuideListItem item, _Place place) {
      items.add(item);
      _places.add(place);
    }

    for (final (section, contentSection) in content.sections.indexed) {
      add(SectionHeaderItem(contentSection.title), (
        section: section,
        block: 0,
      ));
      for (final (block, contentBlock) in contentSection.blocks.indexed) {
        add(ContentBlockItem(contentBlock), (section: section, block: block));
      }
      add(SectionSpacerItem(), (section: section + 1, block: 0));
    }
    return items;
  }

  int _indexOf(List<GuideListItem> items, _Place place) {
    for (var index = 0; index < items.length; index++) {
      if (items[index] is! SectionSpacerItem && _places[index] == place) {
        return index;
      }
    }
    return 0;
  }
}
