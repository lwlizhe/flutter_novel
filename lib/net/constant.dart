const String BASE_URL = "http://api.zhuishushenqi.com/";
const String READER_IMAGE_URL = 'http://statics.zhuishushenqi.com';

const String QUERY_AUTO_COMPLETE_QUERY_KEYWORD =
    BASE_URL + "book/auto-complete?query=";
const String QUERY_HOT_QUERY_KEYWORD = BASE_URL + "book/hot-word";
const String QUERY_BOOK_KEY_WORD = BASE_URL + "book/fuzzy-search";
const String QUERY_BOOK_DETAIL_INFO = BASE_URL + "book/";
const String QUERY_BOOK_SHORT_REVIEW = BASE_URL + "post/short-review";
const String QUERY_BOOK_REVIEW = BASE_URL + "post/review/by-book";
const String QUERY_BOOK_RECOMMEND = BASE_URL + "book/{id}/recommend";

const String QUERY_NOVEL_CATEGORIES = BASE_URL + "cats/lv2/statistics";
const String QUERY_NOVEL_INFO_BY_TAG = BASE_URL + "book/by-categories";
const String QUERY_NOVEL_RANK_TAG_INFO = BASE_URL + "ranking/gender";
const String QUERY_NOVEL_RANK_INFO_Of_TAG = BASE_URL + "ranking/{rankingId}";

const String QUERY_POST_OF_DISCUSSION = BASE_URL + "ranking/{rankingId}";

class ApiConstant {
  String getDiscussionPostUrl({
    String sort = 'updated',
    int startIndex = 0,
    int limit = 20,
  }) {
    return BASE_URL +
        "post/by-block?block=ramble&duration=all&sort=$sort&type=all&start=$startIndex&limit=$limit&distillate=";
  }

  String getBookReviewUrl({
    String sort = 'updated',
    int startIndex = 0,
    int limit = 20,
  }) {
    return BASE_URL +
        "post/review?duration=all&sort=$sort&type=all&start=$startIndex&limit=$limit&distillate=true";
  }
}
