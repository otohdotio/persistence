#!/usr/bin/env bash

# Ensure the docker VM is running (Mac OS X)
if [ "$(docker-machine status default)" != "Running" ]; then
    docker-machine start default
fi
eval "$(docker-machine env default)"

# Grab the latest Cassandra image
CASSANDRA_EXISTS=`docker images | grep cassandra >/dev/null 2>&1`
if [ "$?" != "0" ]; then
	docker pull cassandra
fi

# Check to see if cs1 exists
CS1_EXISTS=`docker inspect --format="{{.State.Running}}" cs1 >/dev/null 2>&1`
if [ "$?" != "0" ]; then
	docker run --name cs1 -d cassandra
fi
# On the other hand, cs1 might exist but be stopped, if so remove it first
CS1_RUNNING=`docker inspect --format="{{.State.Running}}" cs1`
if [ "${CS1_RUNNING}" != "true" ]; then
	docker rm cs1
	docker run --name cs1 -d cassandra
else
	CONTINUE="true"
	printf "attempting to create keyspace and tables"
	while [ "${CONTINUE}" == "true" ]; do
		docker exec cs1 cqlsh -e "create keyspace if not exists otohdotio with replication = { 'class': 'SimpleStrategy', 'replication_factor': 3 };" >/dev/null 2>&1
		if [ "${?}" == "0" ]; then
			CONTINUE="false"
		fi
		printf "."
	done
	docker cp ../schema.cql cs1:/schema.cql && docker exec cs1 cqlsh -k otohdotio -f /schema.cql >/dev/null 2>&1
	printf "...done\n"
fi
EXISTING_CONTAINERS=`docker ps -q | xargs -I {} docker inspect --format '{{.Name}}' {} | grep "^/cs"`
EXISTING_ARRAY=( ${EXISTING_CONTAINERS} )
NEXT=$(( ${#EXISTING_ARRAY[@]} + 1))

if [ ${NEXT} -lt 3 ]; then
    # The next cs might exist be be stopped, if so, remove it
    NEXT_EXISTS=`docker inspect --format="{{.State.Running}}" cs${NEXT} >/dev/null 2>&1`
    if [ "$?" == "0" ]; then
        docker rm cs${NEXT}
    fi
    docker run --name cs${NEXT} -d -e CASSANDRA_SEEDS="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' cs1)" cassandra
fi

