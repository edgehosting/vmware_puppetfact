require 'facter'

Facter.add(:vmwaretoolsVersion) do
  #default for non-vmware nodes
  setcode do
    nil
  end
end

Facter.add(:vmwaretoolsVersion) do
  confine :virtual => :vmware
  #VMWare, but not linux or windows
  setcode do
    'vmware'
  end
end

Facter.add(:vmwaretoolsVersion) do
  confine :virtual => :vmware
  confine :kernel => :linux
  #vmware and linux. whee!
  setcode do
    hasbinary = Facter::Util::Resolution.exec('which vmware-toolbox-cmd')
    if (hasbinary.nil? == true)
      result = 'vmware'
    else
      result = tools_version(hasbinary)
    end
  end
end

#Windows
path = "c:/program files/vmware/vmware tools/vmwaretoolboxcmd.exe"
Facter.add(:vmwaretoolsVersion) do
  confine :virtual => :vmware
  confine :kernel => :windows
  #vmware and windows. whee!
  setcode do
    hasbinary = File.exist?(path)
    if (hasbinary == false)
      result = 'vmware'
    else
      result = tools_version(path)
    end
  end
end

def tools_version(path)
  foobar = Facter::Util::Resolution.exec("\"#{path}\" -v")
  if foobar.nil?
    retval='vmware'
  else
    if foobar.match(/^[0-9]\.[0-9]/)
      # we're good
      retval = foobar
    else
      # unknown format
      retval = "unknownFormat"
    end
  end
  return retval
end