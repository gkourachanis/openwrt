#
# Copyright (C) 2022 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mac80211
PKG_FLAGS:=hold

PKG_VERSION:=6.1
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/packages-$(PKG_NAME)
PKG_BUILD_PARALLEL:=0

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=

export SHELL:=/bin/sh
.ONESHELL:
.SHELLFLAGS = -ec

include $(INCLUDE_DIR)/package.mk

ifeq ($(DUMP),)
  STAMP_BUILT:=$(STAMP_BUILT)_$(call LINUX_DIR_KCONFIG_LIST_MD5)
  -include $(LINUX_DIR)/.config
endif

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define KernelPackage/hooks
endef

define KernelPackage/depends
endef

PKG_DRIVERS = \
	mac80211-hwsim \
	mt7601u \
	btrsi rsi91x rsi91x-usb rsi91x-sdio \
	wlcore wl12xx wl18xx \

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_kmod-mac80211 \
	CONFIG_PACKAGE_CFG80211_TESTMODE \
	CONFIG_PACKAGE_MAC80211_DEBUGFS \
	CONFIG_PACKAGE_MAC80211_MESH \
	CONFIG_PACKAGE_MAC80211_TRACING \
	CONFIG_PACKAGE_IWLWIFI_DEBUG \
	CONFIG_PACKAGE_IWLWIFI_DEBUGFS \
	CONFIG_PACKAGE_RTLWIFI_DEBUG \

config_package=$(if $(CONFIG_PACKAGE_kmod-$(1)),m)

config-y:= \
	WLAN \
	CFG80211_CERTIFICATION_ONUS \
	MAC80211_RC_MINSTREL \
	MAC80211_RC_DEFAULT_MINSTREL \
	WLAN_VENDOR_ADMTEK \
	WLAN_VENDOR_ATH \
	WLAN_VENDOR_ATMEL \
	WLAN_VENDOR_BROADCOM \
	WLAN_VENDOR_CISCO \
	WLAN_VENDOR_INTEL \
	WLAN_VENDOR_INTERSIL \
	WLAN_VENDOR_MARVELL \
	WLAN_VENDOR_MEDIATEK \
	WLAN_VENDOR_RALINK \
	WLAN_VENDOR_REALTEK \
	WLAN_VENDOR_RSI \
	WLAN_VENDOR_ST \
	WLAN_VENDOR_TI \
	WLAN_VENDOR_ZYDAS

config-$(call config_package,cfg80211) += CFG80211
config-$(CONFIG_PACKAGE_CFG80211_TESTMODE) += NL80211_TESTMODE

config-$(call config_package,mac80211) += MAC80211
config-$(CONFIG_PACKAGE_MAC80211_MESH) += MAC80211_MESH

PKG_CONFIG_DEPENDS += \
	$(patsubst %,CONFIG_PACKAGE_kmod-%,$(PKG_DRIVERS))

#
WMENU:=Wireless Drivers

define KernelPackage/mac80211/Default
  SUBMENU:=$(WMENU)
  URL:=https://wireless.wiki.kernel.org/
  MAINTAINER:=Felix Fietkau <nbd@nbd.name>
endef

include ath.mk
include broadcom.mk
include intel.mk
include marvell.mk
include ralink.mk
include realtek.mk

define KernelPackage/cfg80211
  $(call KernelPackage/mac80211/Default)
  TITLE:=cfg80211 - wireless configuration API
  DEPENDS+= +iw +iwinfo +wireless-regdb +USE_RFKILL:kmod-rfkill
  ABI_VERSION:=$(PKG_VERSION)-$(PKG_RELEASE)
  FILES:=$(LINUX_DIR)/net/wireless/cfg80211.ko
endef

define KernelPackage/cfg80211/description
 cfg80211 is the Linux wireless LAN (802.11) configuration API.
endef

define KernelPackage/cfg80211/config
  if PACKAGE_kmod-cfg80211

	config PACKAGE_CFG80211_TESTMODE
		bool "Enable testmode command support"
		default n
		help
		  This is typically used for tests and calibration during
		  manufacturing, or vendor specific debugging features

  endif
endef

