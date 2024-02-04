# 导入Z3库
from z3 import *
import z3
# 创建Z3求解器
solver = Solver()

# 定义变量
x = Int('x')
y = Int('y')

z = x < y
t = x < 2


goal = z3.ForAll(
    [x],  
    z == t,
)

solver.add(goal)
solver.check()
output = solver.model()
print(output)
