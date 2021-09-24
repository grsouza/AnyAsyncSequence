public struct AnyAsyncSequence<Element>: AsyncSequence {
  public typealias AsyncIterator = AnyAsyncIterator<Element>
  
  let _makeAsyncIterator: () -> AsyncIterator
  
  public init<S: AsyncSequence>(_ s: S) where S.Element == Element {
    _makeAsyncIterator = {
      AnyAsyncIterator(s.makeAsyncIterator())
    }
  }
  
  __consuming public func makeAsyncIterator() -> AsyncIterator {
    _makeAsyncIterator()
  }
}

public struct AnyAsyncIterator<Element>: AsyncIteratorProtocol {
  let _next: () async throws -> Element?
  
  public init<Iterator: AsyncIteratorProtocol>(_ iterator: Iterator) where Iterator.Element == Element {
    var iterator = iterator
    _next = { try await iterator.next() }
  }
  
  public mutating func next() async throws -> Element? {
    try await _next()
  }
  
}

extension AsyncSequence {
  public func eraseToAnyAsyncSequence() -> AnyAsyncSequence<Element> {
    AnyAsyncSequence(self)
  }
}