define KernelPackage/mac80211
  $(call KernelPackage/mac80211/Default)
  TITLE:=Linux 802.11 Wireless Networking Stack
  # +kmod-crypto-cmac is a runtime only dependency of net/mac80211/aes_cmac.c
  DEPENDS+= +kmod-cfg80211 +kmod-crypto-cmac +kmod-crypto-ccm +kmod-crypto-gcm +hostapd-common
  KCONFIG:=\
	CONFIG_AVERAGE=y
  FILES:= $(LINUX_DIR)/net/mac80211/mac80211.ko
  ABI_VERSION:=$(PKG_VERSION)-$(PKG_RELEASE)
  MENU:=1
endef

define KernelPackage/mac80211/config
  if PACKAGE_kmod-mac80211

	config PACKAGE_MAC80211_DEBUGFS
		bool "Export mac80211 internals in DebugFS"
		select KERNEL_DEBUG_FS
		default y
		help
		  Select this to see extensive information about
		  the internal state of mac80211 in debugfs.

	config PACKAGE_MAC80211_TRACING
		bool "Enable tracing (mac80211 and supported drivers)"
		select KERNEL_FTRACE
		select KERNEL_ENABLE_DEFAULT_TRACERS
		default n
		help
		  Select this to enable tracing of mac80211 and
		  related wifi drivers (using trace-cmd).

	config PACKAGE_MAC80211_MESH
		bool "Enable 802.11s mesh support"
		default y

  endif
endef

define KernelPackage/mac80211/description
 Generic IEEE 802.11 Networking Stack (mac80211)
endef

define KernelPackage/mac80211-hwsim
  $(call KernelPackage/mac80211/Default)
  TITLE:=mac80211 HW simulation device
  DEPENDS+= +kmod-mac80211 +@DRIVER_11AX_SUPPORT +@DRIVER_11AC_SUPPORT
  FILES:=$(LINUX_DIR)/drivers/net/wireless/mac80211_hwsim.ko
  AUTOLOAD:=$(call AutoProbe,mac80211_hwsim)
endef

define KernelPackage/mt7601u
  $(call KernelPackage/mac80211/Default)
  TITLE:=MT7601U-based USB dongles Wireless Driver
  DEPENDS+= +kmod-mac80211 @USB_SUPPORT +kmod-usb-core +mt7601u-firmware
  FILES:=$(LINUX_DIR)/drivers/net/wireless/mediatek/mt7601u/mt7601u.ko
  AUTOLOAD:=$(call AutoProbe,mt7601u)
endef

define KernelPackage/btrsi
  $(call KernelPackage/mac80211/Default)
  TITLE:=Redpine BT driver
  DEPENDS+= +kmod-bluetooth
  KCONFIG:=CONFIG_BT_HCIRSI
  FILES:=$(LINUX_DIR)/drivers/bluetooth/btrsi.ko
  AUTOLOAD:=$(call AutoProbe,btrsi)
endef

define KernelPackage/rsi91x
  $(call KernelPackage/mac80211/Default)
  TITLE:=Redpine Signals Inc 91x WLAN driver support
  DEPENDS+= +kmod-mac80211 +rs9113-firmware +kmod-btrsi
  FILES:=$(LINUX_DIR)/drivers/net/wireless/rsi/rsi_91x.ko
  AUTOLOAD:=$(call AutoProbe,rsi91x)
endef

define KernelPackage/rsi91x-usb
  $(call KernelPackage/mac80211/Default)
  TITLE:=Redpine Signals USB bus support
  DEPENDS+=@USB_SUPPORT +kmod-usb-core +kmod-mac80211 +kmod-rsi91x +rs9113-firmware
  FILES:=$(LINUX_DIR)/drivers/net/wireless/rsi/rsi_usb.ko
  AUTOLOAD:=$(call AutoProbe,rsi_usb)
endef

define KernelPackage/rsi91x-sdio
  $(call KernelPackage/mac80211/Default)
  TITLE:=Redpine Signals SDIO bus support
  DEPENDS+= +kmod-mac80211 +kmod-mmc +kmod-rsi91x +rs9113-firmware
  FILES:=$(LINUX_DIR)/drivers/net/wireless/rsi/rsi_sdio.ko
  AUTOLOAD:=$(call AutoProbe,rsi_sdio)
