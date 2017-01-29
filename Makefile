NAME?=dockage/base-image
VERSION=
DEBUG?=false
APT_CACHER_SERVER?=
DISABLE_AUTO_START_SERVICES?=false
INSTALL_SSHD?=false
INSTALL_CRON?=false
INSTALL_SYSLOG_NG?=true
INSTALL_NGINX?=false
INSTALL_SUPERVISOR?=false
INSTALL_GEARMAN?=false
INSTALL_TINYDNS?=false

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

build: guard-NAME guard-VERSION
	docker build --force-rm -t $(NAME):$(VERSION) \
	--build-arg=APT_CACHER_SERVER=$(APT_CACHER_SERVER) \
	--build-arg=DEBUG=$(DEBUG) \
	--build-arg=DISABLE_AUTO_START_SERVICES=$(DISABLE_AUTO_START_SERVICES) \
	--build-arg=INSTALL_SSHD=$(INSTALL_SSHD) \
	--build-arg=INSTALL_CRON=$(INSTALL_CRON) \
	--build-arg=INSTALL_SYSLOG_NG=$(INSTALL_SYSLOG_NG) \
	--build-arg=INSTALL_NGINX=$(INSTALL_NGINX) \
	--build-arg=INSTALL_SUPERVISOR=$(INSTALL_SUPERVISOR) \
	--build-arg=INSTALL_GEARMAN=$(INSTALL_GEARMAN) \
	--build-arg=INSTALL_TINYDNS=$(INSTALL_TINYDNS) \
	.

run: guard-NAME guard-VERSION
	docker run --rm -ti $(NAME):$(VERSION) app:start

release: guard-VERSION guard-GPG_KEY_ID
	@echo "Tagging $(VERSION)"
	git tag -s -u $(GPG_KEY_ID) v$(VERSION) -m "Version $(VERSION)"
	git push origin
	git push origin --tags
	docker push $(NAME)
