PROTO_ROOT=.
DOCKER_IMAGE=proto-builder
PROTO_FILES=$(shell find account pagination -name '*.proto')

.PHONY: docker-build gen clean

docker-build:
	docker build -t $(DOCKER_IMAGE) .

gen: docker-build
	@for dir in account pagination; do \
	  mkdir -p $$dir/go; \
	done
	docker run --rm -v $(abspath $(PROTO_ROOT)):/app $(DOCKER_IMAGE) \
	  bash -c '\
	    set -e; \
	    for file in $(PROTO_FILES); do \
	      dir=$$(dirname $$file); \
	      echo ">> Generating for $$file into $$dir/go"; \
	      protoc \
	        -I /app \
	        -I /usr/local/include \
	        -I /usr/local/include/googleapis \
	        --go_out=/app/$$dir/go \
	        --go_opt=paths=source_relative \
	        --go-grpc_out=/app/$$dir/go \
	        --go-grpc_opt=paths=source_relative \
	        /app/$$file; \
	    done \
	  '

clean:
	find account pagination -type d -name go -exec rm -rf {} +