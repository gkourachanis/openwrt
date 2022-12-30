#
# Copyright (C) 2022 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

PKG_DRIVERS += \
	mwl8k mwifiex mwifiex-pcie mwifiex-sdio

config-$(call config_package,mwl8k) += MWL8K
config-$(call config_package,mwifiex) += MWIFIEX
config-$(call config_package,mwifiex-pcie) += MWIFIEX_PCIE
config-$(call config_package,mwifiex-sdio) += MWIFIEX_SDIO

define KernelPackage/mwl8k
  $(call KernelPackage/mac80211/Default)
  TITLE:=Driver for Marvell TOPDOG 802.11 Wireless cards
  URL:=https://wireless.wiki.kernel.org/en/users/drivers/mwl8k
  DEPENDS+= @PCI_SUPPORT +kmod-mac80211 +mwl8k-firmware
  FILES:=$(LINUX_DIR)/drivers/net/wireless/marvell/mwl8k.ko
  AUTOLOAD:=$(call AutoProbe,mwl8k)
endef

define KernelPackage/mwl8k/description
 Kernel modules for Marvell TOPDOG 802.11 Wireless cards
endef

define KernelPackage/mwifiex
  $(call KernelPackage/mac80211/Default)
  TITLE:=This adds support for wireless adapters based on Marvell 802.11n/ac chipsets.
  DEPENDS+=+kmod-cfg80211
  URL:=https://wireless.wiki.kernel.org/en/users/drivers/mwifiex
  FILES:= $(LINUX_DIR)/drivers/net/wireless/marvell/mwifiex/mwifiex.ko
  AUTOLOAD:=$(call AutoProbe,mwifiex)
endef

define KernelPackage/mwifiex-pcie
  $(call KernelPackage/mac80211/Default)
  TITLE:=Driver for Marvell 802.11n/802.11ac PCIe Wireless cards
  URL:=https://wireless.wiki.kernel.org/en/users/drivers/mwifiex
  DEPENDS+= \
	@PCI_SUPPORT +kmod-mac80211 +@DRIVER_11AC_SUPPORT \
	+mwifiex-pcie-firmware +kmod-mwifiex
  FILES:=$(LINUX_DIR)/drivers/net/wireless/marvell/mwifiex/mwifiex_pcie.ko
  AUTOLOAD:=$(call AutoProbe,mwifiex_pcie)
endef

define KernelPackage/mwifiex-pcie/description
 Kernel modules for Marvell 802.11n/802.11ac PCIe Wireless cards
endef

define KernelPackage/mwifiex-sdio
  $(call KernelPackage/mac80211/Default)
  TITLE:=Driver for Marvell 802.11n/802.11ac SDIO Wireless cards
  URL:=https://wireless.wiki.kernel.org/en/users/drivers/mwifiex
  DEPENDS+= \
	+kmod-mmc +kmod-mac80211 +@DRIVER_11AC_SUPPORT \
	+mwifiex-sdio-firmware +kmod-mwifiex
  FILES:=$(LINUX_DIR)/drivers/net/wireless/marvell/mwifiex/mwifiex_sdio.ko
  AUTOLOAD:=$(call AutoProbe,mwifiex_sdio)
endef

define KernelPackage/mwifiex-sdio/description
 Kernel modules for Marvell 802.11n/802.11ac SDIO Wireless cards
endef
