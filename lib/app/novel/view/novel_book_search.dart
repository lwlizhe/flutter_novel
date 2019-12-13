import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_search.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class NovelSearchView extends BaseStatefulView<NovelBookSearchViewModel> {
  @override
  BaseStatefulViewState<BaseStatefulView<BaseViewModel>,
      NovelBookSearchViewModel> buildState() {
    return _NovelSearchViewState();
  }
}

class _NovelSearchViewState
    extends BaseStatefulViewState<NovelSearchView, NovelBookSearchViewModel> {
  StreamController inputStreamController = StreamController();
  Observable switchObservable;
  FocusNode _focusNode;

  @override
  Widget buildView(BuildContext context, NovelBookSearchViewModel viewModel) {
    SearchContentEntity contentEntity = viewModel.contentEntity;

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Material(
          color: Colors.white,
          child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                titleSpacing: 0.0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Icon(Icons.arrow_back),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        }),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color(0xFFF5F5F5)),
                            margin: EdgeInsets.fromLTRB(0, 9, 0, 9),
                            alignment: Alignment.center,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              focusNode: _focusNode,
                              textInputAction: TextInputAction.search,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (data) {
                                inputStreamController.sink.add(data);
                              },
                              style: TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 20),
                              decoration: InputDecoration(
//                  hintText: "test",/// 由于不知道啥原因导致的bug，一加hintText整个输入区整体往上移……所以暂时不加hintText，应该是Flutter的bug
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none),
                            )),
                      ),
                    )
                  ],
                ),
              ),
              body: Builder(builder: (context) {
                List<Widget> stackChildren = [];
                stackChildren
                    .add(_SearchStackBottomWidget(contentEntity.searchHotWord));
                if (contentEntity?.autoCompleteSearchWord?.length != null &&
                    contentEntity.autoCompleteSearchWord.length > 0) {
                  stackChildren.add(_SearchStackAutoCompleteWidget(
                      contentEntity.autoCompleteSearchWord));
                }
                return Stack(
                  children: stackChildren,
                );
              })),
        ));
  }

  @override
  NovelBookSearchViewModel buildViewModel(BuildContext context) {
    return NovelBookSearchViewModel(Provider.of(context));
  }

  @override
  void initData() {
    switchObservable = Observable(inputStreamController.stream)
        .debounceTime(const Duration(milliseconds: 300));

    _focusNode = FocusNode();
    _focusNode.addListener(_onTextFocusChanged);
  }

  @override
  void loadData(BuildContext context, NovelBookSearchViewModel viewModel) {
    switchObservable.listen((word) {
      viewModel.getSearchWord(word);
    });

    viewModel.getHotSearchWord();
  }

  @override
  void dispose() {
    super.dispose();
    inputStreamController?.close();
    inputStreamController = null;
  }

  void _onTextFocusChanged() {
    if (_focusNode.hasFocus) {}
  }
}

class _SearchStackBottomWidget extends StatelessWidget {
  final List<String> hotWords;

  _SearchStackBottomWidget(this.hotWords);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Text(
                "热搜",
                style: TextStyle(fontSize: 24),
              ),
            ),
            SliverToBoxAdapter(
              child: Wrap(
                spacing: 5,
                children: hotWords
                    .map((word) => RaisedButton(
                          color: Colors.grey[300],
                          elevation: 2.0,
                          highlightElevation: 4.0,
                          disabledElevation: 0.0,
                          highlightColor: Colors.grey[400],
                          splashColor: Colors.grey,
                          child: Text(word),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {},
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SearchStackAutoCompleteWidget extends StatelessWidget {
  final List<String> autoCompleteWords;

  _SearchStackAutoCompleteWidget(this.autoCompleteWords);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    autoCompleteWords[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
            itemCount: autoCompleteWords.length,
            shrinkWrap: true,
          ),
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: 0.7,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
