package handler

import (
	"bytes"
	"io"
	"net/http"
	"sync"

	"github.com/google/uuid"

	"image/upload/gen/pb"
)

type ImageUploadHandler struct {
	sync.Mutex
	files map[string][]byte
}

func NewImageUploadHandler() *ImageUploadHandler {
	return &ImageUploadHandler{
		files: make(map[string][]byte),
	}
}

func (h *ImageUploadHandler) Upload(
	stream pb.ImageUploadService_UploadServer,
) error {
	req, err := stream.Recv()
	if err != nil {
		return err
	}

	// 最初のリクエストを受け取る
	meta := req.GetFileMeta()
	filename := meta.Filename

	//UUIDの生成
	u, err := uuid.NewRandom()
	if err != nil {
		return err
	}
	uuid := u.String()

	//バイナリ格納用バッファ
	buf := &bytes.Buffer{}

	//チャンク（塊）ごとにアップロードされたバイナリをループしながら全て受け取る
	for {
		//2回目以降のリクエスト
		r, err := stream.Recv()

		//ストリームが終端に達した場合は終了する
		if err == io.EOF {
			break
		} else if err != nil {
			return err
		}

		//チャンクを受け取ってバッファに書き込む
		chunk := r.GetData()
		_, err = buf.Write(chunk)
		if err != nil {
			return err
		}
	}

	// バッファから画像バイナリにする
	data := buf.Bytes()

	// 組み込み関数を使って画像バイナリからファイル形式を検出する
	mimeType := http.DetectContentType(data)

	h.files[uuid] = data

	err = stream.SendAndClose(&pb.ImageUploadResponse{
		Uuid:        uuid,
		Size:        int32(len(data)),
		Filename:    filename,
		ContentType: mimeType,
	})

	return err
}
