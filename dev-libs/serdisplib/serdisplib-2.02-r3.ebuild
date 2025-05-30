# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="Library to drive several displays with built-in controllers or display modules"
HOMEPAGE="http://serdisplib.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="threads tools"

# Define the list of valid lcd devices.
IUSE_LCD_DEVICES=(
	acoolsdcm ddusbt directgfx displaylink dpfax framebuffer glcd2usb
	goldelox i2c ks0108 l4m lc7981 lh155 nokcol pcd8544 remote
	rs232 sed133x sed153x sed156x ssdoled stv8105 t6963 vssdcp
)

printf -v mangled_lcd_devices 'lcd_devices_%s ' ${IUSE_LCD_DEVICES[@]}

# Add supported drivers from 'IUSE_LCD_DEVICES' to 'IUSE' and 'REQUIRED_USE'.
# Also enable 'lcd_devices_directgfx' as default.
IUSE+=" ${mangled_lcd_devices}"
IUSE="${IUSE/lcd_devices_directgfx/+lcd_devices_directgfx}"
REQUIRED_USE+="
	|| ( ${mangled_lcd_devices} )
	lcd_devices_framebuffer? ( threads )
"

# Specific drivers will need some features to be enabled
RDEPEND="
	media-libs/gd[jpeg,png,tiff]
	lcd_devices_acoolsdcm? ( virtual/libusb:1 )
	lcd_devices_directgfx? ( media-libs/libsdl )
	lcd_devices_displaylink? ( x11-libs/libdlo )
	lcd_devices_dpfax? ( virtual/libusb:1 )
	lcd_devices_glcd2usb? ( virtual/libusb:1 )
"

DEPEND="${RDEPEND}"

DOCS=( "AUTHORS" "BUGS" "DOCS" "HISTORY" "PINOUTS" "README" "TODO" )

PATCHES=(
	"${FILESDIR}/${PN}-2.02-use-destdir.patch"
	"${FILESDIR}/${PN}-2.02-disable-static-build.patch"
	"${FILESDIR}/${PN}-2.02-musl.patch"
	"${FILESDIR}/${PN}-2.02-respect-ldflags.patch"
)

src_prepare() {
	default

	# Fix Makefile, as it will fail, when USE="tools" is not set
	if ! use tools; then
		sed -i -e '/$(INSTALL_PROGRAM) $(PROGRAMS)/d' src/Makefile.in || die
	fi

	# Fix QA-Warning "QA Notice: pkg-config files with wrong LDFLAGS detected"
	sed -i -e '/@LDFLAGS@/d' serdisplib.pc.in || die
}

src_configure() {
	# Enable all users enabled lcd devices
	local myeconfargs_lcd_devices
	for lcd_device in ${IUSE_LCD_DEVICES[@]}; do
		if use lcd_devices_${lcd_device}; then
			myeconfargs_lcd_devices+=",${lcd_device}"
		fi
	done

	local use_usb="--disable-libusb"
	if use lcd_devices_acoolsdcm || use lcd_devices_dpfax || use lcd_devices_glcd2usb; then
		use_usb="--enable-libusb"
	fi

	local myeconfargs=(
		$(use_enable lcd_devices_directgfx libSDL)
		$(use_enable lcd_devices_displaylink deprecated)
		$(use_enable lcd_devices_displaylink libdlo)
		$(use_enable lcd_devices_remote experimental)
		$(use_enable lcd_devices_vssdcp experimental)
		$(use_enable threads pthread)
		$(use_enable tools)
		${use_usb}
		--disable-dynloading
		--disable-statictools
		--with-drivers="${myeconfargs_lcd_devices#,}"
	)

	CONFIG_SHELL="${BROOT}/bin/bash" econf "${myeconfargs[@]}"
}

src_install() {
	default

	udev_dorules 90-libserdisp.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
