all: clean build deploy

clean:
	rm -rf build

builddir:
	mkdir -p build

serve:
	modd # see modd.conf for details

build: builddir
	# just render all blogs. It's not expensive. Eventually, could choose to only
	# render updated blogs as long as template hasn't changed
	python render_blogs.py

	#sync static files
	rsync -az --delete template/css build
	rsync -az --delete template/CNAME build
	rsync -az --delete template/images build
	rsync -az --delete template/static build
	rsync -az --delete template/index.html build
	rsync -az --delete template/favicon.ico build

deploy:
	rsync -az --delete -e ssh --safe-links --exclude '.git' build/ hubvan.com:/srv/billmill.org/


.PHONY: all clean builddir build deploy
