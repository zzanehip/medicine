UNAME := $(shell uname -s)
ifeq ($(UNAME),Darwin)
GO_EASY_ON_ME=1
ARCHS = armv7
include /opt/theos/makefiles/common.mk
SYSROOT=/opt/theos/sdks/iPhoneOS4.3.sdk
Jailbreak_FRAMEWORKS = UIKit Foundation QuartzCore
Jailbreak_CFLags = -I.
APPLICATION_NAME = Jailbreak
TOOL_NAME = Bootstrap
Jailbreak_FILES = main.m LoaderAppDelegate.mm LoaderVC.m
Bootstrap_FILES = Bootstrap.m
Bootstrap_INSTALL_PATH = /Applications/Jailbreak.app/

include $(FW_MAKEDIR)/application.mk
include $(FW_MAKEDIR)/tool.mk
include $(FW_MAKEDIR)/aggregate.mk

after-Jailbreak-stage::
	@$(FAKEROOT) chmod 6755 $(THEOS_SHARED_BUNDLE_RESOURCE_PATH)Jailbreak

copy:: stage
	@cp -r $(THEOS_STAGING_DIR)/Applications/Jailbreak.app ../app
	
real-clean:
	rm -rf _
	rm -rf .obj
else
all clean:
	@echo "Skipping Jailbreak on windows"
	
stage copy real-clean:
	@echo "Nothing to do"
endif
