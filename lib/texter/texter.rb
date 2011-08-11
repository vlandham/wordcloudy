# encoding: UTF-8
require 'sanitize'
require 'fileutils'

PDF_BOX_JAR = File.expand_path(File.join(Rails.root, "java", "pdfbox-app-1.6.0.jar"))


class Texter
    def self.to_text(original_path, text_file_path)
      puts "---------"
      puts "or: #{original_path}"
      puts "tx: #{text_file_path}"
      puts "---------"
      puts "---------"
      
      directory = File.dirname(text_file_path)
      
      name, extension = split_extension(original_path)
      
      puts "ext: #{extension}"
      
      if extension == "pdf"
        extract_from_pdf original_path, text_file_path
      else
        extract_from_text original_path, text_file_path
      end
      text_file_path
    end
    
    def self.split_extension(filename)
      # regular expressions to try for identifying extensions
      extension_matchers = [
        /\A(.+)\.(tar\.gz)\z/, # matches "something.tar.gz"
        /\A(.+)\.([^\.]+)\z/ # matches "something.jpg"
      ]
 
      extension_matchers.each do |regexp|
        if File.basename(filename) =~ regexp
          return $1, $2
        end
      end
      return filename, "" # In case we weren't able to split the extension
    end
    
    def self.extract_from_text original_path, text_file_path
      file_html = File.open(original_path).read
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      valid_string = ic.iconv(file_html + ' ')[0..-2]
      #file_html.encode!('utf-8', 'utf-8',  :invalid => :replace, :undef => :replace, :replace => "")
      valid_string.gsub! /\r\n?/, "\n"
      valid_string.gsub! /&#.{2,5};/, ""

      Sanitize.clean!(valid_string)
      File.open(text_file_path, 'w') do |file|
        file.puts valid_string
      end
    end
    
    def extract_from_pdf original_path, text_file_path
      command = "java -jar #{PDF_BOX_JAR} ExtractText -encoding UTF-8 -force #{original_path} #{text_file_path}"
      system(command)
      # FileUtils.mv temp_path, file_path
    end
  end
