# encoding: UTF-8
require 'sanitize'
require 'cgi'
require 'fileutils'

module CarrierWave
  module Texter
    module ClassMethods
      def texter()
        process :texter
      end
    end

    def texter()
      directory = File.dirname( current_path )
      tmpfile   = File.join( directory, "tmpfile" )

      FileUtils.mv( current_path, tmpfile )

      file_html = File.open(tmpfile).read
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      valid_string = ic.iconv(file_html + ' ')[0..-2]
      #file_html.encode!('utf-8', 'utf-8',  :invalid => :replace, :undef => :replace, :replace => "")
      valid_string.gsub! /\r\n?/, "\n"
      valid_string.gsub! /&#.{2,5};/, ""
      

      Sanitize.clean!(valid_string)
      File.open(current_path, 'w') do |file|
        file.puts valid_string
      end

      File.delete( tmpfile )
    end
  end
end