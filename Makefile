include $(TOPDIR)/rules.mk
 
PKG_NAME:=udp-over-tcp
PKG_VERSION:=2022-03-12-567b31aa
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/mullvad/udp-over-tcp.git
PKG_SOURCE_DATE:=2022-03-12
PKG_SOURCE_VERSION:=567b31aaecb1fa098814526f04569c6a9447751f
PKG_MIRROR_HASH:=skip
 
include $(INCLUDE_DIR)/package.mk
 
define Package/udp-over-tcp
  SECTION:=base
  CATEGORY:=Network
  TITLE:=A tool for tunneling UDP datagrams over a TCP stream.
  URL:=https://github.com/mullvad/udp-over-tcp
endef
 
define Package/udp-over-tcp/description
  Some programs/protocols only work over UDP.
  And some networks only allow TCP.
  This is where udp-over-tcp comes in handy.
endef

TCP2UDP_PATH:="$(PKG_BUILD_DIR)/target/$(RUST_TRIPLE)/release/tcp2udp"
UDP2TCP_PATH:="$(PKG_BUILD_DIR)/target/$(RUST_TRIPLE)/release/udp2tcp"
 
define Build/Compile
	(\
		cd $(PKG_BUILD_DIR) && \
		cargo install cross && \
		cross build --release --target $(RUST_TRIPLE) --bins \
	)
	$(STRIP) $(TCP2UDP_PATH)
	$(STRIP) $(UDP2TCP_PATH)
endef
 
define Package/udp-over-tcp/install
        $(INSTALL_DIR) $(1)/usr/sbin
        $(INSTALL_BIN) $(TCP2UDP_PATH) $(1)/usr/sbin/
        $(INSTALL_BIN) $(UDP2TCP_PATH) $(1)/usr/sbin/
endef
 
$(eval $(call BuildPackage,udp-over-tcp))
