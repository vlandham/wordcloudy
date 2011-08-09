# encoding: UTF-8
require 'sanitize'
require 'cgi'
require 'fileutils'

PDF_BOX_JAR = File.expand_path(File.join(RAILS_ROOT, "java", "pdfbox-app-1.6.0.jar"))

module CarrierWave
  module Texter
    module ClassMethods
      def texter()
        process :texter
      end
    end

    def texter()
      directory = File.dirname(current_path)
      tmpfile   = File.join(directory, "tmpfile")
      
      name, extension = split_extension(current_path)
      
      if extension == "pdf"
        extract_from_pdf current_path, tmpfile
      else
        extract_from_text current_path, tmpfile
      end

    end
    
    def split_extension(filename)
      # regular expressions to try for identifying extensions
      extension_matchers = [
        /\A(.+)\.(tar\.gz)\z/, # matches "something.tar.gz"
        /\A(.+)\.([^\.]+)\z/ # matches "something.jpg"
      ]
 
      extension_matchers.each do |regexp|
        if filename =~ regexp
          return $1, $2
        end
      end
      return filename, "" # In case we weren't able to split the extension
    end
    
    def extract_from_text file_path, temp_path
      file_html = File.open(file_path).read
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      valid_string = ic.iconv(file_html + ' ')[0..-2]
      #file_html.encode!('utf-8', 'utf-8',  :invalid => :replace, :undef => :replace, :replace => "")
      valid_string.gsub! /\r\n?/, "\n"
      valid_string.gsub! /&#.{2,5};/, ""
      

      Sanitize.clean!(valid_string)
      File.open(current_path, 'w') do |file|
        file.puts valid_string
      end
    end
    
    def extract_from_pdf file_path, temp_path
      command = "java -jar #{PDF_BOX_JAR} ExtractText -encoding UTF-8 -force #{file_path} #{temp_path}"
      system(command)
      FileUtils.mv temp_path, file_path
    end
  end
end