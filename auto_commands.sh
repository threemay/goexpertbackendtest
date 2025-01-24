# docker build a new image with image tag based on git tag
# usage: ./build.sh
# example: ./build.sh

# exit when any command fails
set -e

# get git tag
# git_tag=$(git describe --tags --abbrev=0)

git_tag=1.2

echo $git_tag
# build docker image
docker build -t "threemay/goexpertbackendtest:${git_tag}" .

# # push docker image
# docker push "michaelkubota/terraform-aws-eks-node-group:${git_tag}"

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/a9h1i7z6
docker tag threemay/goexpertbackendtest:${git_tag} public.ecr.aws/a9h1i7z6/threemay/goexpertbackendtest:${git_tag}
docker push public.ecr.aws/a9h1i7z6/threemay/goexpertbackendtest:${git_tag}

# pull the image and run it locally 
docker pull public.ecr.aws/a9h1i7z6/threemay/goexpertbackendtest:${git_tag}

docker run -d -p 3001:3001 \
-e CONNECTION_STRING=mongodb://host.docker.internal:27017/goexpert \
-e BACKEND_HOST_ADDRESS=http://localhost:3001 \
-e PORT=3001 \
public.ecr.aws/a9h1i7z6/threemay/goexpertbackendtest:${git_tag}


# and run docker 
