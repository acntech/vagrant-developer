# AcnTech Ubuntu Developer

Add a virtualbox_settings.rb file in this folder to customize VirtualBox settings.

File content example:
```
class VirtualBoxSettings

  attr_reader :memory, :gui, :box_name, :monitors, :cpus

  def initialize()
    @box_name = "AcnTech Ubuntu Developer"
    @monitors = "1"
    @gui = true
    @memory = "4096"
    @cpus = "2"
  end

  def setup_box(vb)
    vb.name = @box_name
    vb.customize ["modifyvm", :id, "--monitorcount", @monitors]
    vb.gui = @gui
    vb.memory = @memory
    vb.cpus = @cpus
  end
end
```
