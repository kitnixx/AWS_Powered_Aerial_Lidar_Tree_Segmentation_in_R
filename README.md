# CanyonCreekLidar

### Job Operations
```
# POST <ec2 dns>/start]
{
  "bucket": "canyon-creek-lidar-0",
  "data": "test-small-file",
  "algorithm": "dalponte2016",
  "ws": 10
}
--- other parameters may be passed too ---

# GET <ec2 dns>/status/<job id>
localhost/status/<job id>
ec2-18-234-255-76.compute-1.amazonaws.com/status/<job id>

# DELETE <ec2 dns>/cancel/<job id>
```

### Typical Docker Commands
```
# SSH into EC2 instance
ssh -i "key.pem" ec2-user@<ec2 DNS>

# Pull image
docker pull gearsmotion789/canyoncreeklidar

# Run container with Cloudwatch Logging
docker run -p 80:80 -d --name canyoncreeklidar --restart unless-stopped --log-driver=awslogs --log-opt awslogs-group=CanyonCreekLidar gearsmotion789/canyoncreeklidar

# Open container terminal
docker exec -it canyoncreeklidar bash
```

### Extras
```
# Download folder from S3 to local
aws s3 sync "s3://canyon-creek-bucket-0/<folder>/<job id>" "./<job id>"

# Get log outputs from running docker container
docker logs canyoncreeklidar
```

### Prequistites
- Download node.js: https://nodejs.org/en/download
- Download git: https://git-scm.com/downloads
- Download R: https://ftp.osuosl.org/pub/cran
- Add R to environmental variabale PATH
  - C:/Program Files/R/<version>/bin
- ```git clone https://github.com/gearsmotion789/CanyonCreekLidar.git```
- ```npm install``` in CanyonCreekLidar (root) directory
- Install all dependencies via R from ```ec2_batch/install.R```
- ```cd backend```
- ```node test.js```

### Information
- s3_download (runs on EC2 instance)
  - downloads data from S3 to local machine
- ec2_batch (runs on EC2 instance)
  - generates the outputs from the Rscript
- s3_upload (runs on EC2 instance)
  - uploads outputs to S3 folder
- pc_to_s3 (runs on your own local machine)
  - modified version of "s3_upload", uploads all folders from local machine to S3

### Normal GitHub setup
- Make a zip just in case things go wrong
  - git init
  - git remote add origin https://github.com/gearsmotion789/CanyonCreekLidar.git
  - git fetch
  - git checkout master
  - git pull origin master
  - git add .
  - git commit -m "stuff"
  - git push origin master
- Pull changes
  - git fetch
  - git pull
- Push changes
  - first do Pull changes
  - git add .
  - git commit -m "comment"
  - git push

### References
- Setup Docker on EC2 Instance
  - https://hackernoon.com/running-docker-on-aws-ec2-83a14b780c56
- Cloudwatch Logging
  - https://cloudonaut.io/a-simple-way-to-manage-log-messages-from-containers-cloudwatch-logs/#:~:text=Simple%20Example,and%20attach%20the%20CloudWatchLogsFullAccess%20policy
