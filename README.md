# AWS-Powered Lidar Tree Segmentation Using the lidR Package in R

This is the experimental framework of a customizable DIY cloud application for lidar-based individual tree segmentation in R. It serves as a skeleton or guide in creating your own lidar segmentation app.

The app is powered by Amazon Web Service (AWS) EC2 instances and segments input .las files stored in an AWS S3 bucket to output a tree point layer, tree crown layer, canopy height model, digital terrain model and point cloud metrics.

The app is fully customizable from instance tier to tree segmentation algorithm. You must preemptively establish an AWS account, key pair and S3 bucket to deploy the app. The app can be customized for deployment across multiple instances at once.

The workflow of the app is as follows:

1. Edit the backend node.js and R scripts (we recommend Visual Studio IDE) to customize a Docker container and Amazon Machine Image (AMI) for cloud deployment of the app.
2. Spin up your AWS EC2 instance of choice - the default is free tier.
3. Deploy the Docker container and AMI to AWS servers using the AWS Elastic Beanstalk management service.
5. Use Postman to locally customize tree segmentation parameters in the frontend R script.
6. Queue the processing job in Postman and post it to the cloud - SEND IT!
7. Monitor progress with AWS Cloudwatch.
8. Download tree segmentation outputs from the AWS S3 bucket to your local storage device.
9. Rejoice!

Below are resources for modifying and executing the application.

## Resources

### Typical GitHub Repository Setup
- Link existing folder with this repo
  - git init
  - git remote add origin https://github.com/kitnixx/AWS_Powered_Lidar_Tree_Segmentation_in_R.git
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

### Information on Script Names
- backend (runs on EC2 instance)
  - Hosts backend so that you can make REST API calls to it for job operations
  - When POST occurs, it triggers s3_download, ec2_batch, and then s3_upload internal to ec2_batch, then uploads job params via s2_upload
- s3_download (runs on EC2 instance)
  - Downloads data from S3 to local machine
- ec2_batch (runs on EC2 instance)
  - Generates the outputs from the Rscript
- s3_upload (runs on EC2 instance)
  - Uploads outputs to S3 folder
- pc_to_s3 (runs on your own local machine)
  - Modified version of "s3_upload", uploads all folders from local machine to S3

### Setup for Local Part of the Workflow
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
  - Must be in backend directory, otherwise things don't work
- ```node test.js``` for quick test
- ```node index.js``` for backend REST API server

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

### Lidar Processing Job Operations
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

### Extras
```
# Download folder from S3 to local
aws s3 sync "s3://canyon-creek-bucket-0/<folder>/<job id>" "./<job id>"
aws s3 sync "s3://canyon-creek-bucket-0/test-small-file/asdf" "./asdf"

# Get log outputs from running docker container
docker logs canyoncreeklidar
```
### More References
- Setup Docker on EC2 Instance
  - https://hackernoon.com/running-docker-on-aws-ec2-83a14b780c56
- Cloudwatch Logging
  - https://cloudonaut.io/a-simple-way-to-manage-log-messages-from-containers-cloudwatch-logs/#:~:text=Simple%20Example,and%20attach%20the%20CloudWatchLogsFullAccess%20policy
