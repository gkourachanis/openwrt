#
# Copyright (C) 2006-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mpfr
PKG_VERSION:=4.2.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@GNU/mpfr/ http://www.mpfr.org/mpfr-$(PKG_VERSION)
PKG_HASH:=06a378df13501248c1b2db5aa977a2c8126ae849a9d9b7be2546fb4a9c26d993

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_LICENSE:=GPL-2.0-or-later

PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Package/libmpfr
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=GNU multiple precision floating-Point reliable library
  URL:=https://www.mpfr.org/
  DEPENDS:=+libgmp
  ABI_VERSION:=10
endef

define Package/libmpfr/description
	The MPFR library is a C library for multiple-precision
	floating-point computations with correct rounding.
endef

TARGET_CFLAGS += $(FPIC)
CONFIGURE_VARS += CC="$(TARGET_CROSS)gcc"
CONFIGURE_ARGS += \
	--enable-shared \
	--enable-static \
	--enable-thread-safe \
	--with-gmp=$(STAGING_DIR_HOST)

define Build/Compile
	$(call Build/Compile/Default, \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		all \
	)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/mpfr* $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmpfr.{a,so*} $(1)/usr/lib/
endef

define Package/libmpfr/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmpfr.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libmpfr))
$(eval $(call HostBuild))
