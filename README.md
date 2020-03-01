## About
-「STARTING gRPC」第6章のためのサンプルです
- クライアントサイドストリーミングで画像のチャンクドアップロードを行います
- サーバー側をGo、クライアント側をRubyで実装しています

## how to gen grpc codes
Go
```
protoc \
	-Iproto \
	--go_out=plugins=grpc:api \
	proto/*
```

Ruby
```
bundle exec grpc_tools_ruby_protoc \
	-I ../proto \
	--ruby_out=app/gen/pb/image/upload \
	--grpc_out=app/gen/pb/image/upload \
	../proto/image_upload.proto
```
