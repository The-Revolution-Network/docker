SHELL := /bin/bash
include ./Makefile.host
include ../httpd-ssl-base/Makefile.include

git-pull:
	git pull origin master
	git submodule update --recursive

.PHONE: .git-pull-build-relaunch
PPBR: | git-pull build-relaunch

build:
	# copy replacements first to make sure we have all pieces successfully first
	#sudo cp -afpL /docker-www/letsencrypt/letsencrypt/live/$(DOMAIN).$(TLD)/cert.pem ./cert-new.pem
	#sudo cp -afpL /docker-www/letsencrypt/letsencrypt/live/$(DOMAIN).$(TLD)/chain.pem ./chain-new.pem
	#sudo cp -afpL /docker-www/letsencrypt/letsencrypt/live/$(DOMAIN).$(TLD)/fullchain.pem ./fullchain-new.pem
	#sudo cp -afpL /docker-www/letsencrypt/letsencrypt/live/$(DOMAIN).$(TLD)/privkey.pem ./privkey-new.pem
	# then replace old ones
	#sudo mv ./cert-new.pem ./cert.pem
	#sudo mv ./chain-new.pem ./chain.pem
	#sudo mv ./fullchain-new.pem ./fullchain.pem
	#sudo mv ./privkey-new.pem ./privkey.pem
	# change ownership to our user for git
	#sudo chown $(OURUSER):$(OURGROUP) *.pem
	sudo docker build -t "$(REPONAME):$(IMAGENAME)" .

.PHONY2: no-restart-launch launch
no-restart-launch: .PHONY2
	$(eval LAUNCHFLAGS := )

.PHONY: exec-bash
letsencrypt-exec-bash:
	sudo docker exec -it the-revolution-network-letsencrypt bash

rm-latest:
	sudo docker rm the-revolution-network-blazor
	sudo docker rm the-revolution-network-letsencrypt

launch:
	sudo docker-compose up -d

stop:
	sudo docker-compose down
