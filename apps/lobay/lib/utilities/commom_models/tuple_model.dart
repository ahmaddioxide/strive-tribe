class Tuple<A, B, C> {
   A first;
   B second;
   C third;

  Tuple({required this.first, required this.second, required this.third});

  //to String method
  @override
  String toString() {
    return 'Tuple{first: $first, second: $second, third: $third}';
  }
}
