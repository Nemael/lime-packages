#
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

LIME_BUILDDATE:=$(shell date +%Y%m%d_%H%M)

GIT_COMMIT_DATE:=$(shell git log -n 1 --pretty=%ad --date=short . )
GIT_COMMIT_TSTAMP:=$(shell git log -n 1 --pretty=%at . )

PKG_NAME:=lime-cable-purpose-autodetection
PKG_VERSION=$(GIT_COMMIT_DATE)-$(GIT_COMMIT_TSTAMP)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=Autodecetion of hardware on the other side of a connection
  CATEGORY:=LibreMesh
  URL:=https://libremesh.org
  DEPENDS:=+lime-system +lua +libuci-lua
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	This package automatically applies configurations in
	predefined scenarios, depending on what is connected to the
	other side of an interface.
	This package is unfinished
endef

define Build/Compile
	@rm -rf ./build || true
	@mkdir ./build
	$(CP) ./files ./build
	$(FIND) ./build -name '*.sh' -exec sed -i '/^\s*#\[Doc\]/d' {} +
	$(FIND) ./build -name '*.lua' -exec sed -i '/^\s*--!.*/d' {} +
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/
	$(CP) ./build/files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
