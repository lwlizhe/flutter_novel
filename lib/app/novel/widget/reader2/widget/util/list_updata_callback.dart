abstract class ListUpdateCallback {
  void onInserted(int position, int count);

  void onRemoved(int position, int count);

  void onMoved(int fromPosition, int toPosition);

  void onChanged(int position, int count, Object payload);
}
