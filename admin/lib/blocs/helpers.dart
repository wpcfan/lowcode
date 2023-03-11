import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return events
        .debounceTime(duration)
        .flatMap((event) => mapper(event).takeUntil(events.skip(1)));
  };
}
