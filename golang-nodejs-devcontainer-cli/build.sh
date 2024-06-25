npm install -g @devcontainers/cli

set -e

cd "$(dirname $0)"

devcontainer build --image-name registry.cn-beijing.aliyuncs.com/ikrong/devcontainer:golang-nodejs-ubuntu-jammy --platform "linux/amd64,linux/arm64" --push true --workspace-folder .

echo "\nImage ${image_name} built successfully!"