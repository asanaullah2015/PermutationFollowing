progs = permutationGenerator permutationFollower
numIter = 5
maxPerm = 1048576

.PHONY: all clean test

all: $(progs)

clean:
	rm $(progs)

test: $(progs)
	./tester.sh ./permutationGenerator ./permutationFollower $(numIter) $(maxPerm)

testbatch: $(progs)
	sbatch ./tester.sh ./permutationGenerator ./permutationFollower $(numIter) $(maxPerm)
%: %.cpp
	$(CXX) -O3 $(CXXFLAGS) $< -o $@
