#!/usr/bin/env bash
set -ex

if [ -z "$TRAVIS" ]; then
	echo "This script must be executed from Travis only !"
	exit 1
fi

echo "Downloading google cloud sdk..."
curl https://sdk.cloud.google.com | bash -s -- --disable-prompts > /dev/null
export PATH=${HOME}/google-cloud-sdk/bin:${PATH}
gcloud --quiet components install kubectl

echo "Decoding and adding key..."
echo ${GCLOUD_SERVICE_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json

echo "Setting up project config..."
gcloud --quiet config set project ${PROJECT_ID}
gcloud --quiet config set container/cluster ${CLUSTER_NAME}
gcloud --quiet config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud --quiet container clusters get-credentials ${CLUSTER_NAME}

echo "Building image..."

# Building image
docker build -t ${APP_NAME} .

# Tagging
docker tag ${APP_NAME} gcr.io/${PROJECT_ID}/${APP_NAME}:${TRAVIS_COMMIT}

# Pushing to container registry
gcloud docker -- push gcr.io/${PROJECT_ID}/${APP_NAME}:${TRAVIS_COMMIT}

echo "KubeCTL deploying..."
# Updating existing deploy
kubectl set image deployment/${DEPLOYMENT_NAME} ${CONTAINER_NAME}=gcr.io/${PROJECT_ID}/${APP_NAME}:${TRAVIS_COMMIT}