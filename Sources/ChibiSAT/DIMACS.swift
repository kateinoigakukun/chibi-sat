/// https://www.cs.utexas.edu/users/moore/acl2/manuals/current/manual/index-seo.php/SATLINK____DIMACS
public struct DIMACS<LineSource> where LineSource: IteratorProtocol,
                                LineSource.Element: StringProtocol {

    var source: LineSource
    public init(source: LineSource) {
        self.source = source
    }

    enum Error: Swift.Error {
        case invalidPLine(String)
        case invalidClauseLine(String)
        case unexpectedClauseLine(String)
        case missingPLine
    }
    
    public mutating func nextCNF() throws -> CNF? {
        var numberOf: (variables: Int, clauses: Int)?
        var clauses: Set<Clause> = []

        while let line = self.source.next() {
            let components = line.split(whereSeparator: \.isWhitespace)
            guard !components.isEmpty else { continue }
            let command = components[0]
            switch command {
            case "c":
                // Skip comment lines
                continue
            case "p":
                guard components.count > 3 && components[1] == "cnf" else {
                    throw Error.invalidPLine(String(line))
                }
                guard let variables = Int(components[2]),
                      let clauses = Int(components[3]) else {
                    throw Error.invalidPLine(String(line))
                }
                numberOf = (variables, clauses)
            default:
                var vars: Set<Literal> = []
                for n in components {
                    guard let n = Int(n) else {
                        throw Error.invalidClauseLine(String(line))
                    }
                    guard n != 0 else { break }
                    vars.insert(Literal(number: abs(n), isNegative: n < 0))
                }
                clauses.insert(vars)
                guard let numberOfClauses = numberOf?.clauses else {
                    throw Error.unexpectedClauseLine(String(line))
                }
                if clauses.count == numberOfClauses {
                    break
                }
            }
        }
        guard let numberOfVariables = numberOf?.variables else {
            return nil
        }
        return CNF(clauses: clauses, numberOfVariables: numberOfVariables)
    }
}

extension DIMACS: IteratorProtocol {
    public mutating func next() -> Result<CNF, Swift.Error>? {
        do {
            guard let cnf = try self.nextCNF() else {
                return nil
            }
            return .success(cnf)
        } catch {
            return .failure(error)
        }
    }
}
