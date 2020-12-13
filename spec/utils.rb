require 'fileutils'
require 'git'

module Utils
  def create_source_repo(source_path)
    g = Git.init(source_path, {:repository => source_path + '/.git'})
    mock_file_path = '%s/whenyoutrytoexitvim.txt' % source_path
    FileUtils.touch(mock_file_path)
    g.add(mock_file_path)
    g.commit('mock_commit')
  end

  def open_source_repo(path)
    return Git.open(path)
  end

  def tag_repo(path, tag)
    puts(path)
    g = Git.open(path)
    g.add_tag('whim')
  end
end
