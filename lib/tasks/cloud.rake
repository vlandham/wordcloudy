R_SCRIPT_NAME = "cloud.R"

desc "create cloud"
task :create_cloud => :environment do
  cloud = Cloud.find(ENV["CLOUD_ID"])
  
end