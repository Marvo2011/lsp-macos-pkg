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
PREFIX = /usr/local
GIT_REPO = https://github.com/lsp-plugins/lsp-plugins.git
PKG = $(APP_NAME)-$(VERSION)
PKG_BUNDLE = $(PKG)-macOS-arm64.pkg

export APP_NAME VERSION BUNDLE_ID BUILD_DIR PKG

all: fetch prebuild pkg

fetch:
	git clone $(GIT_REPO) $(BUILD_DIR)/$(APP_NAME)
	cd $(BUILD_DIR)/$(APP_NAME) && \
		git checkout $(VERSION) && \
		gmake clean && \
		gmake config FEATURES="$(FEATURES)" PREFIX=$(shell pwd)/$(BUILD_DIR)/root/${PREFIX} && \
		gmake fetch

prebuild:
	mkdir -p $(BUILD_DIR)/root/${PREFIX}
	cd $(BUILD_DIR)/$(APP_NAME) && \
		gmake && \
		gmake install

pkg:
	mkdir -p $(RELEASE_DIR)

	pkgbuild \
		--identifier "$(BUNDLE_ID)" \
		--version "$(VERSION)" \
		--root "$(BUILD_DIR)/root" \
		--install-location "/" \
		"$(BUILD_DIR)/$(PKG).lv2.pkg"

	envsubst < ./src/distribution.xml > $(BUILD_DIR)/distribution.xml

	productbuild \
		--resources ./src/resources \
		--distribution $(BUILD_DIR)/distribution.xml \
		--package-path "$(BUILD_DIR)" \
		"$(RELEASE_DIR)/$(PKG_BUNDLE)"

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(RELEASE_DIR)
