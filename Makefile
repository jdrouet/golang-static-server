VERSION?=latest

all: build push publish

build: build-amd64 build-i386 build-arm64v8 build-arm32v7 build-arm32v6

build-amd64:
	docker build \
		--platform amd64 \
		--build-arg BASE_ARCH=amd64 \
		-t jdrouet/simple-server:amd64-${VERSION} .

build-i386:
	docker build \
		--platform i386 \
		--build-arg BASE_ARCH=i386 \
		-t jdrouet/simple-server:i386-${VERSION} .

build-arm64v8:
	docker build \
		--platform arm \
		--build-arg BASE_ARCH=arm64v8 \
		-t jdrouet/simple-server:arm64v8-${VERSION} .

build-arm32v7:
	docker build \
		--platform arm \
		--build-arg BASE_ARCH=arm32v7 \
		-t jdrouet/simple-server:arm32v7-${VERSION} .

build-arm32v6:
	docker build \
		--platform arm \
		--build-arg BASE_ARCH=arm32v6 \
		-t jdrouet/simple-server:arm32v6-${VERSION} .

push: build
	docker push jdrouet/simple-server:amd64-${VERSION}
	docker push jdrouet/simple-server:i386-${VERSION}
	docker push jdrouet/simple-server:arm64v8-${VERSION}
	docker push jdrouet/simple-server:arm32v7-${VERSION}
	docker push jdrouet/simple-server:arm32v6-${VERSION}

manifest-create:
	docker manifest create --amend \
		jdrouet/simple-server:${VERSION} \
		jdrouet/simple-server:amd64-${VERSION} \
		jdrouet/simple-server:i386-${VERSION} \
		jdrouet/simple-server:arm64v8-${VERSION} \
		jdrouet/simple-server:arm32v7-${VERSION} \
		jdrouet/simple-server:arm32v6-${VERSION}

manifest-amd64: manifest-create
	docker manifest annotate \
		--os linux \
		--arch amd64 \
		jdrouet/simple-server:${VERSION} \
		jdrouet/simple-server:amd64-${VERSION}

manifest-i386: manifest-create
	docker manifest annotate \
		--os linux \
		--arch 386 \
		jdrouet/simple-server:${VERSION} \
		jdrouet/simple-server:i386-${VERSION}

manifest-arm32v6: manifest-create
	docker manifest annotate \
		--os linux \
		--arch arm \
		--variant v6 \
		jdrouet/simple-server:${VERSION} \
		jdrouet/simple-server:arm32v6-${VERSION}

manifest-arm32v7: manifest-create
	docker manifest annotate \
		--os linux \
		--arch arm \
		--variant v7 \
		jdrouet/simple-server:${VERSION} \
		jdrouet/simple-server:arm32v7-${VERSION}

manifest-arm64v8: manifest-create
	docker manifest annotate \
		--os linux \
		--arch arm64 \
		--variant v8 \
		jdrouet/simple-server:${VERSION} \
		jdrouet/simple-server:arm64v8-${VERSION}

manifest: manifest-create manifest-amd64 manifest-i386 manifest-arm32v6 manifest-arm32v7 manifest-arm64v8

publish: manifest
	docker manifest push jdrouet/simple-server:${VERSION}
