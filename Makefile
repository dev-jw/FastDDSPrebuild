.PHONY: build
.PHONY: frameworks

build:
	./script/fastrtps_build_xctframework.sh 2.6.0 commit &> res.log

frameworks:
	./script/fastrtps_create_frameworks.sh
	
all: build frameworks
