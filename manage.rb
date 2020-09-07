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

def strip_v(version)
  return version.tr('v', '')
end

j = read_and_parse_json()
for package in j do
  path = File.join(PLUGIN_DIR, package["name"])
  puts path
  g = Git.open(path)
  current_tags = g.describe('HEAD', {:tags => true})
  current_v = strip_v(current_tags) 
  specified_v = strip_v(package['version'])
  if Gem::Version.new(current_v) != Gem::Version.new(specified_v)
    g.checkout('tags/%s' % package['version'])
  end
end
