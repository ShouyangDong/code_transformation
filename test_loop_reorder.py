"""
for (jnt j = 0; j < 8; ++j) {
    for (int k = 0;k < 64; ++k) {
        B[j * 64 + k] = A[j * 64 + k] + 1.0;
    }
}
================
for (int k = 0; k < 64; ++k) {
    for (jnt j = 0; j < 8; ++j) {
        B[j * 64 + k] = A[j * 64 + k] + 1.0;
    }
}
"""

from z3 import *

# 创建Z3求解器
solver = Solver()

# 创建变量
i = Int('i')
j = Int('j')


# 添加约束条件
constraint1 = And(i >= 0, i < 512)
constraint2 = And(j >= 0, j < 8)
constraint3 = And(k >= 0, k < x)

# 创建量化公式的主体
body = And(
    Select(A, i) == Select(A, j * y + k),
    Select(B, i) == Select(B, j * y + k)
)

# 创建量化公式
quantifier = ForAll([i, j, k,], body)

# 添加约束条件到求解器
solver.add(constraint1, constraint2, constraint3, quantifier)

# 检查等效性
is_equivalent = solver.check() == sat

if is_equivalent:
    model = solver.model()
    print("[INFO]************model: ", model)
    print("两段代码是等效的")
else:
    print("两段代码不等效")