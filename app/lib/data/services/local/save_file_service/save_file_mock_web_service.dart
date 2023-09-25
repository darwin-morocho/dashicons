class Blob {
  Blob(List blobParts, [String? type, String? endings]);
}

class HtmlDocument {
  void createElement(String _, [String? typeExtension]) {}

  BodyElement? get body => BodyElement();
}

class Url {
  static createObjectUrlFromBlob(Blob blob) {
    return '';
  }

  static void revokeObjectUrl(String _) {}
}

class AnchorElement extends Node {
  set href(String? _) {}
  set download(String? _) {}

  void click() {}
}

class BodyElement {
  Node append(Node node) {
    return Node();
  }
}

class Node {}

final document = HtmlDocument();
