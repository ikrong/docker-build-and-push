# git clone 某个分支
git clone -b v0.8.1 --depth 1 https://github.com/vllm-project/vllm.git ./source
cp Dockerfile ./source/Dockerfile

cd ./source 

docker build -t registry.cn-beijing.aliyuncs.com/ikrong/mirrors:vllm-0.8.1 .

docker push registry.cn-beijing.aliyuncs.com/ikrong/mirrors:vllm-0.8.1