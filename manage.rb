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
  puts package
  begin
    g = Git.open(path)
    current_tags = g.describe('HEAD', {:tags => true})
    current_v = strip_v(current_tags) 
    if package.key?("version")
      puts "has version"
      specified_v = strip_v(package['version'])
      checkout_str = 'tags/%s' % specified_v
      if Gem::Version.new(current_v) != Gem::Version.new(specified_v)
        g.checkout(checkout_str)
      end
    end
  rescue
    g = Git.clone(package['location'], path)
    if package.key?("version")
      checkout_str = 'tags/%s' % package['version']
    else
      checkout_str = 'master'
      g.checkout(checkout_str)
    end
  end
end
