KALI_IMAGE=kali
UPDATE_IMAGE=kali-update

UPDATE_COMMAND=apt-get -y update; apt-get -y upgrade; apt-get -y dist-upgrade; apt-get -y autoremove

build:
	docker build -t $(KALI_IMAGE) .

update:
	docker rm -f $(UPDATE_IMAGE) || true
	docker run --name $(UPDATE_IMAGE) -it $(KALI_IMAGE) bash -c "$(UPDATE_COMMAND)"
	docker commit $(UPDATE_IMAGE) $(KALI_IMAGE)
