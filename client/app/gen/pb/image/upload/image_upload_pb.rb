# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: image_upload.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("image_upload.proto", :syntax => :proto3) do
    add_message "image.upload.ImageUploadRequest" do
      oneof :file do
        optional :file_meta, :message, 1, "image.upload.ImageUploadRequest.FileMeta"
        optional :data, :bytes, 2
      end
    end
    add_message "image.upload.ImageUploadRequest.FileMeta" do
      optional :filename, :string, 1
    end
    add_message "image.upload.ImageUploadResponse" do
      optional :uuid, :string, 1
      optional :size, :int32, 2
      optional :content_type, :string, 3
      optional :filename, :string, 4
    end
  end
end

module Image
  module Upload
    ImageUploadRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("image.upload.ImageUploadRequest").msgclass
    ImageUploadRequest::FileMeta = Google::Protobuf::DescriptorPool.generated_pool.lookup("image.upload.ImageUploadRequest.FileMeta").msgclass
    ImageUploadResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("image.upload.ImageUploadResponse").msgclass
  end
end
