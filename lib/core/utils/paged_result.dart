class PagedResult<T> {
  final List<T> items;
  final int totalCount;
  final int skip;
  final int top;

  const PagedResult({required this.items, required this.totalCount, required this.skip, required this.top});

  bool get hasMore => (skip + items.length) < totalCount;
}
