class Ticker {
  const Ticker();
  Stream<int> tick() {
    return Stream.periodic(Duration(seconds: 4), (x) => x);
  }
}