progs = permutationGenerator permutationFollower
numIter = 5
maxPerm = 1048576
outputPrefix = testPerm

.PHONY: all clean test

all: $(progs)

clean:
	rm $(progs)

test: $(progs)
	./tester.sh ./permutationGenerator ./permutationFollower $(numIter) $(maxPerm) $(outputPrefix)Raw

testbatch: $(progs)
	sbatch -o $(outputPrefix) ./tester.sh ./permutationGenerator ./permutationFollower $(numIter) $(maxPerm) $(outputPrefix)Raw

%: %.cpp
	$(CXX) -O3 $(CXXFLAGS) $< -o $@
