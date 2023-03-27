#!/bin/sh -e
# Code from  https://github.com/navikt/github-app-token-generator

# https://docs.github.com/en/rest/branches/branch-protection

repo=${GITHUB_REPOSITORY:?Missing required GITHUB_REPOSITORY environment variable}

[ -n "$INPUT_REPO" ] && repo="$INPUT_REPO"
jwt=$(cat ./jwt_token)
echo ${jwt}
response=$(curl -s -H "Authorization: Bearer ${jwt}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/app/installations")
installation_id=$(echo "$response" | jq '.[] | .id')

if [ "$installation_id" = "null" ]; then
    echo "Unable to get installation ID. Is the GitHub App installed on ${repo}?"
    echo "$response" | jq -r .message
    exit 1
fi

token=$(curl -s -X POST \
             -H "Authorization: Bearer ${jwt}" \
             -H "Accept: application/vnd.github.v3+json" \
             https://api.github.com/app/installations/"${installation_id}"/access_tokens | jq -r .token)

if [ "$token" = "null" ]; then
    echo "Unable to generate installation access token"
    exit 1
fi

# echo "token=${token}" >> token.txt
echo ${token}
export GITHUB_TOKEN=${token}

# # check
# is_protected=$(curl -s -L \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer ${token}"\
#   -H "X-GitHub-Api-Version: 2022-11-28" \
#   https://api.github.com/repos/${OWNER}/${repo}/branches/${BRANCH_TO_PROTECT}/protection) 
# echo "is_protected ${is_protected}"

# get_admin_protection=$(curl -s -L \
#   -X POST \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer ${token}"\
#   -H "X-GitHub-Api-Version: 2022-11-28" \
#   https://api.github.com/repos/${OWNER}/${repo}/branches/${BRANCH_TO_PROTECT}/protection/enforce_admins)
# echo "get_admin_protection ${get_admin_protection}"

# protected_branch=$(curl -s -L \
#   -X PUT \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer ${token}"\
#   -H "X-GitHub-Api-Version: 2022-11-28" \
#   https://api.github.com/repos/${OWNER}/${repo}/branches/${BRANCH_TO_PROTECT}/protection \
#   -d '{
#         "enforce_admins": true,
#         "required_status_checks": null,
#         "required_pull_request_reviews": {
#             "required_approving_review_count": 0
#         },
#         "restrictions": null
#     }' | jq '.enforce_admins | .enabled')

# echo ".enforce_admins | .enabled ${protected_branch}"

# delete=$(curl -s -L \
#   -X DELETE \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer ${token}"\
#   -H "X-GitHub-Api-Version: 2022-11-28" \
#   https://api.github.com/repos/${OWNER}/${repo}/branches/${BRANCH_TO_PROTECT}/protection)

# echo "Delete branch ${BRANCH_TO_PROTECT} ${delete}"