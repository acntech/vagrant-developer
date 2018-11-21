## Customize VirtualBox settings

Use the approach specified below to change the default settings of the VirtualBox VM, such as changing the amount of memory or numer of CPUs.

Warning: Do not change the settings directly in the VirtualBox Manager, as these changed are reset the next time you run ```vagrant up```.

### Setup

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
