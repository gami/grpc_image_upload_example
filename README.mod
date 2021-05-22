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

## ソース内の猫の画像について
フリー素材ぱくたそ（www.pakutaso.com）で配布されている、mi-tetteさんの画像を使用しました
https://www.pakutaso.com/20200203058post-25990.html