build:
	protoc -I. --go_out=plugins=micro:. \
    proto/vessel/vessel.proto
	docker build -t eu.gcr.io/shippy-freight/vessel:latest .
	docker push eu.gcr.io/shippy-freight/vessel:latest

run:
	docker run -d --net="host" \
		-p 50053 \
		-e MICRO_SERVER_ADDRESS=:50053 \
		-e MICRO_REGISTRY=mdns \
		vessel-service

deploy:
	sed "s/{{ UPDATED_AT }}/$(shell date)/g" ./deployments/deployment.tmpl > ./deployments/deployment.yml
	kubectl replace -f ./deployments/deployment.yml
