#
# Copyright (C) 2014 Qualcomm-Atheros Inc.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sparse

PKG_VERSION:=0.6.4.r39.gce1a6720
PKG_HASH:=fb6f48d2fe5736ab81d7ebcb4632e8ed3f7dc754fd301ddb6541e49268d09ce8
PKG_RELEASE:=1
PKG_SOURCE_VERSION:=ce1a6720f69e6233ec9abd4e9aae5945e05fda41
HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/$(PKG_NAME)-$(PKG_SOURCE_VERSION)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_SOURCE_VERSION).tar.gz
PKG_SOURCE_URL:=https://git.kernel.org/pub/scm/devel/sparse/sparse.git/snapshot/

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/host-build.mk

define Host/Install
       $(INSTALL_BIN) $(HOST_BUILD_DIR)/sparse $(STAGING_DIR_HOST)/bin
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/sparse
endef

$(eval $(call HostBuild))
