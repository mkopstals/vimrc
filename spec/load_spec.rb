require 'fileutils'
require_relative '../manage'
include Runner
require_relative './utils'
include Utils


describe 'load' do
  before(:each) do
    TEST_DIR = '/tmp/test'
    TEST_SOURCE_DIR = '%s/repo/' % TEST_DIR
    TEST_PLUGIN_STORAGE_DIR = '%s/store/' % TEST_DIR
    TEST_REPOSITORY_NAME = 'location.git'
    TEST_FULL_REPOSITORY_SOURCE = File.join(TEST_SOURCE_DIR, TEST_REPOSITORY_NAME)
    TEST_FULL_REPOSITORY_STORAGE = File.join(TEST_PLUGIN_STORAGE_DIR, TEST_REPOSITORY_NAME)
    Dir.mkdir TEST_DIR
    Dir.mkdir TEST_SOURCE_DIR
    Dir.mkdir TEST_FULL_REPOSITORY_SOURCE
    Dir.mkdir '%s/.git/' % TEST_FULL_REPOSITORY_SOURCE
    Utils.create_source_repo(TEST_FULL_REPOSITORY_SOURCE)
    @TEST_CONFIG = {
      'plugins' => []
    }
    @TEST_CONFIG['plugins'].push({:name => TEST_REPOSITORY_NAME, :location =>TEST_FULL_REPOSITORY_SOURCE})


  end


  it 'installs first time' do

    Runner.run_script(@TEST_CONFIG["plugins"], TEST_PLUGIN_STORAGE_DIR) 
    entries = Dir.children TEST_PLUGIN_STORAGE_DIR
    expect(entries.length()).to eql(1)
    expect(entries[0]).to eql('location.git')
  end


  it 'installs' do
    Runner.run_script(@TEST_CONFIG["plugins"], TEST_PLUGIN_STORAGE_DIR) 
    Runner.run_script(@TEST_CONFIG["plugins"], TEST_PLUGIN_STORAGE_DIR)
    entries = Dir.children TEST_PLUGIN_STORAGE_DIR
    expect(entries.length()).to eql(1)
    expect(entries[0]).to eql('location.git')
  end


  after(:each) do
    FileUtils.rm_r '/tmp/test'
  end
end
