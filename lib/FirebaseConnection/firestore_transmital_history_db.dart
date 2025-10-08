class FirestoreTransmitalHistoryRepo {
  void recordHistory(
    String id,
    Map<String, dynamic> data,
  )  {
    try {
      // TODO: make an option where if the id is not found then or if its for new item
      // Inserting id and name to the passed history data.

      final fetchedDocFromGivenCollection =
          transmitalList.where((element) => element["id"] == id).first;

      final String name = fetchedDocFromGivenCollection['name'];

      data['id'] = id;
      data['name'] = name;

      final transmitalCollectionDb = transmitalList;
      final docId = transmitalCollectionDb.length;
      data['docId'] = docId;

      transmitalList.add(data);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  List fetchTransmitalHistory()  {
    try {
      final fetchedData = transmitalList;
      fetchedData.sort(
        (a, b) => double.parse(b['docId']).compareTo(double.parse(a['docId'])),
      );
      return fetchedData;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return [];
    }
  }

  List<Map<String, dynamic>> transmitalList = [];
}
