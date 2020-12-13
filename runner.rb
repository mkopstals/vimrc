require 'logger'
require 'git'
require_relative 'package.rb'
module Runner
  
  @logger = Logger.new(STDOUT)

  def run_script(j, plugin_dir)
    j.each do |package|
      path = File.join(plugin_dir, package["name"])
      pkg = GitPackage.new(package['name'], path, package) 
      if pkg.exists()
        if pkg.version() == package['version'] or pkg.version() == 'master'
          @logger.info("#{package['name']} exists with version #{package['version']}")
          next
        else
          pkg.clean()
          pkg.install()
        end
      else
        pkg.install() 
      end
    end
  end
end

