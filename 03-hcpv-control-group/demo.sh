#!/usr/bin/env bash
EPOCH=$(date +"%s")

# The number of hours to go back. We have 30 days of logs, roughly, so
# 720 is the maximum here.

# Obtained using this guide. https://cloud.hashicorp.com/docs/hcp/access-control/service-principals
# Needs admin role.
HCP_CLIENT_ID=
HCP_CLIENT_SECRET=

# These aren't super obvious but appear in URL parameters in the Portal at https://cloud.hashicorp.com
# The Organization ID will be in the URL of the accounts pages.
# The Project ID on any cluster detail page.
HCP_ORGANIZATION_ID=""
HCP_PROJECT_ID=""

# Name of the HVN the cluster is in. This generally defaults to `hvn`,
# but you may have changed it.
HCP_NETWORK_ID=hvn

# Name of the region the HVN is in. Something like us-west-2
HCP_REGION_NAME=ap-southeast-2

# Name of the cluster. This generally defaults to `vault-cluster`,
# but you may have changed it.
HCP_CLUSTER_ID=hcpv-cluster

case $1 in
	download)
		HOURSTOGET=$2
		echo "Downloading HCP Vault audit logs from the last $HOURSTOGET hour(s)"
        	# Start time in UNIX epoch format (e.g. seconds since 1970)
        	############
        	############

        	# set -euo pipefail
        	# set -euo pipefail
		: ${HCP_ORGANIZATION_ID?"Need to provide an HCP_ORGANIZATION_ID"}
		: ${HCP_PROJECT_ID?"Need to provide a HCP_PROJECT_ID"}
		: ${HCP_CLUSTER_ID?"Need to provide a HCP_CLUSTER_ID"}
		: ${HCP_NETWORK_ID?"Need to provide a HCP_NETWORK_ID"}

		HCP_API_URL=https://api.cloud.hashicorp.com/

		# api.hashicorp.cloud is not a typo, AUDIENCE is the same in all environments
		HCP_ACCESS_TOKEN=$(curl --silent --request POST --header "Content-Type: application/json" \
  			--data '{
    					"audience": "https://api.hashicorp.cloud",
    					"grant_type": "client_credentials",
   		 			"client_id": "'"$HCP_CLIENT_ID"'",
    					"client_secret": "'"$HCP_CLIENT_SECRET"'"
  			}' \
      		https://auth.hashicorp.com/oauth/token | jq '.access_token' --raw-output)

		log() {
			>&2 echo "=====> $@"
		}

		# get's a log_id for start_time end_time
		getlogs() {
    				payload=$(cat <<-EOF
				{
  					"interval_start": "${1}T${2}",
  					"interval_end": "${3}T${4}",
  					"location": {
     							"region": {
        							"region": "${HCP_REGION_NAME}",
        							"provider": "aws"
     							}
  					}	
				}
				EOF
           			)	
    			log "Request Logs Request: ${HCP_API_URL}vault/2020-11-25/organizations/${HCP_ORGANIZATION_ID}/projects/${HCP_PROJECT_ID}/clusters/${HCP_CLUSTER_ID}/auditlog"
    			curl --show-error -s -d "${payload}" -X POST -H "Authorization: Bearer ${HCP_ACCESS_TOKEN}" "${HCP_API_URL}vault/2020-11-25/organizations/${HCP_ORGANIZATION_ID}/projects/${HCP_PROJECT_ID}/clusters/${HCP_CLUSTER_ID}/auditlog" -H  "accept: application/json"

		}

		status() {
    			log "Status request: ${HCP_API_URL}vault/2020-11-25/organizations/${HCP_ORGANIZATION_ID}/projects/${HCP_PROJECT_ID}/clusters/${HCP_CLUSTER_ID}/auditlog/$1"
    			curl --show-error -s -X GET -H "Authorization: Bearer ${HCP_ACCESS_TOKEN}" "${HCP_API_URL}vault/2020-11-25/organizations/${HCP_ORGANIZATION_ID}/projects/${HCP_PROJECT_ID}/clusters/${HCP_CLUSTER_ID}/auditlog/$1" -H  "accept: application/json"
		}


		put() {
    			startdt=$(date --rfc-3339=seconds --date="@$1")
    			enddt=$(date --rfc-3339=seconds --date="@$2")

    			log "Fetching logs between: $startdt and $enddt"

    			getlogs $startdt $enddt
		}

		for n in `seq 1 $HOURSTOGET`; do
    			st=$(expr $EPOCH - \( $n \* 3600 \) )
    			ed=$(expr $EPOCH - \( \( $n - 1 \) \* 3600 \) )

	    		log_id=$(put $st $ed | jq -r '.log_id')

    			success=
    			backoff=10
    			for t in {1..10}; do
        			log "try ($t / 10)"
        			output=$(status $log_id)
        			echo $output
        			download_url=$(echo $output | jq -r '.log.download_url')

        			if [ -n "${download_url}" ] && [ "${download_url}" != "null" ]; then
            				log "Found a download URL: ${download_url}"
            				success="true"
            				break
        			fi

        			sleep $backoff
    			done

    			if [ "$success" != "true" ]; then
        			log "FAILED: no download url after 10 attempts. Exiting everything."
        			exit 1
    			fi

    			log "Downloading ${download_url} ..."
    			if ! curl -s "${download_url}" -OJ; then
       				log "FAILED do download ${download_url}. Exiting everything."
       				exit 1
    			else
        			log "This download is complete."
				    gunzip *auditlogs*
    			fi
		done
	;;
	access)
		file_name=$(ls auditlogs* | sort | tail -n 1)
		path="aws_root_keys/data/$2"
		(echo Date/Time  IPAddress  Operation  Path  Username ; \
		jq -c --arg path "$path" --arg val "$val" 'select((.request.path | contains($path)) and (.error | length > 0))' "$file_name" | \
		jq -r '[.time, .request.remote_address, .request.operation, .request.path, .auth.metadata.username] | @tsv') | \
		column -t
	;;
	approval)
		file_name=$(ls auditlogs* | sort | tail -n 1)
		path="control-group"
		(echo Date/Time  IPAddress  Operation  Path  Username Approved Data; \
		#jq -c --arg path "$path" 'select((.request.path | contains($path)) and (.error | length > 0))' "$file_name" | \
		jq -c --arg path "$path" 'select((.request.path | contains($path)) and (.response.data.request_path | length > 0))' "$file_name" | \
		jq -r '[.time, .request.remote_address, .request.operation, .request.path, .auth.metadata.username, .response.data.approved, .response.data.request_path] | @tsv') | \
		column -t
	;;
esac
