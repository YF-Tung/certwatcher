MAINTAINER := Yu-Fan Tung <https://github.com/YF-Tung>
VERSION_STRING ?= $(shell git describe --tags --long --dirty --always)
BUILD_DIR := build
APPNAME=certwatcher
GO := go

.PHONY: default linux64 darwin64 rpm

default:	$(BUILD_DIR)/$(APPNAME)
$(BUILD_DIR)/$(APPNAME):	main.go
	@mkdir -p $(BUILD_DIR)
	$(GO) build -o $@

linux64:	clean
	mkdir -p $(BUILD_DIR)
	GOOS=linux GOARCH=amd64 $(GO) build -o $(BUILD_DIR)/$(APPNAME)

darwin64:	clean
	mkdir -p $(BUILD_DIR)
	GOOS=darwin GOARCH=amd64 $(GO) build -o $(BUILD_DIR)/$(APPNAME)

rpm: 	linux64
	cp config.ini.example $(BUILD_DIR)
	fpm -n $(APPNAME) -v $(VERSION_STRING) -a all -m "$(MAINTAINER)" \
		--rpm-os linux -s dir -t rpm -f \
		-a x86_64 -p $(BUILD_DIR)/$(APPNAME)-latest.rpm \
		-C $(BUILD_DIR) \
		./$(APPNAME)=/usr/bin/$(APPNAME) ./config.ini.example=/etc/certwatcher/config.ini.example

run:	default
	$(BUILD_DIR)/$(APPNAME)
test:	default
	$(GO) test
clean:
	rm -rf *.rpm $(BUILD_DIR)
