package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"os"
	"time"

	"google.golang.org/grpc"

	"image/upload/gen/pb"
)

var client = getClient()

func getClient() pb.ImageUploadServiceClient {
	address := "localhost:50051"
	conn, err := grpc.Dial(address, grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	return pb.NewImageUploadServiceClient(conn)
}

func uploadImage(filepath string) (*pb.ImageUploadResponse, error) {
	fp, err := os.Open(filepath)
	if err != nil {
		panic(err)
	}
	defer fp.Close()

	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	stream, _ := client.Upload(ctx)

	filemeta := &pb.ImageUploadRequest_FileMeta_{
		FileMeta: &pb.ImageUploadRequest_FileMeta{
			Filename: filepath,
		},
	}
	req := &pb.ImageUploadRequest{File: filemeta}
	stream.Send(req)

	buf := make([]byte, 100*1024)
	for {
		n, _ := fp.Read(buf)
		if n == 0 {
			break
		}
		data := &pb.ImageUploadRequest_Data{Data: buf[:n]}
		req := &pb.ImageUploadRequest{File: data}
		stream.Send(req)
	}

	r, err := stream.CloseAndRecv()
	return r, err
}

func main() {
	filepath := flag.String("f", "nekochan.jpg", "Image path")
	flag.Parse()
	r, _ := uploadImage(*filepath)
	fmt.Println(r)
}
