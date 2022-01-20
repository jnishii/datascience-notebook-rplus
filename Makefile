IMAGE=jnishii/r-notebook-plus
VERSION=$(shell cat VERSION)

release: 
	echo "$VERSION"
	git add .
	git commit -m "version ${VERSION}"
	git tag -a "${VERSION}" -m "version ${VERSION}"
	git push
	git push --tags

build:
	docker build --force-rm=true -t ${IMAGE} .

run:
	bin/run.sh

save:
	docker save ${IMAGE} -o image.tar

load:
	docker load -i image.tar

ps:
	docker ps -a

push:
	# You should `docker login` before make push
	docker tag ${IMAGE}:latest ${IMAGE}:${VERSION}
	docker push ${IMAGE}:${VERSION}

clean:
	rm *~
