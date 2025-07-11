#
# Copyright (C) 2025 Linux Studio Plugins Project <https://lsp-plug.in/>
#           (C) 2025 Vladimir Sadovnikov <sadko4u@gmail.com>
#           (C) 2025 Marvin Edeler <marvin.edeler@gmail.com>
#
# This file is part of lsp-macos-pkg
#
# lsp-macos-pkg is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# lsp-macos-pkg is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with lsp-macos-pkg.  If not, see <https://www.gnu.org/licenses/>.
#

APP_NAME = lsp-plugins
VERSION ?= 1.2.22
FEATURES ?= "lv2"
BUNDLE_ID = com.lsp.plugins
BUILD_DIR = build
RELEASE_DIR = release
PREFIX_LV2 = /usr/local
PREFIX_VST2 = /Library/Audio/Plug-Ins/VST
PREFIX_VST3 = /Library/Audio/Plug-Ins/VST3
GIT_REPO = https://github.com/lsp-plugins/lsp-plugins.git
PKG = $(APP_NAME)-$(VERSION)
PKG_BUNDLE = $(PKG)-macOS-arm64.pkg

LV2_DISABLED_OPEN = "<!--"
LV2_DISABLED_END = "-->"
VST2_DISABLED_OPEN = "<!--"
VST2_DISABLED_END = "-->"
VST3_DISABLED_OPEN = "<!--"
VST3_DISABLED_END = "-->"

ifeq ($(findstring lv2,$(FEATURES)),lv2)
	LV2_DISABLED_OPEN = ""
	LV2_DISABLED_END = ""
endif

ifeq ($(findstring vst2,$(FEATURES)),vst2)
	VST2_DISABLED_OPEN = ""
	VST2_DISABLED_END = ""
endif

ifeq ($(findstring vst3,$(FEATURES)),vst3)
	VST3_DISABLED_OPEN = ""
	VST3_DISABLED_END = ""
endif

export APP_NAME VERSION BUNDLE_ID BUILD_DIR PKG LV2_DISABLED_OPEN LV2_DISABLED_END \
	VST2_DISABLED_OPEN VST2_DISABLED_END VST3_DISABLED_OPEN VST3_DISABLED_END

all: fetch prebuild pkg

FETCH_CMDS :=
PREBUILD_CMDS :=
PKG_CMDS :=

FETCH_CMDS += echo "Fetch resources"

ifeq ($(findstring lv2,$(FEATURES)),lv2)
	FETCH_CMDS += && git clone $(GIT_REPO) $(BUILD_DIR)/$(APP_NAME)_lv2
	ifeq ($(findstring ui,$(FEATURES)), ui)
		FETCH_CMDS += && (cd $(BUILD_DIR)/$(APP_NAME)_lv2 && \
			git checkout $(VERSION) && \
			gmake clean && \
			gmake config FEATURES="lv2 ui" PREFIX=$(shell pwd)/$(BUILD_DIR)/root_lv2/${PREFIX_LV2} && \
			gmake fetch)
	else
		FETCH_CMDS += && (cd $(BUILD_DIR)/$(APP_NAME)_lv2 && \
			git checkout $(VERSION) && \
			gmake clean && \
			gmake config FEATURES="lv2" PREFIX=$(shell pwd)/$(BUILD_DIR)/root_lv2/${PREFIX_LV2} && \
			gmake fetch)
	endif
endif

ifeq ($(findstring vst2,$(FEATURES)), vst2)
	FETCH_CMDS += && git clone $(GIT_REPO) $(BUILD_DIR)/$(APP_NAME)_vst2
	ifeq ($(findstring ui,$(FEATURES)), ui)
		FETCH_CMDS += && (cd $(BUILD_DIR)/$(APP_NAME)_vst2 && \
			git checkout $(VERSION) && \
			gmake clean && \
			gmake config FEATURES="vst2 ui" PREFIX=$(shell pwd)/$(BUILD_DIR)/root_vst2/${PREFIX_VST2} && \
			gmake fetch)
	else
		FETCH_CMDS += && (cd $(BUILD_DIR)/$(APP_NAME)_vst2 && \
			git checkout $(VERSION) && \
			gmake clean && \
			gmake config FEATURES="vst2" PREFIX=$(shell pwd)/$(BUILD_DIR)/root_vst2/${PREFIX_VST2} && \
			gmake fetch)
	endif
