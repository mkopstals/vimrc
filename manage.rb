require 'rubygems'
require 'bundler/setup'

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

j = read_and_parse_json()
for package in j do
  path = File.join(PLUGIN_DIR, package["name"])
  g = Git.open(path)
  current_v = g.describe('HEAD', {:tags => true})
  if Gem::Version.new(current_v.tr('v', '')) != Gem::Version.new(package['version'].tr('v', ''))
    new_dir = g.checkout('tags/%s' % i['version'])
  end
  

end
