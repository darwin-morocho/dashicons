extension DurationExt on int {
  Duration get seg {
    return Duration(seconds: this);
  }

  Duration get ms {
    return Duration(milliseconds: this);
  }

  Duration get min {
    return Duration(minutes: this);
  }
}
