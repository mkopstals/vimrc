require "json"
require "git"


CUR_DIR = File.expand_path File.dirname(__FILE__)
PLUGIN_DIR = File.join(CUR_DIR, "sources_non_forked")

def read_and_parse_json
  file = File.open "config.json"
  data = JSON.load file
  packages = data["plugins"]
  return packages
end



def check_package(package)
  puts package["name"]
  puts File.directory?(File.join(PLUGIN_DIR, package["name"]))
end

    
j = read_and_parse_json()
for i in j do
  check_package(i)
end
