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
}
