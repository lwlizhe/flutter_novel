import 'dart:math' as math;

import 'list_updata_callback.dart';

class DiffUtil {
  static DiffResult calculateDiff(Callback cb, {bool detectMoves = true}) {
    var oldSize = cb.getOldListSize();
    var newSize = cb.getNewListSize();

    final List<Snake> snakes = [];

    // instead of a recursive implementation, we keep our own stack to avoid potential stack
    // overflow exceptions
    final List<Range> stack = [];

    stack.add(new Range(
        oldListStart: 0,
        oldListEnd: oldSize,
        newListStart: 0,
        newListEnd: newSize));

    int max = oldSize + newSize + (oldSize - newSize).abs();
    // allocate forward and backward k-lines. K lines are diagonal lines in the matrix. (see the
    // paper for details)
    // These arrays lines keep the max reachable position for each k-line.
    var forward = List<int?>.filled(max * 2, null, growable: false);
    var backward = List<int?>.filled(max * 2, null, growable: false);

    // We pool the ranges to avoid allocations for each recursive call.
    final List<Range> rangePool = [];
    while (stack.isNotEmpty) {
      final Range range = stack[stack.length - 1];
      stack.remove(range);
      final Snake? snake = diffPartial(cb, range.oldListStart!, range.oldListEnd!,
          range.newListStart!, range.newListEnd!, forward, backward, max);
      if (snake != null) {
        if (snake.size > 0) {
          snakes.add(snake);
        }
        // offset the snake to convert its coordinates from the Range's area to global
        snake.x += range.oldListStart!;
        snake.y += range.newListStart!;

        // add new ranges for left and right
        Range left;
        if (rangePool.isEmpty) {
          left = new Range();
        } else {
          left = rangePool[rangePool.length - 1];
          rangePool.remove(left);
        }

        left.oldListStart = range.oldListStart;
        left.newListStart = range.newListStart;
        if (snake.reverse) {
          left.oldListEnd = snake.x;
          left.newListEnd = snake.y;
        } else {
          if (snake.removal) {
            left.oldListEnd = snake.x! - 1;
            left.newListEnd = snake.y;
          } else {
            left.oldListEnd = snake.x;
            left.newListEnd = snake.y! - 1;
          }
        }
        stack.add(left);

        // re-use range for right
        //noinspection UnnecessaryLocalVariable
        final Range right = range;
        if (snake.reverse) {
          if (snake.removal) {
            right.oldListStart = snake.x! + snake.size + 1;
            right.newListStart = snake.y! + snake.size;
          } else {
            right.oldListStart = snake.x! + snake.size;
            right.newListStart = snake.y! + snake.size + 1;
          }
        } else {
          right.oldListStart = snake.x! + snake.size;
          right.newListStart = snake.y! + snake.size;
        }
        stack.add(right);
      } else {
        rangePool.add(range);
      }
    }
    // sort snakes
    snakes.sort(
        (Snake o1, Snake o2) => o1.x! - o2.x! == 0 ? o1.y! - o2.y! : o1.x! - o2.x!);

    return new DiffResult(cb, snakes, forward, backward, detectMoves);
  }

