## Upgrade-webhook

Script to upgrade the rancher-webhook on local and downstream clusters.

## Usage

```bash
## create a token through the UI. The token should have no scope and be made for a user who is a global admin.
read -s RANCHER_TOKEN && export RANCHER_TOKEN
## the server url for rancher - you can get this value thorugh the server-url setting
read -s RANCHER_URL && export RANCHER_URL
## Webhook image that we want to upgrade the current webhook deployment to
read -s WEBHOOK_IMAGE && export WEBHOOK_IMAGE
bash upgrade-webhook.sh
```
For Rancher setups using self-signed certificates, you can specify `--insecure-skip-tls-verify` to force the script to ignore TLS certificate verification. Note that this option is insecure, and should be avoided for production setups.

## Notes
- The webhook is automatically deployed by rancher in all clusters

