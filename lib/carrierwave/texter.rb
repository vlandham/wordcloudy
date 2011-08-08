require 'sanitize'
require 'fileutils'

module CarrierWave
  module Texter
    module ClassMethods
      def texter()
        process :texter
      end
    end

    def texter()
      puts "------ current path"
      puts current_path
      puts "------------------"
      directory = File.dirname( current_path )
      tmpfile   = File.join( directory, "tmpfile" )

      FileUtils.mv( current_path, tmpfile )

      file_html = File.open(tmpfile).read
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      valid_string = ic.iconv(file_html + ' ')[0..-2]
      file_text = Sanitize.clean(valid_string)
      File.open(current_path, 'w') do |file|
        file.puts file_text
      end

      File.delete( tmpfile )
    end
  end
end