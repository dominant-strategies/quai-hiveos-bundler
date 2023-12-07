How to deploy :) 

docker build --build-arg hive_version=0.0.13  --build-arg miner_tag=v0.1.0-rc.1  --build-arg AWS_SECRET_ACCESS_KEY=XXXXXXXXXX --build-arg AWS_ACCESS_KEY_ID=XXXXXX -t gpu_test .

Of course this is a demo, change the s3 or destination of build in Dockerfile
