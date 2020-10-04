require 'git'
require_relative 'package.rb'

module Runner

  def run_script(j, plugin_dir)
    j.each do |package|
      path = File.join(plugin_dir, package["name"])
      pkg = Package.new(package['name'], path, package)
      if pkg.exists()
        if pkg.version() == package['version']
          return
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

