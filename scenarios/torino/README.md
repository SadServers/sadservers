# "Torino": Optimize grande Docker image

## Description

A Torino Node.js application is located in the <i>~/torino-app</i> directory.<br> You can run it directly with: <kbd>nohup node app.js > app.log 2>&1 &</kbd>. You can also verify that it works by running: <kbd>curl localhost:3000</kbd>
<br><br>
There is already a <i>torino</i> Docker image built with the Dockerfile in <i>~/torino-app</i>, but the resulting image size is 916 MB.
<br><br>
Your task is to optimize the Docker image size:<br>
1. Build a new Docker image for the Torino application, also called <i>torino:latest</i> but with a total size under 122 MB<br>
2. Create and run a container using this optimized image. 
<br><br>
NOTE: You can only use the existing Docker images in the server.<br>
To build a Node application you need to COPY in your Dockerfile, besides the <i>app.js</i> , the <i>package*.json</i> files and without Internet access, the <i>node_modules</i> directory, since you cannot <i>RUN npm install</i>.

## Test

The <i>torino</i> Docker image is less than 122 MB and <kbd>curl http://localhost:3000</kbd> returns <kbd>Hello from Torino!</kbd>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# Check if the application is running and responding correctly
APP_RUNNING=false
if curl -s http://localhost:3000 | grep -q "Hello from Torino!"; then
  APP_RUNNING=true
fi

# Get the size of the torino Docker image in MB
IMAGE_SIZE=$(docker images torino --format "table {{.Size}}" | tail -n +2 | head -1)

# Convert size to MB for comparison
IMAGE_OK=false
if [[ $IMAGE_SIZE == *"GB"* ]]; then
  # Convert GB to MB
  SIZE_VALUE=$(echo $IMAGE_SIZE | sed 's/GB//' | tr -d ' ')
  SIZE_MB=$(echo "$SIZE_VALUE * 1024" | bc -l | cut -d. -f1)
elif [[ $IMAGE_SIZE == *"MB"* ]]; then
  # Already in MB
  SIZE_MB=$(echo $IMAGE_SIZE | sed 's/MB//' | tr -d ' ' | cut -d. -f1)
else
  # Assume KB or B, convert to MB
  SIZE_MB=1
fi

# Check if size is less than 122MB
if [ "$SIZE_MB" -lt 122 ]; then
  IMAGE_OK=true
fi

# Both conditions must be true for OK
if [ "$APP_RUNNING" = true ] && [ "$IMAGE_OK" = true ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
