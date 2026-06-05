# "Demystifying Kafka stuff"

## Description

There is Kafka broker running on the host and Zookeper. Those two services are running inside container.
In addition, there is a producer and a consumer operating on this server. Try to solve the problems
The source of code is `/home/admin/kafka/`

## Test

The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

## return LAG or not
KAFKA_OK=$(docker exec -it broker /bin/kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group sadserver-group | awk 'NR==2{print $6}')

if [[ "${KAFKA_OK}" == "LAG"  ]] ; then
  KAFKA_LAG=$(docker exec -it broker /bin/kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group sadserver-group | awk 'NR==3{print $6}')
  if [[ "$KAFKA_LAG" -eq 0 ]]; then
    echo -n "OK"
    exit
  else
    echo -n "NO"
    exit
  fi
fi

KAFKA_OK=$(docker exec -it broker /bin/kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group sadserver-group | awk 'NR==3{print $6}')

if [[ "${KAFKA_OK}" -eq "not"  ]] ; then
  echo -n "NO"
  exit
fi
```
