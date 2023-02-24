import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

abstract class LayoutEvent extends Equatable {}

class LayoutEventTitleChanged extends LayoutEvent {
  LayoutEventTitleChanged(this.title) : super();
  final String? title;

  @override
  List<Object?> get props => [title];
}

class LayoutEventPlatformChanged extends LayoutEvent {
  LayoutEventPlatformChanged(this.platform) : super();
  final Platform? platform;

  @override
  List<Object?> get props => [platform];
}

class LayoutEventPageTypeChanged extends LayoutEvent {
  LayoutEventPageTypeChanged(this.pageType) : super();
  final PageType? pageType;

  @override
  List<Object?> get props => [pageType];
}

class LayoutEventPageStatusChanged extends LayoutEvent {
  LayoutEventPageStatusChanged(this.pageStatus) : super();
  final PageStatus? pageStatus;

  @override
  List<Object?> get props => [pageStatus];
}

class LayoutEventStartDateChanged extends LayoutEvent {
  LayoutEventStartDateChanged(this.startDateFrom, this.startDateTo) : super();
  final DateTime? startDateFrom;
  final DateTime? startDateTo;

  @override
  List<Object?> get props => [startDateFrom, startDateTo];
}

class LayoutEventEndDateChanged extends LayoutEvent {
  LayoutEventEndDateChanged(this.endDateFrom, this.endDateTo) : super();
  final DateTime? endDateFrom;
  final DateTime? endDateTo;

  @override
  List<Object?> get props => [endDateFrom, endDateTo];
}

class LayoutEventPageChanged extends LayoutEvent {
  LayoutEventPageChanged(this.page) : super();
  final int? page;

  @override
  List<Object?> get props => [page];
}

class LayoutEventUpdate extends LayoutEvent {
  LayoutEventUpdate(this.id, this.layout) : super();
  final int id;
  final PageLayout layout;

  @override
  List<Object> get props => [id, layout];
}

class LayoutEventCreate extends LayoutEvent {
  LayoutEventCreate(this.layout) : super();

  final PageLayout layout;

  @override
  List<Object> get props => [layout];
}

class LayoutEventDelete extends LayoutEvent {
  LayoutEventDelete(this.id) : super();
  final int id;

  @override
  List<Object> get props => [id];
}

class LayoutEventPublish extends LayoutEvent {
  LayoutEventPublish(this.id, this.startTime, this.endTime) : super();
  final int id;
  final DateTime startTime;
  final DateTime endTime;

  @override
  List<Object> get props => [id];
}

class LayoutEventDraft extends LayoutEvent {
  LayoutEventDraft(this.id) : super();
  final int id;

  @override
  List<Object> get props => [id];
}

class LayoutEventClearAll extends LayoutEvent {
  LayoutEventClearAll() : super();

  @override
  List<Object> get props => [];
}
