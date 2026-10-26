/// How much the other person's answer moved someone (US-12).
///
/// No level means "bad": on a first date the other person is watching.
enum Rating {
  moved(2),
  interesting(1),
  okay(0);

  const Rating(this.value);

  final int value;
}
