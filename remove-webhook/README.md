## Remove-webhook

Script to remove the rancher-webhook from downstream clusters.

## Background

The rancher webhook was added to downstream clusters beginning with rancher v2.7.2. 
On a rollback from a version >= 2.7.2 to a version < 2.7.2, the webhook will stay in the downstream clusters. 
Since each version of the webhook is 1-1 compatible with a specific version of rancher, this can result in unexpected behavior.

## Usage

```bash
## create a token through the UI. The token should have no scope and be made for a user who is a global admin.
read -s RANCHER_TOKEN && export RANCHER_TOKEN
## the server url for rancher - you can get this value thorugh the server-url setting
read -s RANCHER_URL && export RANCHER_URL
bash remove-webhook.sh
```

## Notes
- The webhook is automatically deployed by rancher in all clusters
- This script should be run after rolling-back to the desired version (i.e. if going from 2.7.2 -> 2.7.0, only run this script after 2.7.0 is running)
