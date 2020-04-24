# Basic Vitual Machine

## Made with LUA 5.3

This is a stack based virtual machine

Instructions :\
PSH A -> push A to TOS\
POP   -> pop TOS\
ADD   -> pop TOS-1 and TOS, add values, store in TOS\
SUB   -> pop TOS-1 (a) and TOS (b), subsitute (b) to (a), store in TOS\
MUL   -> pop TOS-1 and TOS, multiply values, store in TOS\
JNP A -> jump to program[A]\
JNZ A -> jump to program[A] if TOS not zero
