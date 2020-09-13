include $(THEOS)/makefiles/common.mk

ARCHS = armv7

TOOL_NAME = capable
capable_FILES = capable.mm
capable_INSTALL_PATH = /

include $(THEOS_MAKE_PATH)/tool.mk

copy:: stage
	cp $(THEOS_STAGING_DIR)/capable ../app
