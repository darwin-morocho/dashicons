class Window {
  History get history => History();
}

class History {
  void pushState(dynamic data, String title, String? url) {}
}

Window get window => Window();
