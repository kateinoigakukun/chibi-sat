
public struct Literal: Hashable {
    public var number: Int
    public var isNegative: Bool

    public var inverse: Literal {
        Literal(number: number, isNegative: !isNegative)
    }

    func eval(solution: [Bool]) -> Bool {
        let bool = solution[number - 1]
        return isNegative ? !bool : bool
    }
}

public typealias Clause = Set<Literal>

fileprivate extension Clause {
    func eval(solution: [Bool]) -> Bool {
        self.reduce(false) { $0 || $1.eval(solution: solution) }
    }

    var stringExpression: String {
        self.map { "\($0.isNegative ? "-" : "")x\($0.number)" }.joined(separator: " or ")
    }
}

public struct CNF {
    var clauses: [Clause]
    var numberOfVariables: Int

    public init(clauses: [Clause], numberOfVariables: Int) {
        self.clauses = clauses
        self.numberOfVariables = numberOfVariables
    }

    func eval(solution: [Bool]) -> Bool {
        self.clauses.reduce(true) { $0 && $1.eval(solution: solution) }
    }

    public func solve() -> AnySequence<[Bool]> {
        #if CHIBISAT_USE_BASELINE
        let maxSolution = (1 << numberOfVariables) - 1

        return AnySequence((0...maxSolution).lazy.compactMap { candidate -> [Bool]? in
            let solution = (0..<numberOfVariables).map { index in
                (candidate & (1 << index)) != 0
            }
            return eval(solution: solution) ? solution : nil
        })
        #else
        var copy = self
        var solution: [Bool?] = Array(repeating: nil, count: numberOfVariables)
        let isSatisfiable = runDPLL(cnf: &copy, solution: &solution)
        return AnySequence(isSatisfiable ? [solution.map { $0 ?? false }] : [])
        #endif
    }
}

extension CNF: CustomStringConvertible {
    public var description: String {
        self.clauses.map { "(" + $0.stringExpression + ")" }.joined(separator: " and ")
    }
}

extension CNF {

    public mutating func newVariable() -> Literal {
        numberOfVariables += 1
        return Literal(number: numberOfVariables, isNegative: false)
    }

    public mutating func addClause(_ clause: Clause) {
        clauses.append(clause)
    }
}
