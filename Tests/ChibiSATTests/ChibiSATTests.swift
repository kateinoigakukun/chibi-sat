import XCTest
@testable import ChibiSAT

final class ChibiSATTests: XCTestCase {
    func testDIMACS() throws {
        let content = """
c
c start with comments
c
c
p cnf 5 3
1 -5 4 0
-1 5 3 4 0
-3 -4 0
"""
        let lines = content.split(whereSeparator: \.isNewline)
        let dimacs = DIMACS(source: lines.makeIterator())
        let cnfs = try IteratorSequence(dimacs).lazy.map { try $0.get() }
        XCTAssertEqual(cnfs.count, 1)
        XCTAssertEqual(cnfs[0].numberOfVariables, 5)
        XCTAssertEqual(cnfs[0].clauses, [
            [
                Literal(number: 1, isNegative: false),
                Literal(number: 5, isNegative: true),
                Literal(number: 4, isNegative: false),
            ],
            [
                Literal(number: 1, isNegative: true),
                Literal(number: 5, isNegative: false),
                Literal(number: 3, isNegative: false),
                Literal(number: 4, isNegative: false),
            ],
            [
                Literal(number: 3, isNegative: true),
                Literal(number: 4, isNegative: true),
            ],
        ])
    }

    func testSolve() throws {
        let content = """
p cnf 2 1
1 0
2 0
"""
        let lines = content.split(whereSeparator: \.isNewline)
        var dimacs = DIMACS(source: lines.makeIterator())
        let cnf = try dimacs.nextCNF()!
        let solutions = Array(cnf.solve())
        for solution in solutions {
            print(solution)
        }
        print(solutions.count)
    }
}
