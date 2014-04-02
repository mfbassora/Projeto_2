make clean
make compile
make run INPUT=test/teste.java OUTPUT=teste.s
make bytecode INPUT=teste.s OUTPUT=teste.bc
lli teste.bc
