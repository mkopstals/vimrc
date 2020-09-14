require 'fileutils'
require 'git'

module Utils
  def create_source_repo(source_path)
    g = Git.init(source_path, {:repository => source_path})
    mock_file_path = '%s/whenyoutrytoexitvim.txt' % source_path
    FileUtils.touch(mock_file_path)

    g.add(mock_file_path)
    g.commit('mock_commit')
    g.add_tag('whim')

  end
end
