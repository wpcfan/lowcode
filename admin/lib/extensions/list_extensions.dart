extension ListExtension<T> on List<T> {
  void swap(int index1, int index2) {
    RangeError.checkValidIndex(index1, this, 'index1');
    RangeError.checkValidIndex(index2, this, 'index2');
    final T temp = this[index1];
    this[index1] = this[index2];
    this[index2] = temp;
  }

  move(int oldIndex, int newIndex) {
    RangeError.checkValidIndex(oldIndex, this, 'oldIndex');
    RangeError.checkValidIndex(newIndex, this, 'newIndex');
    if (oldIndex == newIndex) return;
    final T item = removeAt(oldIndex);
    insert(newIndex < oldIndex ? newIndex : newIndex - 1, item);
  }

  List<R> mapWithIndex<R>(R Function(T, int i) callback) {
    List<R> result = [];

    for (int i = 0; i < length; i++) {
      R item = callback(this[i], i);
      result.add(item);
    }
    return result;
  }

  Iterable<R> mapWithIndexIterable<R>(R Function(T, int i) callback) {
    return asMap().keys.toList().map((index) => callback(this[index], index));
  }
}
