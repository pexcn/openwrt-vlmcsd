include $(TOPDIR)/rules.mk

PKG_NAME:=vlmcsd
PKG_VERSION:=svn1113
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Wind4/vlmcsd.git
PKG_SOURCE_VERSION:=5b08c8f2a36b2ca0d5efb39481a1a5a06091eaee
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_SOURCE_SUBDIR)

PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=pexcn <i@pexcn.me>

include $(INCLUDE_DIR)/package.mk

define Package/vlmcsd
	SECTION:=net
	CATEGORY:=Network
	TITLE:=KMS Emulator in C
	URL:=https://github.com/Wind4/vlmcsd
	DEPENDS:=+libpthread
endef

define Package/vlmcsd/description
KMS Emulator in C (currently runs on Linux including Android, FreeBSD, Solaris, Minix, Mac OS, iOS, Windows with or without Cygwin).
endef

define Package/vlmcsd/conffiles
/etc/config/vlmcsd
/etc/vlmcsd/vlmcsd.ini
/etc/vlmcsd/vlmcsd.kmd
endef

TARGET_CFLAGS += -O3 \
	-DFULL_INTERNAL_DATA

MAKE_FLAGS += vlmcsd

define Package/vlmcsd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/vlmcsd $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/vlmcsd.init $(1)/etc/init.d/vlmcsd
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) files/vlmcsd.config $(1)/etc/config/vlmcsd
	$(INSTALL_DIR) $(1)/etc/vlmcsd
	$(INSTALL_DATA) files/vlmcsd.ini $(1)/etc/vlmcsd
	$(INSTALL_DATA) files/vlmcsd.kmd $(1)/etc/vlmcsd
endef

define Package/vlmcsd/postrm
#!/bin/sh
rmdir --ignore-fail-on-non-empty /etc/vlmcsd
exit 0
endef

$(eval $(call BuildPackage,vlmcsd))
