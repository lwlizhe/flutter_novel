import 'package:flutter_novel/app/novel/helper/helper_db.dart';
import 'package:flutter_novel/base/structure/base_model.dart';

class NovelBookDBModel extends BaseModel{

 final DBHelper _dbHelper;

 NovelBookDBModel(this._dbHelper);

 void getSavedBook(){
  _dbHelper.getAllBooks();
  }
  void getBookInfo(){

  }

}