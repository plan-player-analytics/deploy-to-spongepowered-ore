#!/bin/bash
set -e

url="https://ore.spongepowered.org/projects/${INPUT_PLUGIN_ID}/versions"

echo "Uploading plugin to ${url}"
HTTP_CODE=$(curl --write-out "%{http_code} --silent -u "OreApi apikey=\"${INPUT_ORE_API_KEY}\"" -F "plugin-info={\"create_forum_post\": ${INPUT_CREATE_POST},\"description\": \"${INPUT_VERSION_DESCRIPTION}\"}" -F "plugin-file=@${INPUT_FILE_PATH}" $url)

if [ $HTTP_CODE -eq 200 ]; then
    echo "Success"
    exit 0
fi

if [ $HTTP_CODE -eq 401 ]; then
    echo "Api session is missing, invalid or expired"
    exit 1
fi

if [ $HTTP_CODE -eq 403 ]; then
    echo "Missing create_version -permission"
    exit 1
fi

echo "Unknown http code ${HTTP_CODE}"
exit 1