#!/usr/bin/env ruby

require 'benchmark'
require 'fileutils'

data_path = File.expand_path(File.join(File.dirname(__FILE__), "data", "holmes.txt"))
result_path = File.expand_path(File.join(File.dirname(__FILE__), "sandbox", "wordcloud.pdf"))
r_script = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "R", "cloud.R"))

FileUtils.mkdir_p File.dirname(result_path)

time = Benchmark.measure do
  system("R --slave --args #{result_path} #{data_path}< #{r_script}") 
end

puts time