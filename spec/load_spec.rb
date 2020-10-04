require 'fileutils'
require_relative '../manage' 
include Runner
require_relative './utils'
include Utils
require 'securerandom'


describe 'load' do
  before(:each) do
    @TEST_DIR = '/tmp/%s' % SecureRandom.alphanumeric
    TEST_SOURCE_DIR = '%s/repo/' % @TEST_DIR
    TEST_PLUGIN_STORAGE_DIR = '%s/store/' % @TEST_DIR
    TEST_REPOSITORY_NAME = 'location.git'
    TEST_FULL_REPOSITORY_SOURCE = File.join(TEST_SOURCE_DIR, TEST_REPOSITORY_NAME)
    TEST_FULL_REPOSITORY_STORAGE = File.join(TEST_PLUGIN_STORAGE_DIR, TEST_REPOSITORY_NAME)
    Dir.mkdir @TEST_DIR
    Dir.mkdir TEST_SOURCE_DIR
    Dir.mkdir TEST_FULL_REPOSITORY_SOURCE
    Utils.create_source_repo(TEST_FULL_REPOSITORY_SOURCE)
    @TEST_CONFIG = {
      'plugins' => []
    }
    @TEST_CONFIG['plugins'].push({"name" => TEST_REPOSITORY_NAME, "location"=>TEST_FULL_REPOSITORY_SOURCE, "version"=> "whim"})
  end


  it 'installs first time' do
    Utils.tag_repo(TEST_FULL_REPOSITORY_SOURCE, "whim")
    Runner.run_script(@TEST_CONFIG["plugins"], TEST_PLUGIN_STORAGE_DIR) 
    entries = Dir.children TEST_PLUGIN_STORAGE_DIR
    expect(entries.length()).to eql(1)
    expect(entries[0]).to eql(TEST_REPOSITORY_NAME)
  end


  it 'reinstalls' do
    Utils.tag_repo(TEST_FULL_REPOSITORY_SOURCE, "whim")
    Runner.run_script(@TEST_CONFIG["plugins"], TEST_PLUGIN_STORAGE_DIR) 
    Runner.run_script(@TEST_CONFIG["plugins"], TEST_PLUGIN_STORAGE_DIR)
    entries = Dir.children TEST_PLUGIN_STORAGE_DIR
    expect(entries.length()).to eql(1)
    expect(entries[0]).to eql(TEST_REPOSITORY_NAME)
  end
  
  it 'checked out to the specified tag' do
    Utils.tag_repo(TEST_FULL_REPOSITORY_SOURCE, "whim")
    Runner.run_script(@TEST_CONFIG["plugins"], TEST_PLUGIN_STORAGE_DIR) 
    g = Git.open(File.join(TEST_PLUGIN_STORAGE_DIR, TEST_REPOSITORY_NAME))
    tags = g.describe('HEAD', {:tags => true})
    expect(tags).to eql("whim")
  end

  it 'fail if version specified but not found' do
    test_config = [{"name" => TEST_REPOSITORY_NAME, "location" =>TEST_FULL_REPOSITORY_SOURCE, "version"=> "whim"}]
    Runner.run_script(test_config, TEST_PLUGIN_STORAGE_DIR) 
    expect {Git.open(File.join(TEST_PLUGIN_STORAGE_DIR, TEST_REPOSITORY_NAME))}.to raise_error(ArgumentError)
  end


  after(:each) do
    FileUtils.rm_r @TEST_DIR
  end
end
