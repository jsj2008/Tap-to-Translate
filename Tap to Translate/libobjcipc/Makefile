#export THEOS_DEVICE_IP=192.168.0.240

export TARGET = iphone:clang
export ARCHS = armv7 armv7s arm64
export ADDITIONAL_OBJCFLAGS = -fvisibility=default -fvisibility-inlines-hidden -fobjc-arc -O2

#DEBUG=1

LIBRARY_NAME = libobjcipc_TapToTranslate
libobjcipc_TapToTranslate_FILES = IPC.m Connection.m Message.m
libobjcipc_TapToTranslate_FRAMEWORKS = CoreFoundation Foundation UIKit
libobjcipc_TapToTranslate_INSTALL_PATH = /usr/lib/
libobjcipc_TapToTranslate_LIBRARIES = substrate
libobjcipc_TapToTranslate_LDFLAGS += -Wl,-segalign,4000

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/library.mk

after-install::
	install.exec "reboot"
