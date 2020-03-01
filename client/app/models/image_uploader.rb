# frozen_string_literal:true

require Rails.root.join('app', 'gen', 'pb', 'image', 'upload', 'image_upload_pb')
require Rails.root.join('app', 'gen', 'pb', 'image', 'upload', 'image_upload_services_pb')


class ImageUploader
  include ActiveModel::Model

  # 画像をアップロードします
  def self.chunked_upload(file_path)

    # ストリーミングで送る送るリクエストを作成します
    reqs = Enumerator.new do |yielder|
      # 最初のリクエスト
      filename = File.basename(file_path)
      file_meta = Image::Upload::ImageUploadRequest::FileMeta.new(
        filename: name
	  )
	  puts "sent neme=#{filename}"
      yielder << Image::Upload::ImageUploadRequest.new(file_meta: file_meta)

      # チャンクドアップロードリクエスト
      File.open(file_path, 'r') do |f|
		while (chunk = f.read(100.kilobytes))  
		  puts "sent #{chunk.size}"
          yielder << Image::Upload::ImageUploadRequest.new(data: chunk)
        end
      end
	end

	puts 'upload start'
	# APIへリクエストを送り、レスポンスを受け取ります
    res = stub.upload(reqs)

	# レスポンスをHashにして返す
    {
      uuid: res.uuid,
      size: res.size,
      content_type: res.content_type,
      filename: res.filename
    }
  end


	def self.config_dsn
		'127.0.0.1:50051'
	end
	
	def self.stub
		Image::Upload::ImageUploadService::Stub.new(
			config_dsn,
			:this_channel_is_insecure,
			timeout: 1,
		)
	end
end
