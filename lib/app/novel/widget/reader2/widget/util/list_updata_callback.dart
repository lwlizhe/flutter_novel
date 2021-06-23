import 'dart:math' as math;

abstract class ListUpdateCallback {
  void onInserted(int position, int count);

  void onRemoved(int position, int count);

  void onMoved(int fromPosition, int toPosition);

  void onChanged(int position, int count, Object? payload);
}

class BatchingListUpdateCallback implements ListUpdateCallback {
  static const int TYPE_NONE = 0;
  static const int TYPE_ADD = 1;
  static const int TYPE_REMOVE = 2;
  static const int TYPE_CHANGE = 3;

  final ListUpdateCallback mWrapped;

  int mLastEventType = TYPE_NONE;
  int mLastEventPosition = -1;
  int mLastEventCount = -1;
  Object? mLastEventPayload = 0;

  BatchingListUpdateCallback(this.mWrapped);

  void dispatchLastEvent() {
    if (mLastEventType == TYPE_NONE) {
      return;
    }
    switch (mLastEventType) {
      case TYPE_ADD:
        mWrapped.onInserted(mLastEventPosition, mLastEventCount);
        break;
      case TYPE_REMOVE:
        mWrapped.onRemoved(mLastEventPosition, mLastEventCount);
        break;
      case TYPE_CHANGE:
        mWrapped.onChanged(
            mLastEventPosition, mLastEventCount, mLastEventPayload);
        break;
    }
    mLastEventPayload = null;
    mLastEventType = TYPE_NONE;
  }

  @override
  void onInserted(int position, int count) {
    if (mLastEventType == TYPE_ADD &&
        position >= mLastEventPosition &&
        position <= mLastEventPosition + mLastEventCount) {
      mLastEventCount += count;
      mLastEventPosition = math.min(position, mLastEventPosition);
      return;
    }
    dispatchLastEvent();
    mLastEventPosition = position;
    mLastEventCount = count;
    mLastEventType = TYPE_ADD;
  }

  @override
  void onRemoved(int position, int count) {
    if (mLastEventType == TYPE_REMOVE &&
        mLastEventPosition >= position &&
        mLastEventPosition <= position + count) {
      mLastEventCount += count;
      mLastEventPosition = position;
      return;
    }
    dispatchLastEvent();
    mLastEventPosition = position;
    mLastEventCount = count;
    mLastEventType = TYPE_REMOVE;
  }

  @override
  void onMoved(int fromPosition, int toPosition) {
    dispatchLastEvent(); // moves are not merged
    mWrapped.onMoved(fromPosition, toPosition);
  }

  @override
  void onChanged(int position, int count, Object? payload) {
    if (mLastEventType == TYPE_CHANGE &&
        !(position > mLastEventPosition + mLastEventCount ||
            position + count < mLastEventPosition ||
            mLastEventPayload != payload)) {
      // take potential overlap into account
      int previousEnd = mLastEventPosition + mLastEventCount;
      mLastEventPosition = math.min(position, mLastEventPosition);
      mLastEventCount =
          math.max(previousEnd, position + count) - mLastEventPosition;
      return;
    }
    dispatchLastEvent();
    mLastEventPosition = position;
    mLastEventCount = count;
    mLastEventPayload = payload;
    mLastEventType = TYPE_CHANGE;
  }
}
