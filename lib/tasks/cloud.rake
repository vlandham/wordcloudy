
desc "create cloud"
task :create_cloud => :environment do
  cloud = Cloud.find(ENV["CLOUD_ID"])
  
  if cloud
    cloud.create_cloud
  end
  
  puts "rake task end"
  
end