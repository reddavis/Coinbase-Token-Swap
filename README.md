# Coinbase Token Swap

Based heavily off [Spotify Token Swap](https://github.com/bih/spotify-token-swap-service). This is a Sinatra app for supporting the auth flow on Coinbase. The main primary reason for using a service like this is so you don't have to store your secret key in your iOS/macOS application.

## Deploy To Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Configuration

The app expects these ENV variables:

- CLIENT_ID
- CLIENT_SECRET
- CLIENT_REDIRECT_URL

For local development you will need to create a `.env` file that uses the format of the `.env.example` file included in the repository.

## API

### POST /api/token

#### Request

```bash
curl -X "POST" "https://<you-url>/api/token" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
  "code": "<code>"
}'
```

#### Response

```json
{
  "access_token" : "...",
  "token_type" : "bearer",
  "expires_in" : 7200,
  "refresh_token" : "...",
  "scope" : "wallet:user:read wallet:accounts:read"
}
```

### POST /api/refresh_token

#### Request

```bash
curl -X "POST" "https://<you-url>/api/refresh_token" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
  "refresh_token": "<refresh-token>"
}'
```

#### Response

```json
{
  "access_token" : "...",
  "token_type" : "bearer",
  "expires_in" : 7200,
  "refresh_token" : "...",
  "scope" : "wallet:user:read wallet:accounts:read"
}
```