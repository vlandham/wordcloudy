class Cloud < ActiveRecord::Base
  mount_uploader :document, DocumentUploader
end
