export THEOS_DEVICE_IP = 192.168.1.71

include /opt/theos/makefiles/common.mk


TWEAK_NAME = zfbpojie

zfbpojie_FILES = Tweak.xm CustomShowLabel.m 
zfbpojie_FRAMEWORKS = UIKit Foundation CoreGraphics

include /opt/theos/makefiles/tweak.mk

after-install::
	install.exec "killall -9 AlipayWallet"
