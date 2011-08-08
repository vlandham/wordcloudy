require 'fileutils'

R_SCRIPT_NAME = "cloud.R"

class Cloud < ActiveRecord::Base
  mount_uploader :document, DocumentUploader
  
  def preview_url
    File.join("/clouds", self.id.to_s, "cloud_preview.png")
  end
  
  def preview_small_url
    File.join("/clouds", self.id.to_s, "cloud_preview_small.png")
  end
  
  def preview_full_location
    File.expand_path(File.join(RAILS_ROOT, "public", preview_url))
  end
  
  def preview_small_full_location
    File.expand_path(File.join(RAILS_ROOT, "public", preview_small_url))
  end
  
  def create_cloud_preview
    r_script = File.expand_path(File.join(RAILS_ROOT, "R", R_SCRIPT_NAME))
    FileUtils.mkdir_p(File.dirname(preview_full_location))
    text_file_path = File.expand_path(File.join(RAILS_ROOT, "public", self.document_url(:text)))
    system("R --slave --args #{self.preview_full_location} #{text_file_path}< #{r_script}")
    
    img = Magick::Image.read(preview_full_location).first
    thumb = img.scale(0.75)
    thumb.write preview_small_full_location
    
    update_attribute(:previewed_at, Time.now)
  end
end
