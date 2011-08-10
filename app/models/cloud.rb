require 'fileutils'
require File.join(Rails.root, "lib", "texter", "texter")

R_SCRIPT_NAME = "cloud.R"

class Cloud < ActiveRecord::Base
  mount_uploader :document, DocumentUploader
  
  validates_presence_of :document, :message => " Missing! Upload a file first."
  validates_integrity_of :document
  
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
    File.expand_path(File.join(Rails.root.to_s, "public", preview_url))
  end
  
  def preview_small_full_location
    File.expand_path(File.join(Rails.root.to_s, "public", preview_small_url))
  end
  
  def preview_thumb_full_location
    File.expand_path(File.join(Rails.root.to_s, "public", preview_thumb_url))
  end
  
  def pdf_location
    File.expand_path(File.join(Rails.root.to_s, "clouds", self.id.to_s, "cloud.pdf"))
  end
  
  def create_cloud
   # begin
      r_script = File.expand_path(File.join(Rails.root.to_s, "R", R_SCRIPT_NAME))
      FileUtils.mkdir_p(File.dirname(pdf_location))
      FileUtils.mkdir_p(File.dirname(preview_full_location))
      
      text_file_path = Texter.to_text(self.document_url)
      
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
    #rescue
   #   update_attribute(:preview_error, true)
    #ensure
    #  update_attribute(:previewed_at, Time.now)
    #end
  end
end
