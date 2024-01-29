#lang rosette/safe
(require rosette/solver/smt/z3)

(define-symbolic n integer?) ; 循环迭代次数的上界
(define-symbolic j integer?) ; 外部循环迭代变量
(define-symbolic k integer?) ; 内部循环迭代变量

(assert (>= j 0))
(assert (< j 8))
(assert (>= k 0))
(assert (< k 64))
(assert (= (+ (* j 64) k) jnt)) ; 计算内部循环的迭代变量 jnt
(assert (not (>= jnt n))) ; 检查是否存在冲突

(solve (>= jnt 0))
