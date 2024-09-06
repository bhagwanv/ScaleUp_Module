class AddImageUrlList {
  String? imageUrl;
  int? docId;

  AddImageUrlList({
    this.imageUrl,
    this.docId,
  });

  @override
  String toString() {
    return 'AddImageUrlList{imageUrl: $imageUrl, docId: $docId}';
  }
}
