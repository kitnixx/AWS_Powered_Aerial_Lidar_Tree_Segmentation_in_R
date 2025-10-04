# AWS-Powered Aerial Lidar Tree Segmentation in R
<br/>
<img width="850" height="500" alt="image" src="https://github.com/user-attachments/assets/d3889ca8-ff08-4eb4-a8b3-8fdd57167192" /><br/>
<br/>
<img width="175" height="125" alt="image" src="https://github.com/user-attachments/assets/3fc6f01e-ffb9-4001-9766-e5b4c81f3fff" />&emsp;
<img width="300" height="250" alt="image" src="https://github.com/user-attachments/assets/6bee0bd7-1fc7-493b-8110-3da195ffdac8" />&emsp;
<img width="140" height="190" alt="image" src="https://github.com/user-attachments/assets/b25469c1-969e-4a03-98a1-7a10ba4a5cc9" />

#
<br/>
This is the experimental framework of a customizable DIY cloud application for aerial lidar-based individual tree segmentation in R. It serves as a skeleton or guide in creating your own cloud-based tree segmentation app. This original workflow was devloped by Katie Nicolato and Alex Feng in cooperation with the Aerial Information Systems Lab at Oregon State University and the US Forest Service.<br/>

<br/>The app is powered by Amazon Web Service (AWS) EC2 instances and segments input .las files stored in an AWS S3 bucket to output a tree point layer, tree crown layer, canopy height model, digital terrain model and point cloud metrics. It is fully customizable from instance tier to tree segmentation algorithm and can be configured to run on multiple instances at once.<br/> 

You must preemptively establish an AWS account, key pair and S3 bucket to deploy the app. You will also need to download a number of software programs to your local machine, which are listed in the section below labeled "Setup for Local Part of the Workflow."<br/><br/>

## Application Workflow

<br/>1. Acquire and prepare aerial lidar point clouds in .las format by registering, classifying. cleaning, cliping and merging files if necessary in external software to create areas of interest. R contains some tools to perform these actions should you choose to integrate them into your frontend script for the app instead. We recommend the open-source lidar programs CloudCompare for visualization and LAStools for manipulation. <br/><br/>

&emsp;&emsp;<img width="100" height="100" alt="images" src="https://github.com/user-attachments/assets/15156e80-a7ad-4559-9056-bb97a2f59bda" />&emsp;&emsp;
<img width="100" height="100" alt="rapidlasso_LAStools_logo" src="https://github.com/user-attachments/assets/d6b95096-bd6a-4203-aa1b-2711d32c3b29" /><br/>

<br/>2. Upload .las files from local or cloud storage to your AWS S3 bucket.<br/>

<br/>&emsp;&emsp;<img width="100" height="100" alt="image" src="https://github.com/user-attachments/assets/157cceaa-f7fc-4d21-90de-455db857b840" />

<br/>3. Download all programs necessary for local development listed in the section, "Setup for Local Part of the Workflow." Pull this GitHub repository to your local machine using Git.<br/>

<br/>&emsp;&emsp;<img width="225" height="100" alt="github-logo-vector" src="https://github.com/user-attachments/assets/63ed02aa-395f-481f-8963-de8c7a0503c5" />&emsp;&emsp;
<img width="250" height="100" alt="images" src="https://github.com/user-attachments/assets/26ede33f-ef7e-4e61-a9bd-dfe94b3218a4" />

<br/>4. Edit the backend node.js and R scripts (we recommend Visual Studio IDE) to customize a Docker container and Amazon Machine Image (AMI) for cloud deployment of the app. Refer to the section, "Information on Script Names."<br/><br/>

&emsp;&emsp;<img width="400" height="100" alt="visual_studio_b72bcf9a-8de0-4ce0-816b-a9aa030260c0-4577576" src="https://github.com/user-attachments/assets/9be453b6-3651-4917-9661-c3b9476b8e3f" />&emsp;&emsp;
<img width="250" height="100" alt="Node js_logo svg" src="https://github.com/user-attachments/assets/605bf1e7-0566-4318-8595-bcb33aeee1fc" />&emsp;&emsp;
<img width="125" height="150" alt="R_logo svg" src="https://github.com/user-attachments/assets/cc8c4ba4-d6aa-4156-8a8e-94a17b4b205a" />

<br/>5. Spin up your AWS EC2 instance of choice - the default is free tier.<br/><br/>

&emsp;&emsp;<img width="100" height="100" alt="Amazon-EC2@4x-e1593195270371" src="https://github.com/user-attachments/assets/a536ae6a-143f-487d-a0cd-5a8b333af8a4" />

<br/>6. Deploy the Docker container and AMI to AWS servers using the AWS Elastic Beanstalk management service.<br/><br/>

&emsp;&emsp;<img width="100" height="100" alt="png-transparent-docker-hd-logo" src="https://github.com/user-attachments/assets/79ce8338-c410-4391-b07d-96eca88ddf26" />&emsp;&emsp;
<img width="100" height="100" alt="image" src="https://github.com/user-attachments/assets/401f691b-e477-4767-88a1-b3bb14cd78a2" />

<br/>7. Use Postman to locally customize tree segmentation parameters in the frontend R script.<br/><br/>

&emsp;&emsp;
   
<br/>8. Queue the processing job locally in Postman and post it to the cloud - SEND IT!<br/><br/>

&emsp;&emsp;
   
<br/>9. Monitor progress with AWS Cloudwatch.<br/><br/>

&emsp;&emsp;<img width="100" height="100" alt="aws-cloudwatch-8x" src="https://github.com/user-attachments/assets/9a93cf05-37ca-45ac-99b7-aac5f48d8563" />

<br/>10. Download tree segmentation outputs from your AWS S3 bucket to your local storage device.<br/><br/>

&emsp;&emsp;<img width="100" height="100" alt="image" src="https://github.com/user-attachments/assets/157cceaa-f7fc-4d21-90de-455db857b840" />

<br/>11. Rejoice!<br/><br/>

## Resources

Below are resources for modifying and executing the application.

### Typical GitHub Repository Setup
- Link existing folder with this repo
  - git init
  - git remote add origin https://github.com/kitnixx/AWS_Powered_Aerial_Lidar_Tree_Segmentation_in_R.git
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
- ```npm install``` in AWS_Powered_Aerial_Lidar_Tree_Segmentation_in_R (root) directory
- Install all dependencies via R from ```ec2_batch/install.R```
- ```cd backend```
  - Must be in backend directory, otherwise things don't work
- ```node test.js``` for quick test
- ```node index.js``` for backend REST API server

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
