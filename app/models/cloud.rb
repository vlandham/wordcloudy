require 'fileutils'
require File.join(Rails.root, "lib", "texter", "texter")

R_SCRIPT = File.expand_path(File.join(Rails.root.to_s, "R", "cloud.R"))

class Cloud < ActiveRecord::Base
  mount_uploader :document, DocumentUploader
  
  validates_presence_of :document, :message => "File Missing! Upload a file first."
  validates_integrity_of :document
  
  def preview_url(type = nil)
    filename = case(type)
    when :small
      "cloud_preview_small.png"
    when :thumb
      "cloud_preview_thumb.png"
    else
      "cloud_preview.png"
    end
    File.join("/clouds", self.id.to_s, filename)
  end
  
  def preview_path(type = nil)
    url = preview_url(type)
    File.expand_path(File.join(Rails.root.to_s, "public", url))
  end
  
  def pdf_path
    File.expand_path(File.join(Rails.root.to_s, "clouds", self.id.to_s, "cloud.pdf"))
  end
  
  def text_path
    document_path + ".txt"
  end
  
  def document_path
    File.expand_path(File.join(Rails.root, "public", document_url))
  end
  
  def create_previews
    img_list = Magick::ImageList.new
    img_list = img_list.read(pdf_path)
    img_list.new_image(img_list.first.columns, img_list.first.rows) { self.background_color = "white" }
    img = img_list.reverse.flatten_images
    
    preview = img.resize_to_fit(600, 800)
    preview.write preview_path
    
    small = preview.scale(0.75)
    small.write preview_path(:small)
   
    thumb = preview.resize_to_fill(240, 240)
    thumb.write preview_path(:thumb)
  end
  
  def create_cloud
   begin
      FileUtils.mkdir_p(File.dirname(pdf_path))
      FileUtils.mkdir_p(File.dirname(preview_path))
      
      Texter.to_text(document_path, text_path)
      system("R --slave --args #{pdf_path} #{text_path} < #{R_SCRIPT}")
      create_previews
    rescue
      update_attribute(:error, true)
    ensure
      update_attribute(:previewed_at, Time.now)
    end
  end
  
  
end
