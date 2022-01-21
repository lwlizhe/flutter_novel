import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/novel/viewmodel/novel_intro_view_model.dart';

class NovelIntroPage extends BaseView<NovelIntroViewModel> {
  @override
  Widget buildContent(BuildContext context, NovelIntroViewModel viewModel) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }

  @override
  NovelIntroViewModel buildViewModel() {
    return NovelIntroViewModel();
  }
}
