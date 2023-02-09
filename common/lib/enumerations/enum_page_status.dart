enum PageStatus {
  draft('Draft'),
  published('Published'),
  archived('Archived');

  final String value;

  const PageStatus(this.value);
}
