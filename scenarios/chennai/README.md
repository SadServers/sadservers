# "Chennai": Pull a Rabbit from a Hat

## Description

There is a RabbitMQ (RMQ) cluster defined in a docker-compose.yml file. 
<br><br>
Bring this system up and then run the producer.py script in such a way that is able to send messages to RMQ. In particular you have to send the message "hello-lwc".
<br><br>
- RMQ is a queuing system: messages are put in the queue with a "producer" and they are taken out from the other side by a "consumer". The queue name has to be the same for both.
<br><br>
- To send the message "hello-lwc": <kbd>python3 ~/producer.py hello-lwc</kbd>. Should return <kbd>Message sent to RabbitMQ</kbd>. "IncompatibleProtocolError" means RMQ is not working properly.<br><br>
- To test consuming it: <kbd>python3 ~/consumer.py</kbd>, this will retrieve the next message from the queue and print it. Once everything is working send more than one message so there's at least one in the queue when the validation runs.
<br><br>
- <b>Do not change the consumer.py and producer.py files</b>; if you do the Check My Solution will fail.

## Test

<kbd>python3 ~/consumer.py</kbd> returns <kbd>hello-lwc</kbd>
<br><br>
See /home/admin/agent/check.sh for the exact test.

<b>check.sh</b>

```
#!/bin/bash
res=$(nmap -p 5672 localhost|grep open|awk {'print $3'})
res=$(echo $res|tr -d '\r')

if [[ "$res" != "amqp" ]]
then
  echo -n "NO"
  exit -1
fi

res=$(md5sum /home/admin/consumer.py | awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" != "2216a243695c9d7834bdc299e68d051c" ]]
then
  echo -n "NO"
  exit -1
fi

res=$(md5sum /home/admin/producer.py | awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" != "86c470d5822fea6c31293f42f5e0aa34" ]]
then
  echo -n "NO"
  exit -1
fi

res=$(python3 /home/admin/consumer.py)
res=$(echo $res|tr -d '\r')

if [[ "$res" == "hello-lwc" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
