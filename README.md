# ChibiSAT

A toy SAT solver written in Swift


```bash
$ cat simple.cnf
p cnf 2 1
1 0
2 0
$ swift run chibi-sat ./simple.cnf
(x1) and (x2)
s SATISFIABLE
v 1 2
```
