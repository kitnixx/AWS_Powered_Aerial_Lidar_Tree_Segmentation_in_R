# AWS-Powered Lidar Tree Segmentation in R

This repository contains the framework of a customizable DIY cloud application for lidar-based individual tree segmentation in R using the lidR package.

The app is powered by Amazon Web Service (AWS) EC2 instances and segments input .las files stored in an AWS S3 bucket to output a tree point layer, tree crown layer, canopy height model and digital terrain model.

The app is fully customizable from instance tier to tree segmentation algorithm. You must preemptively establish an AWS account, key pair and S3 bucket to deploy the app.

The workflow of the app is as follows:

1. Modify the js.node script to customize an Amazon Machine Image (AMI) of R software.
2. Package the AMI in a Docker container to deploy in the AWS environment.
3. Spin up your AWS EC2 instance of choice - the default is free tier.
4. Deploy the AMI to AWS servers using the AWS Elastic Beanstalk management service.
6. Locally modify the R script in Postman to customize lidar segmentation parameters.
7. Queue the processing job in Postman and send it to the cloud.
8. Monitor lidar processing progress with AWS Cloudwatch.
9. Download segmentation outputs from the AWS S3 bucket.

### Job Operations
- Send job
```
POST <ec2 dns>/start
{
  "bucket": "canyon-creek-lidar-0",
  "data": "test-small-file",
  "algorithm": "mcws",
  "ws": 10
}
--- other parameters may be passed too ---
```
- Get job status
```
GET <ec2 dns>/status/<job id>
```
- Cancel job
```
DELETE <ec2 dns>/cancel/<job id>
```

### Typical Docker Commands
```
# SSH into EC2 instance
ssh -i "key.pem" ec2-user@<ec2 dns>

# Pull image
docker pull tobyloki/canyoncreeklidar

# Run container with Cloudwatch Logging
docker run -p 80:80 -d --name canyoncreeklidar --restart unless-stopped --log-driver=awslogs --log-opt awslogs-group=CanyonCreekLidar tobyloki/canyoncreeklidar

# Open container terminal
docker exec -it canyoncreeklidar bash

# Stop container
docker rm -f canyoncreeklidar
```

### Extras
```
# Download folder from S3 to local
aws s3 sync "s3://canyon-creek-bucket-0/<folder>/<job id>" "./<job id>"
aws s3 sync "s3://canyon-creek-bucket-0/test-small-file/asdf" "./asdf"

# Get log outputs from running docker container
docker logs canyoncreeklidar
```

### Setup for running locally
- Install node.js: https://nodejs.org/en/download
- Install git: https://git-scm.com/downloads
- Install R: https://ftp.osuosl.org/pub/cran
- Add R to environmental variabale PATH
  - ```C:/Program Files/R/<version>/bin```
- Install AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html#cliv2-windows-install
  - ```aws configure```
  - Fill credentials with AWS user credentials in IAM users
- ```git clone https://github.com/tobyloki/CanyonCreekLidar.git```
- ```npm install``` in CanyonCreekLidar (root) directory
- Install all dependencies via R from ```ec2_batch/install.R```
- ```cd backend```
  - must be in backend directory, otherwise things don't work
- ```node test.js``` for quick test
- ```node index.js``` for backend REST API server

### Information
- backend (runs on EC2 instance)
  - hosts backend so that you can make REST API calls to it for job operations
  - when POST occurs, it triggers s3_download, ec2_batch, and then s3_upload internal to ec2_batch, then uploads job params via s2_upload
- s3_download (runs on EC2 instance)
  - downloads data from S3 to local machine
- ec2_batch (runs on EC2 instance)
  - generates the outputs from the Rscript
- s3_upload (runs on EC2 instance)
  - uploads outputs to S3 folder
- pc_to_s3 (runs on your own local machine)
  - modified version of "s3_upload", uploads all folders from local machine to S3

### Normal GitHub setup
- Link existing folder with this repo
  - git init
  - git remote add origin https://github.com/tobyloki/CanyonCreekLidar.git
  - git fetch
  - git checkout master
  - git pull
  - git add .
  - git commit -m "comment"
  - git push
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
