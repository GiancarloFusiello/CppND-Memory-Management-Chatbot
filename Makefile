help:
	@echo "build     - compiles the application"
	@echo "debug     - compiles the application with debug flags"
	@echo "clean     - removes the build directory"
	@echo "launch    - runs a container with the compiled application and launches the application."
	@echo "            The GUI can be viewed using a VNC client by connecting to localhost:5900"
	@echo "            and entering the password 'secret' if prompted"

.PHONY: build
build: clean
	mkdir -p build
	cd build && \
	cmake .. && \
	$(MAKE)

.PHONY: debug
debug: clean
	mkdir -p build
	cd build && \
	cmake -DCMAKE_BUILD_TYPE=debug .. && \
	$(MAKE)

.PHONY: clean
clean:
	rm -rf build

launch:
	docker-compose run --rm --service-ports chatbot
	docker-compose down --volumes --remove-orphans
