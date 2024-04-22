CREATE DATABASE miyoshi_development
COLLATE Japanese_CI_AS;
GO

USE miyoshi_development
GO

CREATE LOGIN miyoshiuser WITH PASSWORD='$(pass)';
CREATE USER miyoshiuser FOR LOGIN miyoshiuser WITH DEFAULT_SCHEMA=miyoshiuser;
GO

CREATE SCHEMA miyoshiuser AUTHORIZATION miyoshiuser;
GO

GRANT ALL PRIVILEGES ON SCHEMA::miyoshiuser TO miyoshiuser;
GO

GRANT CONTROL ON DATABASE::miyoshi_development TO miyoshiuser;
GO
