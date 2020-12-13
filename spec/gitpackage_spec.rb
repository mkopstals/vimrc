require_relative '../package'
require_relative './utils'
include Utils

describe 'package remote' do
  before(:each) do
    @TEST_DIR = '/tmp/%s' % SecureRandom.alphanumeric
    TEST_SOURCE_DIR = '%s/repo/' % @TEST_DIR
    TEST_REPOSITORY_NAME = 'location.git'
    TEST_FULL_REPOSITORY_SOURCE = File.join(TEST_SOURCE_DIR, TEST_REPOSITORY_NAME)
    Dir.mkdir @TEST_DIR
    Dir.mkdir TEST_SOURCE_DIR
    Dir.mkdir TEST_FULL_REPOSITORY_SOURCE
    Utils.create_source_repo(TEST_FULL_REPOSITORY_SOURCE)
    @p = GitPackage.new(TEST_REPOSITORY_NAME, '', {'location': TEST_FULL_REPOSITORY_SOURCE})
  end

  it 'can determine remote commits' do
    puts Git.ls_remote(TEST_FULL_REPOSITORY_SOURCE)
    expect(@p.remote_head()).to eql(Git.ls_remote(TEST_FULL_REPOSITORY_SOURCE)["head"][:sha])
  end

  after(:each) do
    FileUtils.rm_r @TEST_DIR
  end
end
