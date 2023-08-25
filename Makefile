.PHONY: images clean


online: dist
	cp -f ./script/docker_*.sh ./dist/
	cp -f ./script/install-online.sh ./dist/install.sh
	tar -cJf dist-online.tar.xz dist

offline: dist
	cp -f ./script/install-offline.sh ./dist/install.sh
	tar -cJf dist-offline.tar.xz dist

images: dist
	mkdir dist/images
	./script/docker_login.sh
	./dist/tinyscan/script/quick_update.sh -p
	./dist/tinyscan/script/quick_update.sh -s ./dist/images
	./script/docker_logout.sh

active: dist
	cp -f ./script/active.sh ./dist/

dist:
	mkdir dist && ./install_dist.sh

clean:
	rm -rf dist
	rm -rf dist-*.tar.xz
