# == Class: vmware_fact
#
# This is simply a placeholder class which provides a fact which tells a node
# a little information about the hypervisor on which it lives in vmware
# environments
#
# === Authors
#
# Wolf Noble <wolf@wolfspyre.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class vmware_puppetfact (
	$dmidecode_version = undef,
) {
	$destpath = 'C:\ProgramData\edge'
	$filename = 'dmidecode.exe'
	$dmidecode = "${destpath}\\${filename}"

	if (downcase($::osfamily) == 'windows'){
		ewhlib::filestorage::fetchfile { $dmidecode:
			provider => "artifactory",
			format => "exe",
			group => "dmidecode",
			version => "$dmidecode_version",
			folder => "false",
			package => "dmidecode",
			platform => "x86",
			require => [
				File[$destpath],
			],
		}
	}
}