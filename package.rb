class GitPackage
  def initialize(name, path, config)
    @path = path
    @name = name
    @remote_path = config["location"]
    @config = config
  end

  def exists() 
    return File.directory?(@path)
  end

  def version()
    vimv = File.join(@path, '.vimv')
    dist_info = File.open(vimv).read
    return dist_info
  end

  def remote_head()
    puts Git.ls_remote(@remote_path)
    return Git.ls_remote(@remote_path)["head"][:sha]
  end

  def open()
    if exists()
      @g = Git.clone(@remote_path, path)
    else
      @g = Git.open(path)
    end
  end

  def get_version_info()
    specified_v = @config.fetch('version', false)
    if !specified_v
      checkout_str = 'master'
    else
      checkout_str = 'tags/%s' % specified_v
    end
    return checkout_str
  end

  def clean()
    FileUtils.remove_dir(@path)
  end

  def install() 
    @g = Git.clone(@remote_path, @path)
    checkout_info = get_version_info()
    begin
      @g.checkout(checkout_info)
    rescue Git::GitExecuteError
      clean()
      return
    end
    vimv = File.join(@path, '.vimv')
    File.write(vimv, checkout_info)
  end
end


