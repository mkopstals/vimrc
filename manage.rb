require 'rubygems'
require 'bundler/setup'

require "json"
require "git"


CUR_DIR = File.expand_path File.dirname(__FILE__)

def read_and_parse_json(path)
  file = File.open path
  data = JSON.load file
  packages = data["plugins"]
  return packages
end

def strip_v(version)
  return version.tr('v', '')
end

module Runner

  def run_script(j, plugin_dir)
    j.each do |package|
      path = File.join(plugin_dir, package[:name])
      begin
        g = Git.open(path)
        current_tags = g.describe('HEAD', {:tags => true})
        current_v = strip_v(current_tags) 
        if package.key?("version")
          specified_v = strip_v(package['version'])
          checkout_str = 'tags/%s' % specified_v
          if Gem::Version.new(current_v) != Gem::Version.new(specified_v)
            g.checkout(checkout_str)
          end
        end
      rescue
        g = Git.clone(package[:location], path)
        if package.key?("version")
          checkout_str = 'tags/%s' % package['version']
        else
          checkout_str = 'master'
          g.checkout(checkout_str)
        end
      end
    end
  end
end

if __FILE__ == $0
  config_path = ARGV[0]  
  directory_path = ARGV[1]
  PLUGIN_DIR = File.join(CUR_DIR, directory_path)
  CONFIG_PATH = File.join(CUR_DIR, config_path)
  config = read_and_parse_json(CONFIG_PATH)
  Runner.run_script(config, directory_path) 
end
