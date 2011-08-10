require 'fileutils'

R_SCRIPT_NAME = "cloud.R"

class Cloud < ActiveRecord::Base
  mount_uploader :document, DocumentUploader
  
  validates_presence_of :document, :message => " Missing! Upload a document first."
  
  def preview_url
    File.join("/clouds", self.id.to_s, "cloud_preview.png")
  end
  
  def preview_small_url
    File.join("/clouds", self.id.to_s, "cloud_preview_small.png")
  end
  
  def preview_thumb_url
     File.join("/clouds", self.id.to_s, "cloud_thumb_small.png")
  end
  
  def preview_full_location
    File.expand_path(File.join(RAILS_ROOT, "public", preview_url))
  end
  
  def preview_small_full_location
    File.expand_path(File.join(RAILS_ROOT, "public", preview_small_url))
  end
  
  def preview_thumb_full_location
    File.expand_path(File.join(RAILS_ROOT, "public", preview_thumb_url))
  end
  
  def pdf_location
    File.expand_path(File.join(RAILS_ROOT, "clouds", self.id.to_s, "cloud.pdf"))
  end
  
  def create_cloud
    r_script = File.expand_path(File.join(RAILS_ROOT, "R", R_SCRIPT_NAME))
    FileUtils.mkdir_p(File.dirname(pdf_location))
    FileUtils.mkdir_p(File.dirname(preview_full_location))
    text_file_path = File.expand_path(File.join(RAILS_ROOT, "public", self.document_url(:text)))
    system("R --slave --args #{self.pdf_location} #{text_file_path}< #{r_script}")
    
    img_list = Magick::ImageList.new
    img_list = img_list.read(pdf_location)
    img_list.new_image(img_list.first.columns, img_list.first.rows) { self.background_color = "white" }
    img = img_list.reverse.flatten_images
    preview = img.resize_to_fit(600, 800)
    preview.write preview_full_location
    small = preview.scale(0.75)
    small.write preview_small_full_location
     
    thumb = preview.resize_to_fill(240, 240)
    thumb.write preview_thumb_full_location
    
    update_attribute(:previewed_at, Time.now)
  end
end
