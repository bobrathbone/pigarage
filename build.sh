#!/bin/bash
# $Id: build.sh,v 1.1 2014/06/18 14:27:26 bob Exp $
PKG=garage-web
VERSION=$(grep ^Version: ${PKG} | awk '{print $2}')
ARCH=$(grep ^Architecture: ${PKG} | awk '{print $2}')
DEBPKG=${PKG}_${VERSION}_${ARCH}.deb

# Set up default passwords
rm -f passwd/.htaccess
htpasswd -c -b  passwd/.htaccess open sesame
htpasswd -b  passwd/.htaccess fred astair

echo "Building package ${PKG} version ${VERSION}"
equivs-build ${PKG}
if [[ $? -ne 0 ]]; then
	exit 1
fi

echo -n "Check using Lintian y/n: "
read ans
if [[ ${ans} == 'y' ]]; then
	echo "Checking package ${DEBPKG} with lintian"
	lintian ${DEBPKG}
	if [[ $? = 0 ]]
	then
	    dpkg -c ${DEBPKG}
	    echo "Package ${DEBPKG} OK"
	else
	    echo "Package ${DEBPKG} has errors"
	fi
fi

# End of build script
