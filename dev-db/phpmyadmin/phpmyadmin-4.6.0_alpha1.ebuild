# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/phpmyadmin/phpmyadmin-4.6.0_alpha1.ebuild,v 1.1 2016/02/26 13:42:15 vmacs Exp $

EAPI="5"

inherit eutils webapp depend.php

MY_PV=${PV/_/-}
MY_P="phpMyAdmin-${MY_PV}-all-languages"

DESCRIPTION="Web-based administration for MySQL database in PHP"
HOMEPAGE="http://www.phpmyadmin.net/"

# phpMyAdmin has migrated away from SourceForge as of July 2015.
# Source: https://www.phpmyadmin.net/news/2015/7/2/phpmyadmin-website-and-downloads-moved/
#SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"
SRC_URI="https://files.phpmyadmin.net/phpMyAdmin/${MY_PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos"
IUSE="setup"

RDEPEND="
	dev-lang/php[crypt,ctype,filter,json,session,unicode]
	|| (
		dev-lang/php[mysqli]
		dev-lang/php[mysql]
	)
"

need_httpd_cgi
need_php_httpd

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	dodoc README RELEASE-DATE-${MY_PV} ChangeLog || die
	rm -f LICENSE README* RELEASE-DATE-${MY_PV}

	if ! use setup; then
		rm -rf setup || die "Cannot remove setup utility"
		elog "The phpMyAdmin setup utility has been removed."
		elog "It is a regular target of various exploits. If you need it, set USE=setup."
	else
		elog "You should consider disabling the setup USE flag"
		elog "to exclude the setup utility if you don't use it."
		elog "It regularly is the target of various exploits."
	fi

	insinto "${MY_HTDOCSDIR#${EPREFIX}}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR#${EPREFIX}}"/libraries/config.default.php
	webapp_serverowned "${MY_HTDOCSDIR#${EPREFIX}}"/libraries/config.default.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-3.1.txt
	webapp_src_install
}
