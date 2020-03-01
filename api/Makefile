.PHONY: setup
setup:
	go get -u github.com/golang/protobuf/protoc-gen-go

.PHONY: protoc
protoc:
	protoc \
		-I../proto \
		--go_out=plugins=grpc:server \
		proto/*.proto

.PHONY: run
run:
	cd server && fresh