  static Snake? diffPartial(Callback cb, int startOld, int endOld, int startNew,
      int endNew, List<int?> forward, List<int?> backward, int kOffset) {
    int oldSize = endOld - startOld;
    int newSize = endNew - startNew;

    if (endOld - startOld < 1 || endNew - startNew < 1) {
      return null;
    }

    final int delta = oldSize - newSize;
    final int dLimit = (oldSize + newSize + 1) ~/ 2;
    // Arrays.fill(forward, kOffset - dLimit - 1, kOffset + dLimit + 1, 0);
    // Arrays.fill(backward, kOffset - dLimit - 1 + delta,
    //     kOffset + dLimit + 1 + delta, oldSize);
    final bool checkInFwd = delta % 2 != 0;
    for (int d = 0; d <= dLimit; d++) {
      for (int k = -d; k <= d; k += 2) {
        // find forward path
        // we can reach k from k - 1 or k + 1. Check which one is further in the graph
        int? x;
        var removal;
        if (k == -d ||
            (k != d && forward[kOffset + k - 1]! < forward[kOffset + k + 1]!)) {
          x = forward[kOffset + k + 1];
          removal = false;
        } else {
          x = forward[kOffset + k - 1]! + 1;
          removal = true;
        }
        // set y based on x
        int y = x! - k;
        // move diagonal as long as items match
        while (x! < oldSize &&
            y < newSize &&
            cb.areItemsTheSame(startOld + x, startNew + y)) {
          x++;
          y++;
        }
        forward[kOffset + k] = x;
        if (checkInFwd && k >= delta - d + 1 && k <= delta + d - 1) {
          if (forward[kOffset + k]! >= backward[kOffset + k]!) {
            Snake outSnake = new Snake();
            outSnake.x = backward[kOffset + k]??0;
            outSnake.y = outSnake.x! - k;
            outSnake.size = forward[kOffset + k]! - backward[kOffset + k]!;
            outSnake.removal = removal;
            outSnake.reverse = false;
            return outSnake;
          }
        }
      }
      for (int k = -d; k <= d; k += 2) {
        // find reverse path at k + delta, in reverse
        final int backwardK = k + delta;
        int? x;
        bool removal;
        if (backwardK == d + delta ||
            (backwardK != -d + delta &&
                backward[kOffset + backwardK - 1]! <
                    backward[kOffset + backwardK + 1]!)) {
          x = backward[kOffset + backwardK - 1];
          removal = false;
        } else {
          x = backward[kOffset + backwardK + 1]! - 1;
          removal = true;
        }

        // set y based on x
        int y = x! - backwardK;
        // move diagonal as long as items match
        while (x! > 0 &&
            y > 0 &&
            cb.areItemsTheSame(startOld + x - 1, startNew + y - 1)) {
          x--;
          y--;
        }
        backward[kOffset + backwardK] = x;
        if (!checkInFwd && k + delta >= -d && k + delta <= d) {
          if (forward[kOffset + backwardK]! >= backward[kOffset + backwardK]!) {
            Snake outSnake = new Snake();
            outSnake.x = backward[kOffset + backwardK]??0;
            outSnake.y = outSnake.x! - backwardK;
            outSnake.size =
                forward[kOffset + backwardK]! - backward[kOffset + backwardK]!;
            outSnake.removal = removal;
            outSnake.reverse = true;
            return outSnake;
          }
        }
      }
    }
  }
}

class DiffResult {
  static const NO_POSITION = -1;
  static const FLAG_NOT_CHANGED = 1;
  static const FLAG_CHANGED = FLAG_NOT_CHANGED << 1;
  static const FLAG_MOVED_CHANGED = FLAG_CHANGED << 1;
  static const FLAG_MOVED_NOT_CHANGED = FLAG_MOVED_CHANGED << 1;

  static const FLAG_IGNORE = FLAG_MOVED_NOT_CHANGED << 1;

  static const FLAG_OFFSET = 5;

  static const FLAG_MASK = (1 << FLAG_OFFSET) - 1;

  List<Snake> _snakes = [];

  var _oldItemStatuses = [];
  var _newItemStatuses = [];

  Callback _callback;

  int _oldListSize = 0;
  int _newListSize = 0;
  bool _detectMove = false;

  DiffResult(this._callback, this._snakes, this._oldItemStatuses,
      this._newItemStatuses, this._detectMove) {
    _oldListSize = _callback.getOldListSize();
    _newListSize = _callback.getNewListSize();

    _addRootSnake();
    _findMatchingItems();
  }

  void _addRootSnake() {
    Snake? firstSnake = _snakes.isEmpty ? null : _snakes[0];
    if (firstSnake == null || firstSnake.x != 0 || firstSnake.y != 0) {
      Snake root = new Snake();
      root.x = 0;
      root.y = 0;
      root.removal = false;
      root.size = 0;
      root.reverse = false;
      _snakes.insert(0, root);
    }
  }

