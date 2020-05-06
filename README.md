# CanyonCreekLidar

### Job Operations
```
# GET /start/<S3 main folder>
localhost/start/data
ec2-18-234-255-76.compute-1.amazonaws.com/start/data

# GET /status/<job id>
localhost/status/<job id>
ec2-18-234-255-76.compute-1.amazonaws.com/status/<job id>

# GET /cancel/<job id>
localhost/cancel/<job id>
ec2-18-234-255-76.compute-1.amazonaws.com/cancel/<job id>
```

### Typical Docker Commands
```
# SSH into EC2 instance
ssh -i "key.pem" ec2-user@ec2-18-234-255-76.compute-1.amazonaws.com

# Pull image
docker pull gearsmotion789/rbase
docker pull gearsmotion789/canyoncreeklidar

# Run container
docker run -d -it --name rbase --restart unless-stopped gearsmotion789/rbase
docker run -p 80:80 -d --name canyoncreeklidar --restart unless-stopped gearsmotion789/canyoncreeklidar

# Open container terminal
docker exec -it rbase bash
docker exec -it canyoncreeklidar bash
```

### Setup Docker on EC2 Instance
- https://hackernoon.com/running-docker-on-aws-ec2-83a14b780c56

### Prequistites
1. Download node.js: https://nodejs.org/en/download
2. Download git: https://git-scm.com/downloads
3. Run ```npm install``` in each root directory

### Infromation
- s3_download (runs on EC2 instance)
  - downloads all folders from S3 on to local machine
- ec2_batch (runs on EC2 instance)
  - generates the _clipped & _normalized files for each folder, containing the .las files & 1 .shp file
- s3_upload (runs on EC2 instance)
  - uploads _clipped & _normalized files from local machine to S3, & then deletes folders
- pc_to_s3 (runs on your own local machine)
  - modified version of "s3_upload", uploads all folders from local machine to S3
- start_server (runs on your own local machine)
  - automates the EC2 batch processing
    - starts EC2 instance
    - calls s3_download
    - calls ec2_batch
    - calls s3_upload
    - stops EC2 instance

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

### Github info

- Prereq
  - You have to been in the same folder that was "Cloned" from this repo
  - OR you can do
    - git init
  - If you see "double folder icon" instead of "single folder" icon, do below, then [git init]
    - rm -rf .git
- Add Repo
  - git remote add LeapRobot https://github.com/gearsmotion789/CanyonCreekLidar.git
- Remove Repo
  - git remove rm LeapRobot
- Delete Branch
  - git push origin --delete [branch]
- Push
  - (Prereq)
    - must do below to get updated repo before pushing your own folder (so save a zip backup!)
      - git pull origin master
  - git add .
  - git commit -m "Update"
  - git push LeapRobot master
    - if you cloned from this repo, then run
      - git push origin master (if you didn't follow "Add Repo")
    - if you get error "Changes not staged for commit:"
      - git add [files you want to track]
- Pull
  - git fetch
  - git checkout master
  - git pull LeapRobot master
