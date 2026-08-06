SHELL = /bin/bash

progs = ./permutationGenerator ./permutationFollowerSequential
numIter = 5
maxPerm = 1048576
outputPrefix = testPerm

inc_dir = perf-cpp/include/
lib_dir = perf-cpp/lib64/
LIBS = -pthread -lperf-cpp

.PHONY: all clean test generate test testbatch

all: $(progs)

clean:
	rm $(progs)

generate: permutationGenerator
	for ((curSize=1; curSize <= $(maxPerm); curSize*=2)); \
	do \
		./$< $$curSize > $(outputPrefix)$$curSize; \
	done

./permutationFollowerSequential: $(lib_dir)

$(lib_dir): perf-cpp
	 cd perf-cpp && git checkout v1.0 && cmake . -B build -DCMAKE_INSTALL_PREFIX=./ && cmake --build build && cmake --install build

perf-cpp: 
	git clone https://github.com/jmuehlig/perf-cpp.git

test: $(progs)
	./tester.sh $(progs) $(numIter) $(maxPerm) $(outputPrefix)Raw

testbatch: $(progs)
	sbatch -o $(outputPrefix)Batch ./tester.sh $(progs) $(numIter) $(maxPerm) $(outputPrefix)BatchRaw

%: %.cpp
	$(CXX) -O3 $(CXXFLAGS) -I$(inc_dir) -L$(lib_dir) $< -o $@ $(LIBS) 
