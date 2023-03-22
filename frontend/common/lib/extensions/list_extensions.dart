extension ListExtension<T> on List<T> {
  List<R> mapWithIndex<R>(R Function(T, int i) callback) {
    return mapWithIndexIterable(callback).toList();
  }

  Iterable<R> mapWithIndexIterable<R>(R Function(T, int i) callback) {
    return asMap().entries.map((entry) => callback(entry.value, entry.key));
  }
}
