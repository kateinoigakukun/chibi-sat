build/picosat/picosat:
	rm -rf build/picosat
	mkdir -p build/picosat
	curl http://fmv.jku.at/picosat/picosat-965.tar.gz | \
		tar xfz picosat.tar.gz -C build/picosat --strip-components 1
	(cd build/picosat && \
		./configure.sh && \
		make picosat)

unit_bench:
	swift run -c release ChibiSATBenchmark --format json --iterations 2 | tee benchmark_result.json

.PHONY: unit_bench
