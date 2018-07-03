MAINTAINER := Yu-Fan Tung <https://github.com/YF-Tung>
VERSION_STRING ?= $(shell git describe --tags --long --dirty --always)
BUILD_DIR := build
APPNAME=certwatcher

.PHONY: rpm clean

buildlinux: clean
	mkdir -p $(BUILD_DIR)
	GOOS=linux GOARCH=amd64 go build -o $(BUILD_DIR)/$(APPNAME)

rpm: buildlinux
	cp config.ini.example $(BUILD_DIR)
	fpm -n $(APPNAME) -v $(VERSION_STRING) -a all -m "$(MAINTAINER)" \
		--rpm-os linux -s dir -t rpm -f \
		-a x86_64 -p $(BUILD_DIR)/$(APPNAME)-latest.rpm \
		-C $(BUILD_DIR) \
		./$(APPNAME)=/usr/bin/$(APPNAME) ./config.ini.example=/etc/certwatcher/config.ini.example

run:	buildlinux
	$(BUILD_DIR)/$(APPNAME)
clean:
	rm -f *.rpm certwatcher
