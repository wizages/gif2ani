include $(THEOS)/makefiles/common.mk

SDKVERSION = 9.3
SYSROOT = $(THEOS)/sdks/iPhoneOS9.3.sdk
BUNDLE_NAME = GIF2Ani
GIF2Ani_FILES = gf2aniRootListController.m UIImage+animatedGIF.m
GIF2Ani_INSTALL_PATH = /Library/PreferenceBundles
GIF2Ani_FRAMEWORKS = UIKit ImageIO
GIF2Ani_PRIVATE_FRAMEWORKS = Preferences AppSupport

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/GIF2Ani.plist$(ECHO_END)
