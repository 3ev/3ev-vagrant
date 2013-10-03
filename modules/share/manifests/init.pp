class share (
){
	file { ["/share", "/share/sphinx"]:
	    ensure => "directory",
	    owner  => "root",
	    group  => "root",
	    mode   => 777,
	}
	
	file { ["/var/log/dev"]:
	    ensure => "directory",
	    owner  => "root",
	    group  => "root",
	    mode   => 777,
	}	

	file { '/share/sphinx/sphinx.conf':
			content => template('share/sphinx.conf'),
	    	owner   => 'root',
	    	group   => 'root',
	    	mode    => '777',
			ensure  => present,
	}
	
	file { '/share/typo3.sh':
			content => template('share/typo3.sh'),
	    	owner   => 'root',
	    	group   => 'root',
	    	mode    => '777',
			ensure  => present,
	}	
}