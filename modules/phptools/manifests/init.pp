class phptools (
) {
	include pear

	# PEAR Package
	pear::package { "PEAR": }

	# Phing
	pear::package { "Phing":
		version => "2.5.0",
		repository => "pear.phing.info",
		require => Pear::Package["PEAR"],
	}

	pear::package { "Services_Amazon_S3":
		version => '0.4.0',
		repository => "pear.php.net",
	}	
}
