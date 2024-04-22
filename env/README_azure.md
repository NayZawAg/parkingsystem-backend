Azure web apps
---
az acr login -n miyoshibackend --expose-token
az login --scope https://management.core.windows.net//.default
az acr login --name miyoshibackend

docker tag miyoshibackend miyoshibackend.azurecr.io/miyoshibackend:latest
docker tag miyoshiworker miyoshibackend.azurecr.io/miyoshiworker:latest

docker push miyoshibackend.azurecr.io/miyoshibackend:latest
docker push miyoshibackend.azurecr.io/miyoshiworker:latest

az acr repository list -n miyoshibackend

az acr update -n miyoshibackend --admin-enabled true
az acr credential show --resource-group myresourcegroup --name miyoshibackend
---

Open ssh
---
az webapp config set --resource-group myresourcegroup -n miyoshibackend --remote-debugging-enabled=false

az webapp create-remote-connection --subscription 55daf86d-e432-4b00-852e-0fee3e2c9d1c --resource-group myresourcegroup -n miyoshibackend &

https://miyoshibackend.scm.azurewebsites.net/webssh/host
---
SSH info
---
username: root
password: Docker!
---

Check storage
---
tcpping miyoshist01.file.core.windows.net
---

See instance
---
az webapp list-instances --name miyoshibackend --resource-group myresourcegroup -o table
az webapp ssh -n miyoshibackend -g myresourcegroup -i 463d027fb2a7a7d18bbc949ea083ae21414e984154427d657662e7d360eccd89
---

turn on container logging
---
az webapp log config --name miyoshibackend --resource-group myresourcegroup --docker-container-logging filesystem
az webapp log tail --name miyoshibackend --resource-group myresourcegroup
https://miyoshibackend.scm.azurewebsites.net/api/vfs/LogFiles/
---

Azure container instances
---
az container logs --resource-group myresourcegroup --name miyoshiworker
---

Push image to container registry
---
docker-compose -f docker-compose.azure.yml up --build -d
docker images
docker-compose -f docker-compose.azure.yml down
docker-compose -f docker-compose.azure.yml push
az acr repository show --name miyoshibackend --repository miyoshibackend
az acr repository show --name miyoshibackend --repository miyoshiworker
---

Create Azure context
---
docker login azure
docker context create aci myacicontext
docker context ls
---

Deploy application to Azure Container Instances
---
docker context use myacicontext
---

Create web apps
---
az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --is-linux
az webapp create --resource-group myResourceGroup --plan myAppServicePlan --name miyoshibackend --deployment-container-image-name MiyoshiBackend.azurecr.io/appsvc-tutorial-custom-image:latest

az webapp config appsettings set --resource-group myResourceGroup --name miyoshibackend --settings WEBSITES_PORT=8000

az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --sku S1 --is-linux
docker build --tag miyoshibackend-image .
docker run -it -p 80:3000 miyoshibackend-image
https://miyoshibackend.azurewebsites.net/
---


Azure conatiner instances
--
[ "/bin/bash", "-c", "bundle exec sidekiq -C config/sidekiq.yml" ]

Login azure
---
az acr login -n miyoshibackend --expose-token
az acr login --name miyoshibackend
---

Push image to container registry
---
docker-compose -f docker-compose.azure.yml up --build -d
docker images
docker-compose -f docker-compose.azure.yml down
docker-compose -f docker-compose.azure.yml push
az acr repository show --name miyoshibackend --repository miyoshibackend
az acr repository show --name miyoshibackend --repository miyoshiworker
---
