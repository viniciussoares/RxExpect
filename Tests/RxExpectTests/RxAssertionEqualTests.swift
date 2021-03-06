// The MIT License (MIT)
//
// Copyright (c) 2016 Suyeol Jeon (xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest
import RxSwift
import RxTest
import RxExpect

struct NonEquatable {
  let name: String
}

class RxAssertionEqualTests: XCTestCase {

  // MARK: Equality Assertion (Non Equatable)

  func testAssertEqualOfNonEquatables() {
    RxExpect("it should assert equality of non equatable events", run: false) { test in
      let source = PublishSubject<NonEquatable>()
      test.input(source, [
        next(100, NonEquatable(name: "A")),
        next(200, NonEquatable(name: "B")),
      ])
      test.assert(source)
        .equal([
          next(100, NonEquatable(name: "A")),
          next(200, NonEquatable(name: "B")),
        ]) { left, right in
          return left.name == right.name
        }
      test.assert(source)
        .equal([
          next(100, NonEquatable(name: "C")),
          next(200, NonEquatable(name: "D")),
        ]) { left, right in
          return left.name == right.name
        }
      test.run { XCTAssertEqual($0, [true, false]) }
    }

    RxExpect("it should assert equality of non equatable elements", run: false) { test in
      let source = PublishSubject<NonEquatable>()
      test.input(source, [
        next(100, NonEquatable(name: "A")),
        next(200, NonEquatable(name: "B")),
      ])
      test.assert(source)
        .equal([
          NonEquatable(name: "A"),
          NonEquatable(name: "B"),
        ]) { left, right in
          return left.name == right.name
        }
      test.assert(source)
        .equal([
          NonEquatable(name: "C"),
          NonEquatable(name: "D"),
        ]) { left, right in
          return left.name == right.name
        }
      test.run { XCTAssertEqual($0, [true, false]) }
    }
  }

  func testAssertNotEqualOfNonEquatables() {
    RxExpect("it should assert inequality of non equatable events with different element", run: false) { test in
      let source = PublishSubject<NonEquatable>()
      test.input(source, [
        next(100, NonEquatable(name: "A")),
        next(200, NonEquatable(name: "B")),
      ])
      test.assert(source)
        .not()
        .equal([
          next(100, NonEquatable(name: "a")),
          next(200, NonEquatable(name: "b"))
        ]) { left, right in
          return left.name == right.name
        }
      test.assert(source)
        .not()
        .equal([
          next(100, NonEquatable(name: "A")),
          next(200, NonEquatable(name: "B"))
        ]) { left, right in
          return left.name == right.name
        }
      test.run { XCTAssertEqual($0, [true, false]) }
    }

    RxExpect("it should assert inequality of non equatable events with different time", run: false) { test in
      let source = PublishSubject<NonEquatable>()
      test.input(source, [
        next(100, NonEquatable(name: "A")),
        next(200, NonEquatable(name: "B")),
      ])
      test.assert(source)
        .not()
        .equal([
          next(200, NonEquatable(name: "A")),
          next(300, NonEquatable(name: "B"))
        ]) { left, right in
          return left.name == right.name
        }
      test.assert(source)
        .not()
        .equal([
          next(100, NonEquatable(name: "A")),
          next(200, NonEquatable(name: "B"))
        ]) { left, right in
          return left.name == right.name
        }
      test.run { XCTAssertEqual($0, [true, false]) }
    }

    RxExpect("it should assert inequality of non equatable elements", run: false) { test in
      let source = PublishSubject<NonEquatable>()
      test.input(source, [
        next(100, NonEquatable(name: "A")),
        next(200, NonEquatable(name: "B")),
      ])
      test.assert(source)
        .not()
        .equal([
          NonEquatable(name: "a"),
          NonEquatable(name: "b")
        ]) { left, right in
          return left.name == right.name
        }
      test.assert(source)
        .not()
        .equal([
          NonEquatable(name: "A"),
          NonEquatable(name: "B")
        ]) { left, right in
          return left.name == right.name
        }
      test.run { XCTAssertEqual($0, [true, false]) }
    }
  }

  // MARK: Equality Assertion (Equatable)

  func testAssertEqualOfEquatables() {
    RxExpect("it should assert equality of equatable events", run: false) { test in
      let source = PublishSubject<String>()
      test.input(source, [
        next(100, "A"),
        next(200, "B"),
      ])
      test.assert(source).equal([
        next(100, "A"),
        next(200, "B"),
      ])
      test.run { XCTAssertEqual($0, [true]) }
    }

    RxExpect("it should assert equality of equatable elements", run: false) { test in
      let source = PublishSubject<String>()
      test.input(source, [
        next(100, "A"),
        next(200, "B"),
      ])
      test.assert(source).equal(["A", "B"])
      test.run { XCTAssertEqual($0, [true]) }
    }
  }

  func testAssertNotEqualOfEquatables() {
    RxExpect("it should assert inequality of equatable events with different elements", run: false) { test in
      let source = PublishSubject<String>()
      test.input(source, [
        next(100, "A"),
        next(200, "B"),
      ])
      test.assert(source).not().equal([
        next(100, "a"),
        next(200, "b"),
      ])
      test.run { XCTAssertEqual($0, [true]) }
    }

    RxExpect("it should assert inequality of equatable events with different time", run: false) { test in
      let source = PublishSubject<String>()
      test.input(source, [
        next(100, "A"),
        next(200, "B"),
      ])
      test.assert(source).not().equal([
        next(200, "A"),
        next(300, "B"),
      ])
      test.run { XCTAssertEqual($0, [true]) }
    }

    RxExpect("it should assert inequality of equatable elements", run: false) { test in
      let source = PublishSubject<String>()
      test.input(source, [
        next(100, "a"),
        next(200, "b"),
      ])
      test.assert(source).not().equal(["A", "B"])
      test.run { XCTAssertEqual($0, [true]) }
    }
  }

  // MARK: Equality Assertion of Sequence Element (Equatable)

  func testAssertEqualOfSequence() {
    RxExpect("it should assert equality of sequence elements of equatables", run: false) { test in
      let source = PublishSubject<[String]>()
      test.input(source, [
        next(100, ["A", "B", "C"]),
        next(200, ["D", "E"]),
      ])
      test.assert(source).equal([
        next(100, ["A", "B", "C"]),
        next(200, ["D", "E"]),
      ])
      test.run { XCTAssertEqual($0, [true]) }
    }
  }

  func testAssertNotEqualOfSequence() {
    RxExpect("it should assert inequality of sequence elements of equatables with different elements", run: false) { test in
      let source = PublishSubject<[String]>()
      test.input(source, [
        next(100, ["A", "B", "C"]),
        next(200, ["D", "E"]),
      ])
      test.assert(source).not().equal([
        next(100, ["a", "b", "c"]),
        next(200, ["D", "E"]),
      ])
      test.run { XCTAssertEqual($0, [true]) }
    }

    RxExpect("it should assert inequality of sequence elements of equatables with different time", run: false) { test in
      let source = PublishSubject<[String]>()
      test.input(source, [
        next(100, ["A", "B", "C"]),
        next(200, ["D", "E"]),
      ])
      test.assert(source).not().equal([
        next(200, ["A", "B", "C"]),
        next(300, ["D", "E"]),
      ])
      test.run { XCTAssertEqual($0, [true]) }
    }
  }
}