endef

define KernelPackage/wlcore
  $(call KernelPackage/mac80211/Default)
  TITLE:=TI common driver part
  DEPENDS+= +kmod-mmc +kmod-mac80211
  FILES:= \
	$(LINUX_DIR)/drivers/net/wireless/ti/wlcore/wlcore.ko \
	$(LINUX_DIR)/drivers/net/wireless/ti/wlcore/wlcore_sdio.ko
  AUTOLOAD:=$(call AutoProbe,wlcore wlcore_sdio)
endef

define KernelPackage/wlcore/description
 This module contains some common parts needed by TI Wireless drivers.
endef

define KernelPackage/wl12xx
  $(call KernelPackage/mac80211/Default)
  TITLE:=Driver for TI WL12xx
  URL:=https://wireless.wiki.kernel.org/en/users/drivers/wl12xx
  DEPENDS+= +kmod-wlcore +wl12xx-firmware
  FILES:=$(LINUX_DIR)/drivers/net/wireless/ti/wl12xx/wl12xx.ko
  AUTOLOAD:=$(call AutoProbe,wl12xx)
endef

define KernelPackage/wl12xx/description
 Kernel modules for TI WL12xx
endef

define KernelPackage/wl18xx
  $(call KernelPackage/mac80211/Default)
  TITLE:=Driver for TI WL18xx
  URL:=https://wireless.wiki.kernel.org/en/users/drivers/wl18xx
  DEPENDS+= +kmod-wlcore +wl18xx-firmware
  FILES:=$(LINUX_DIR)/drivers/net/wireless/ti/wl18xx/wl18xx.ko
  AUTOLOAD:=$(call AutoProbe,wl18xx)
endef

define KernelPackage/wl18xx/description
 Kernel modules for TI WL18xx
endef


ifdef CONFIG_PACKAGE_MAC80211_DEBUGFS
  config-y += \
	CFG80211_DEBUGFS \
	MAC80211_DEBUGFS
endif

ifdef CONFIG_PACKAGE_MAC80211_TRACING
  config-y += \
	IWLWIFI_DEVICE_TRACING
endif

config-$(call config_package,mac80211-hwsim) += MAC80211_HWSIM
config-$(call config_package,mt7601u) += MT7601U
config-y += WL_MEDIATEK

config-$(call config_package,wlcore) += WLCORE WLCORE_SDIO
config-$(call config_package,wl12xx) += WL12XX
config-$(call config_package,wl18xx) += WL18XX
config-y += WL_TI WILINK_PLATFORM_DATA
config-$(call config_package,rsi91x) += RSI_91X
config-$(call config_package,rsi91x-usb) += RSI_USB
config-$(call config_package,rsi91x-sdio) += RSI_SDIO

config-$(CONFIG_LEDS_TRIGGERS) += MAC80211_LEDS

define ConfigVars
$(subst $(space),,$(foreach opt,$(config-$(1)),CONFIG_$(opt)=$(1)))
endef

define mac80211_config
$(call ConfigVars,m)$(call ConfigVars,y)
endef
$(eval $(call shexport,mac80211_config))

define Build/Compile
	$(SH_FUNC) var2file "$(call shvar,mac80211_config)" $(PKG_BUILD_DIR)/.config
endef

define KernelPackage/cfg80211/install
	$(INSTALL_DIR) $(1)/lib/wifi $(1)/lib/netifd/wireless
	$(INSTALL_DATA) ./files/lib/wifi/mac80211.sh $(1)/lib/wifi
	$(INSTALL_BIN) ./files/lib/netifd/wireless/mac80211.sh $(1)/lib/netifd/wireless
	$(INSTALL_DIR) $(1)/etc/hotplug.d/ieee80211
	$(INSTALL_DATA) ./files/mac80211.hotplug $(1)/etc/hotplug.d/ieee80211/10-wifi-detect
endef

$(eval $(foreach drv,$(PKG_DRIVERS),$(call KernelPackage,$(drv))))
$(eval $(call KernelPackage,cfg80211))
$(eval $(call KernelPackage,mac80211))
