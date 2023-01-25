extension ListExtension<T> on List<T> {
  void swap(int index1, int index2) {
    RangeError.checkValidIndex(index1, this, 'index1');
    RangeError.checkValidIndex(index2, this, 'index2');
    final T temp = this[index1];
    this[index1] = this[index2];
    this[index2] = temp;
  }
}
