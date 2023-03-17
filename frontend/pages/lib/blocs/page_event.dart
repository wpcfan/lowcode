import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

abstract class PageEvent extends Equatable {}

class PageEventTitleChanged extends PageEvent {
  PageEventTitleChanged(this.title) : super();
  final String? title;

  @override
  List<Object?> get props => [title];
}

class PageEventPlatformChanged extends PageEvent {
  PageEventPlatformChanged(this.platform) : super();
  final Platform? platform;

  @override
  List<Object?> get props => [platform];
}

class PageEventPageTypeChanged extends PageEvent {
  PageEventPageTypeChanged(this.pageType) : super();
  final PageType? pageType;

  @override
  List<Object?> get props => [pageType];
}

class PageEventPageStatusChanged extends PageEvent {
  PageEventPageStatusChanged(this.pageStatus) : super();
  final PageStatus? pageStatus;

  @override
  List<Object?> get props => [pageStatus];
}

class PageEventStartDateChanged extends PageEvent {
  PageEventStartDateChanged(this.startDateFrom, this.startDateTo) : super();
  final DateTime? startDateFrom;
  final DateTime? startDateTo;

  @override
  List<Object?> get props => [startDateFrom, startDateTo];
}

class PageEventEndDateChanged extends PageEvent {
  PageEventEndDateChanged(this.endDateFrom, this.endDateTo) : super();
  final DateTime? endDateFrom;
  final DateTime? endDateTo;

  @override
  List<Object?> get props => [endDateFrom, endDateTo];
}

class PageEventPageChanged extends PageEvent {
  PageEventPageChanged(this.page) : super();
  final int? page;

  @override
  List<Object?> get props => [page];
}

class PageEventUpdate extends PageEvent {
  PageEventUpdate(this.id, this.layout) : super();
  final int id;
  final PageLayout layout;

  @override
  List<Object> get props => [id, layout];
}

class PageEventCreate extends PageEvent {
  PageEventCreate(this.layout) : super();

  final PageLayout layout;

  @override
  List<Object> get props => [layout];
}

class PageEventDelete extends PageEvent {
  PageEventDelete(this.id) : super();
  final int id;

  @override
  List<Object> get props => [id];
}

class PageEventPublish extends PageEvent {
  PageEventPublish(this.id, this.startTime, this.endTime) : super();
  final int id;
  final DateTime startTime;
  final DateTime endTime;

  @override
  List<Object> get props => [id];
}

class PageEventDraft extends PageEvent {
  PageEventDraft(this.id) : super();
  final int id;

  @override
  List<Object> get props => [id];
}

class PageEventClearAll extends PageEvent {
  PageEventClearAll() : super();

  @override
  List<Object> get props => [];
}