  void _findMatchingItems() {
    int? posOld = _oldListSize;
    int? posNew = _newListSize;
    // traverse the matrix from right bottom to 0,0.
    for (int i = _snakes.length - 1; i >= 0; i--) {
      final Snake snake = _snakes[i];
      final int endX = snake.x! + snake.size;
      final int endY = snake.y! + snake.size;
      if (_detectMove) {
        while (posOld! > endX) {
          // this is a removal. Check remaining snakes to see if this was added before
          _findAddition(posOld, posNew, i);
          posOld--;
        }
        while (posNew! > endY) {
          // this is an addition. Check remaining snakes to see if this was removed
          // before
          findRemoval(posOld, posNew, i);
          posNew--;
        }
      }
      for (int j = 0; j < snake.size; j++) {
        // matching items. Check if it is changed or not
        final int oldItemPos = snake.x! + j;
        final int newItemPos = snake.y! + j;
        final bool theSame =
            _callback.areContentsTheSame(oldItemPos, newItemPos);
        final int changeFlag = theSame ? FLAG_NOT_CHANGED : FLAG_CHANGED;
        _oldItemStatuses[oldItemPos] = (newItemPos << FLAG_OFFSET) | changeFlag;
        _newItemStatuses[newItemPos] = (oldItemPos << FLAG_OFFSET) | changeFlag;
      }
      posOld = snake.x;
      posNew = snake.y;
    }
  }

  void _findAddition(int x, int? y, int snakeIndex) {
    if (_oldItemStatuses[x - 1] != 0) {
      return; // already set by a latter item
    }
    findMatchingItem(x, y, snakeIndex, false);
  }

  void findRemoval(int? x, int y, int snakeIndex) {
    if (_newItemStatuses[y - 1] != 0) {
      return; // already set by a latter item
    }
    findMatchingItem(x, y, snakeIndex, true);
  }

  int convertOldPositionToNew(int oldListPosition) {
    if (oldListPosition < 0 || oldListPosition >= _oldListSize) {
      // throw new IndexOutOfBoundsException("Index out of bounds - passed position = "
      //     + oldListPosition + ", old list size = " + _oldListSize);
    }
    final int status = _oldItemStatuses[oldListPosition];
    if ((status & FLAG_MASK) == 0) {
      return NO_POSITION;
    } else {
      return status >> FLAG_OFFSET;
    }
  }

  int convertNewPositionToOld(int newListPosition) {
    if (newListPosition < 0 || newListPosition >= _newListSize) {
      // throw new IndexOutOfBoundsException("Index out of bounds - passed position = "
      //     + newListPosition + ", new list size = " + _newListSize);
    }
    final int status = _newItemStatuses[newListPosition];
    if ((status & FLAG_MASK) == 0) {
      return NO_POSITION;
    } else {
      return status >> FLAG_OFFSET;
    }
  }

  bool findMatchingItem(
      final int? x, final int? y, final int snakeIndex, final bool removal) {
    int myItemPos;
    int? curX;
    int? curY;
    if (removal) {
      myItemPos = y! - 1;
      curX = x;
      curY = y - 1;
    } else {
      myItemPos = x! - 1;
      curX = x - 1;
      curY = y;
    }
    for (int i = snakeIndex; i >= 0; i--) {
      final Snake snake = _snakes[i];
      final int endX = snake.x! + snake.size;
      final int endY = snake.y! + snake.size;
      if (removal) {
        // check removals for a match
        for (int pos = curX! - 1; pos >= endX; pos--) {
          if (_callback.areItemsTheSame(pos, myItemPos)) {
            // found!
            final bool theSame = _callback.areContentsTheSame(pos, myItemPos);
            final int changeFlag =
                theSame ? FLAG_MOVED_NOT_CHANGED : FLAG_MOVED_CHANGED;
            _newItemStatuses[myItemPos] = (pos << FLAG_OFFSET) | FLAG_IGNORE;
            _oldItemStatuses[pos] = (myItemPos << FLAG_OFFSET) | changeFlag;
            return true;
          }
        }
      } else {
        // check for additions for a match
        for (int pos = curY! - 1; pos >= endY; pos--) {
          if (_callback.areItemsTheSame(myItemPos, pos)) {
            // found
            final bool theSame = _callback.areContentsTheSame(myItemPos, pos);
            final int changeFlag =
                theSame ? FLAG_MOVED_NOT_CHANGED : FLAG_MOVED_CHANGED;
            _oldItemStatuses[x! - 1] = (pos << FLAG_OFFSET) | FLAG_IGNORE;
            _newItemStatuses[pos] = ((x - 1) << FLAG_OFFSET) | changeFlag;
            return true;
          }
        }
      }
      curX = snake.x;
      curY = snake.y;
    }
    return false;
  }

