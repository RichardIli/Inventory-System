class FirestoreTransmitalHistoryRepo {
  void recordHistory(Map<String, dynamic> data) {
    try {
      final transmitalCollectionDb = transmitalList;
      final docId = transmitalCollectionDb.length;
      data['docId'] = docId;

      transmitalList.add(data);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void recordNewItemHistory(Map<String, dynamic> data) {
    try {
      final transmitalCollectionDb = transmitalList;
      final docId = transmitalCollectionDb.length;
      data['docId'] = docId;

      transmitalList.add(data);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  List fetchTransmitalHistory() {
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
