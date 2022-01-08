import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_project/base/viewmodel/base_view_model.dart';

/// Complies with `GetStateUpdater`
///
/// This mixin's function represents a `GetStateUpdater`, and might be used
/// by `GetBuilder()`, `SimpleBuilder()` (or similar) to comply
/// with [GetStateUpdate] signature. REPLACING the [StateSetter].
/// Avoids the potential (but extremely unlikely) issue of having
/// the Widget in a dispose() state, and abstracts the
/// API from the ugly fn((){}).
mixin GetStateUpdaterMixin<T extends StatefulWidget> on State<T> {
  // To avoid the creation of an anonym function to be GC later.
  // ignore: prefer_function_declarations_over_variables

  /// Experimental method to replace setState((){});
  /// Used with GetStateUpdate.
  void getUpdate() {
    if (mounted) setState(() {});
  }
}

typedef GetControllerBuilder<T extends DisposableInterface> = Widget Function(
    T controller);

abstract class BaseView<VM extends BaseViewModel> extends StatefulWidget {
  final GetControllerBuilder<VM>? builder;
  final Object? id;
  final String? tag;
  final bool autoRemove;
  final bool assignId;
  final Object Function(VM value)? filter;

  const BaseView({
    Key? key,
    this.builder,
    this.autoRemove = true,
    this.assignId = false,
    this.filter,
    this.tag,
    this.id,
  }) : super(key: key);

  @override
  BaseViewState<VM> createState() => BaseViewState<VM>();

  Widget buildContent(BuildContext context, VM viewModel);

  void initState(BaseViewState<VM> state) {}

  void dispose(BaseViewState<VM> state) {}

  void didChangeDependencies(BaseViewState<VM> state) {}

  void didUpdateWidget(BaseView oldWidget, BaseViewState<VM> state) {}

  String get title => '';

  VM buildViewModel();
}

class BaseViewState<VM extends BaseViewModel> extends State<BaseView<VM>>
    with GetStateUpdaterMixin {
  VM? viewModel;
  VoidCallback? _remove;
  Object? _filter;

  @override
  void initState() {
    // _GetBuilderState._currentState = this;
    super.initState();
    widget.initState.call(this);

    var isRegistered = GetInstance().isRegistered<VM>(tag: widget.tag);

    if (isRegistered) {
      viewModel = Get.find(tag: widget.tag);
      viewModel?.onStart();
    } else {
      viewModel = widget.buildViewModel();
      GetInstance().put<VM>(viewModel!, tag: widget.tag);
    }

    if (widget.filter != null) {
      _filter = widget.filter!(viewModel!);
    }

    _subscribeToController();
  }

  /// Register to listen Controller's events.
  /// It gets a reference to the remove() callback, to delete the
  /// setState "link" from the Controller.
  void _subscribeToController() {
    _remove?.call();
    _remove = (widget.id == null)
        ? viewModel?.addListener(
            _filter != null ? _filterUpdate : getUpdate,
          )
        : viewModel?.addListenerId(
            widget.id,
            _filter != null ? _filterUpdate : getUpdate,
          );
  }

  void _filterUpdate() {
    var newFilter = widget.filter!(viewModel!);
    if (newFilter != _filter) {
      _filter = newFilter;
      getUpdate();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose.call(this);
    if (widget.autoRemove && GetInstance().isRegistered<VM>(tag: widget.tag)) {
      GetInstance().delete<VM>(tag: widget.tag);
    }
    _remove?.call();
    viewModel = null;
    _remove = null;
    _filter = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies.call(this);
  }

  @override
  void didUpdateWidget(BaseView oldWidget) {
    super.didUpdateWidget(oldWidget as BaseView<VM>);
    // to avoid conflicts when modifying a "grouped" id list.
    if (oldWidget.id != widget.id) {
      _subscribeToController();
    }
    widget.didUpdateWidget.call(oldWidget, this);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder == null) {
      return widget.buildContent(context, viewModel!);
    }

    return widget.builder!(viewModel!);
  }
}
