
struct Literal: Hashable {
    var number: Int
    var isNegative: Bool

    func eval(solution: [Bool]) -> Bool {
        let bool = solution[number - 1]
        return isNegative ? !bool : bool
    }
}

typealias Clause = Set<Literal>

extension Clause {
    fileprivate func eval(solution: [Bool]) -> Bool {
        self.reduce(false) { $0 || $1.eval(solution: solution) }
    }

    fileprivate var stringExpression: String {
        self.map { "\($0.isNegative ? "-" : "")x\($0.number)" }.joined(separator: " or ")
    }
}

public struct CNF {
    let clauses: Set<Clause>
    let numberOfVariables: Int

    func eval(solution: [Bool]) -> Bool {
        self.clauses.reduce(true) { $0 && $1.eval(solution: solution) }
    }

    public func solve() -> AnySequence<[Bool]> {
        let maxSolution = (1 << numberOfVariables) - 1

        return AnySequence((0...maxSolution).lazy.compactMap { candidate -> [Bool]? in
            let solution = (0..<numberOfVariables).map { index in
                (candidate & (1 << index)) != 0
            }
            return eval(solution: solution) ? solution : nil
        })
    }
}

extension CNF: CustomStringConvertible {
    public var description: String {
        self.clauses.map { "(" + $0.stringExpression + ")" }.joined(separator: " and ")
    }
}