  // void dispatchUpdatesTo(RecyclerView.Adapter adapter) {
  //   dispatchUpdatesTo(new AdapterListUpdateCallback(adapter));
  // }
  //
  void dispatchUpdatesTo(ListUpdateCallback updateCallback) {
    BatchingListUpdateCallback batchingCallback;
    if (updateCallback is BatchingListUpdateCallback) {
      batchingCallback = updateCallback;
    } else {
      batchingCallback = new BatchingListUpdateCallback(updateCallback);
      // replace updateCallback with a batching callback and override references to
      // updateCallback so that we don't call it directly by mistake
      //noinspection UnusedAssignment
      updateCallback = batchingCallback;
    }
    // These are add/remove ops that are converted to moves. We track their positions until
    // their respective update operations are processed.
    final List<_PostponedUpdate> postponedUpdates = [];
    int? posOld = _oldListSize;
    int? posNew = _newListSize;
    for (int snakeIndex = _snakes.length - 1; snakeIndex >= 0; snakeIndex--) {
      final Snake snake = _snakes[snakeIndex];
      final int snakeSize = snake.size;
      final int endX = snake.x! + snakeSize;
      final int endY = snake.y! + snakeSize;
      if (endX < posOld!) {
        dispatchRemovals(
            postponedUpdates, batchingCallback, endX, posOld - endX, endX);
      }

      if (endY < posNew!) {
        dispatchAdditions(
            postponedUpdates, batchingCallback, endX, posNew - endY, endY);
      }
      for (int i = snakeSize - 1; i >= 0; i--) {
        if ((_oldItemStatuses[snake.x! + i] & FLAG_MASK) == FLAG_CHANGED) {
          batchingCallback.onChanged(snake.x! + i, 1,
              _callback.getChangePayload(snake.x! + i, snake.y! + i));
        }
      }
      posOld = snake.x;
      posNew = snake.y;
    }
    batchingCallback.dispatchLastEvent();
  }

  static _PostponedUpdate? removePostponedUpdate(
      List<_PostponedUpdate> updates, int? pos, bool removal) {
    for (int i = updates.length - 1; i >= 0; i--) {
      final _PostponedUpdate update = updates[i];
      if (update.posInOwnerList == pos && update.removal == removal) {
        updates.remove(i);
        for (int j = i; j < updates.length; j++) {
          // offset other ops since they swapped positions
          updates[j].currentPos += removal ? 1 : -1;
        }
        return update;
      }
    }
    return null;
  }

  void dispatchAdditions(
      List<_PostponedUpdate> postponedUpdates,
      ListUpdateCallback updateCallback,
      int start,
      int count,
      int globalIndex) {
    if (!_detectMove) {
      updateCallback.onInserted(start, count);
      return;
    }
    for (int i = count - 1; i >= 0; i--) {
      int? status = _newItemStatuses[globalIndex + i] & FLAG_MASK;
      switch (status) {
        case 0: // real addition
          updateCallback.onInserted(start, 1);
          for (_PostponedUpdate update in postponedUpdates) {
            update.currentPos += 1;
          }
          break;
        case FLAG_MOVED_CHANGED:
        case FLAG_MOVED_NOT_CHANGED:
          final int? pos = _newItemStatuses[globalIndex + i] >> FLAG_OFFSET;
          final _PostponedUpdate update =
              removePostponedUpdate(postponedUpdates, pos, true)!;
          // the item was moved from that position
          //noinspection ConstantConditions
          updateCallback.onMoved(update.currentPos, start);
          if (status == FLAG_MOVED_CHANGED) {
            // also dispatch a change
            updateCallback.onChanged(
                start, 1, _callback.getChangePayload(pos, globalIndex + i));
          }
          break;
        case FLAG_IGNORE: // ignoring this
          postponedUpdates
              .add(new _PostponedUpdate(globalIndex + i, start, false));
          break;
        default:
        // throw new IllegalStateException(
        //     "unknown flag for pos " + (globalIndex + i) + " " + Long
        //         .toBinaryString(status));
      }
    }
  }

