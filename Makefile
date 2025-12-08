SHELL = /bin/bash

progs = permutationGenerator permutationFollower
numIter = 5
maxPerm = 1048576
outputPrefix = testPerm

.PHONY: all clean test generate test testbatch

all: $(progs)

clean:
	rm $(progs)

generate: permutationGenerator
	for ((curSize=1; curSize <= $(maxPerm); curSize*=2)); \
	do \
		./$< $$curSize > $(outputPrefix)$$curSize; \
	done

test: $(progs)
	./tester.sh $^ $(numIter) $(maxPerm) $(outputPrefix)Raw

testbatch: $(progs)
	sbatch -o $(outputPrefix) ./tester.sh $^ $(numIter) $(maxPerm) $(outputPrefix)Raw

%: %.cpp
	$(CXX) -O3 $(CXXFLAGS) $< -o $@
