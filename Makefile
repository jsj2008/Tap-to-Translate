TWEAK_NAME = TapToTranslate

TapToTranslate_FILES = $(wildcard ./*.*m) $(wildcard ./XMLDictionary/*.*m) $(wildcard ./PulsingHalo/*.*m)
TapToTranslate_FRAMEWORKS = UIKit CoreGraphics CoreText AVFoundation QuartzCore RevMobAds MediaPlayer CoreLocation AdSupport
TapToTranslate_LIBRARIES = MobileGestalt

export TARGET = iphone:clang
export ARCHS = armv7 armv7s arm64
export SDKVERSION = 9.0
export ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"

SUBPROJECTS += libobjcipc
include $(THEOS_MAKE_PATH)/aggregate.mk
