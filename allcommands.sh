# npm i

# npm run build

# npm run start


docker build -t threemay/goexpertbackendtest:1.0 .

docker run -d -p 3001:3001 \
-e CONNECTION_STRING=mongodb://host.docker.internal:27017/goexpert \
-e BACKEND_HOST_ADDRESS=http://localhost:3001 \
-e PORT=3001 \
threemay/goexpertbackendtest:1.0

mongosh "mongodb://localhost:27017"