  void dispatchRemovals(
      List<_PostponedUpdate> postponedUpdates,
      ListUpdateCallback updateCallback,
      int start,
      int count,
      int globalIndex) {
    if (!_detectMove) {
      updateCallback.onRemoved(start, count);
      return;
    }
    for (int i = count - 1; i >= 0; i--) {
      final int? status = _oldItemStatuses[globalIndex + i] & FLAG_MASK;
      switch (status) {
        case 0: // real removal
          updateCallback.onRemoved(start + i, 1);
          for (_PostponedUpdate update in postponedUpdates) {
            update.currentPos -= 1;
          }
          break;
        case FLAG_MOVED_CHANGED:
        case FLAG_MOVED_NOT_CHANGED:
          final int? pos = _oldItemStatuses[globalIndex + i] >> FLAG_OFFSET;
          final _PostponedUpdate update =
              removePostponedUpdate(postponedUpdates, pos, false)!;
          // the item was moved to that position. we do -1 because this is a move not
          // add and removing current item offsets the target move by 1
          //noinspection ConstantConditions
          updateCallback.onMoved(start + i, update.currentPos - 1);
          if (status == FLAG_MOVED_CHANGED) {
            // also dispatch a change
            updateCallback.onChanged(update.currentPos - 1, 1,
                _callback.getChangePayload(globalIndex + i, pos));
          }
          break;
        case FLAG_IGNORE: // ignoring this
          postponedUpdates
              .add(new _PostponedUpdate(globalIndex + i, start + i, true));
          break;
        default:
        // throw new IllegalStateException(
        //     "unknown flag for pos " + (globalIndex + i) + " " + Long
        //         .toBinaryString(status));
      }
    }
  }
}

abstract class Callback<T> {
  int getOldListSize();

  int getNewListSize();

  bool areItemsTheSame(int oldItemPosition, int newItemPosition);

  bool areContentsTheSame(int oldItemPosition, int newItemPosition);

  dynamic getChangePayload(T oldItem, T newItem) {
    return null;
  }

  factory Callback(
      {IsChangedForPositionCallback? isContentsTheSameFunc,
      IsChangedForPositionCallback? isItemsSameFunc,
      IntValueCallback? newListSizeFunc,
      IntValueCallback? oldListSizeFunc}) = NormalCallback;
}

typedef bool IsChangedForPositionCallback(
    int oldItemPosition, int newItemPosition);
typedef int IntValueCallback();

class NormalCallback<T> implements Callback<T> {
  IsChangedForPositionCallback? isContentsTheSameFunc;
  IsChangedForPositionCallback? isItemsSameFunc;
  IntValueCallback? oldListSizeFunc;
  IntValueCallback? newListSizeFunc;

  NormalCallback(
      {this.isContentsTheSameFunc,
      this.isItemsSameFunc,
      this.newListSizeFunc,
      this.oldListSizeFunc});

  @override
  bool areContentsTheSame(int oldItemPosition, int newItemPosition) {
    return isContentsTheSameFunc!(oldItemPosition, newItemPosition);
  }

  @override
  bool areItemsTheSame(int oldItemPosition, int newItemPosition) {
    return isItemsSameFunc!(oldItemPosition, newItemPosition);
  }

  @override
  getChangePayload(T oldItem, T newItem) {}

  @override
  int getNewListSize() {
    return newListSizeFunc!();
  }

  @override
  int getOldListSize() {
    return oldListSizeFunc!();
  }
}

abstract class ItemCallback<T> {
  bool areItemsTheSame(T oldItem, T newItem);

  bool areContentsTheSame(T oldItem, T newItem);

  dynamic getChangePayload(T oldItem, T newItem) {
    return null;
  }
}

class Snake {
  int x=0;
  int y=0;
  late int size;

  late bool removal;
  late bool reverse;
}

class Range {
  int? oldListStart, oldListEnd;
  int? newListStart, newListEnd;

  Range(
      {this.oldListStart, this.oldListEnd, this.newListStart, this.newListEnd});
}

class _PostponedUpdate {
  int posInOwnerList;

  int currentPos;

  bool removal;

  _PostponedUpdate(this.posInOwnerList, this.currentPos, this.removal);
}
