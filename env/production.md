Environment variables for backend
```
export RAILS_ENV="production"
export RACK_ENV="production"
export NODE_ENV="production"
export RAILS_LOG_TO_STDOUT="true"
export RAILS_MASTER_KEY="7cd690550b21a176659d2e098bc495a3"
export APP_DATABASE_HOST="miyoshidb01.database.windows.net"
export APP_DATABASE_PORT="1433"
export APP_DATABASE_NAME="MIYOSHIDB01"
export APP_DATABASE_USERNAME="miyoshi_usr@miyoshidb01"
export APP_DATABASE_PASSWORD="MysP@ssw0rd"
export BACKEND_HOST="miyoshibackend.azurewebsites.net"
export FRONTEND_HOST="purple-field-0781de800.2.azurestaticapps.net"
export FRONTEND_HOST_TEST="black-ocean-0a4abfe00.4.azurestaticapps.net"
export REDIS_HOST="miyoshi.redis.cache.windows.net"
export REDIS_PORT="6379"
export REDIS_PASSWORD="KkvmUk1K5GWowZmtI6Y9mFcmhrflJUhaPAzCaJzeVhs="
export API_KEY="D4kKNYJOIIuF2MN7uJrnhvrDw"
export SECRET_TOKEN="39e991a558cffc31a472fec75a5c83e603dfa95955a4d6932fcb3529a7f32b7a"
```

Environment variables for frontend
```
export NODE_ENV="production"
export NUXT_ENV_BASE_URL="https://miyoshibackend.azurewebsites.net"
```

Start-up script in the container for ssh
---
/usr/sbin/sshd
---