endif

ifeq ($(findstring vst3,$(FEATURES)), vst3)
	FETCH_CMDS += && git clone $(GIT_REPO) $(BUILD_DIR)/$(APP_NAME)_vst3
	ifeq ($(findstring ui,$(FEATURES)), ui)
		FETCH_CMDS += && (cd $(BUILD_DIR)/$(APP_NAME)_vst3 && \
			git checkout $(VERSION) && \
			gmake clean && \
			gmake config FEATURES="vst3 ui" PREFIX=$(shell pwd)/$(BUILD_DIR)/root_vst3/${PREFIX_VST3} && \
			gmake fetch)
	else
		FETCH_CMDS += && (cd $(BUILD_DIR)/$(APP_NAME)_vst3 && \
			git checkout $(VERSION) && \
			gmake clean && \
			gmake config FEATURES="vst3" PREFIX=$(shell pwd)/$(BUILD_DIR)/root_vst3/${PREFIX_VST3} && \
			gmake fetch)
	endif
endif

PREBUILD_CMDS += echo "Prebuild resources"

ifeq ($(findstring lv2,$(FEATURES)), lv2)
	PREBUILD_CMDS += && mkdir -p $(BUILD_DIR)/root_lv2/${PREFIX_LV2}
	PREBUILD_CMDS += && (cd $(BUILD_DIR)/$(APP_NAME)_lv2 && \
		gmake && \
		gmake install)
endif

ifeq ($(findstring vst2,$(FEATURES)), vst2)
	PREBUILD_CMDS += && mkdir -p $(BUILD_DIR)/root_vst2/${PREFIX_VST2}
	PREBUILD_CMDS += && (cd $(BUILD_DIR)/$(APP_NAME)_vst2 && \
		gmake && \
		gmake install)
endif

ifeq ($(findstring vst3,$(FEATURES)), vst3)
	PREBUILD_CMDS += && mkdir -p $(BUILD_DIR)/root_vst3/${PREFIX_VST3}
	PREBUILD_CMDS += && (cd $(BUILD_DIR)/$(APP_NAME)_vst3 && \
		gmake && \
		gmake install)
endif

ifeq ($(findstring lv2,$(FEATURES)), lv2)
	PREBUILD_CMDS += && pkgbuild \
		--identifier "$(BUNDLE_ID)" \
		--version "$(VERSION)" \
		--root "$(BUILD_DIR)/root_lv2" \
		--install-location "/" \
		"$(BUILD_DIR)/$(PKG).lv2.pkg"
endif

ifeq ($(findstring vst2,$(FEATURES)), vst2)
	PREBUILD_CMDS += && pkgbuild \
		--identifier "$(BUNDLE_ID)" \
		--version "$(VERSION)" \
		--root "$(BUILD_DIR)/root_vst2" \
		--install-location "/" \
		"$(BUILD_DIR)/$(PKG).vst2.pkg"
endif

ifeq ($(findstring vst3,$(FEATURES)), vst3)
	PREBUILD_CMDS += && pkgbuild \
		--identifier "$(BUNDLE_ID)" \
		--version "$(VERSION)" \
		--root "$(BUILD_DIR)/root_vst3" \
		--install-location "/" \
		"$(BUILD_DIR)/$(PKG).vst3.pkg"
endif

fetch:
	@$(FETCH_CMDS)

prebuild:
	@$(PREBUILD_CMDS)

pkg:
	mkdir -p $(RELEASE_DIR)

	@$(PKG_CMDS)

	envsubst < ./src/distribution.xml > $(BUILD_DIR)/distribution.xml

	productbuild \
		--resources ./src/resources \
		--distribution $(BUILD_DIR)/distribution.xml \
		--package-path "$(BUILD_DIR)" \
		"$(RELEASE_DIR)/$(PKG_BUNDLE)"

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(RELEASE_DIR)
