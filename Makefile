progs = permutationGenerator permutationFollower

all: $(progs)

clean:
	rm $(progs)

%: %.cpp
	$(CXX) -O3 $(CXXFLAGS) $< -o $@
