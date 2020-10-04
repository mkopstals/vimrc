require 'rubygems'
require 'bundler/setup'

require "json"
require "optparse"

require_relative './runner.rb'
include Runner

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

if __FILE__ == $0
  options = {
    path: 'sources_forked', 
    config: 'config.json'
  }

  OptionParser.new do |opts|
    opts.on('-p PATH', String) do |i|
      options[:path] = i
    end
    opts.on('-config CONFIG', String) do |i|
      options[:config] = i
    end
  end.parse!(into: options)

  PLUGIN_DIR = File.join(CUR_DIR, options[:path])
  CONFIG_PATH = File.join(CUR_DIR, options[:config])

  config = read_and_parse_json(CONFIG_PATH)
  Runner.run_script(config, PLUGIN_DIR) 
end
