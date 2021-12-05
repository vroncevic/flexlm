#!/bin/bash
#
# @brief   FlexLM Manager
# @version ver.2.0
# @date    Sun Nov 21 11:40:40 CET 2021
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#

#
# @brief  Display logo
# @param  None
# @retval None
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# display_logo
#
function display_logo {
    local ORG='vroncevic'
    local REPO='flexlm'
    local INFO_URL="https://${ORG}.github.io/${REPO}"
    local INFO_TXT="github.io/${REPO}"
    local ISSUE_URL="https://github.com/${ORG}/${REPO}/issues/new/choose"
    local ISSUE_TXT='github.io/issue'
    local AUTHOR_URL="https://${ORG}.github.io/bio/"
    local AUTHOR_TXT="${ORG}.github.io"
    while IFS= read -r LINE
    do
        center 0
        printf "%s\n" "$LINE"
    done < ${FLEXLM_LOGO}
    center 2
    printf "Info   "
    printf "\e]8;;${INFO_URL}\a${INFO_TXT}\e]8;;\a"
    printf " ${FLEXLM_VERSION} \n"
    center 2
    printf "Issue  "
    printf "\e]8;;${ISSUE_URL}\a${ISSUE_TXT}\e]8;;\a"
    printf "\n"
    center 2
    printf "Author "
    printf "\e]8;;${AUTHOR_URL}\a${AUTHOR_TXT}\e]8;;\a"
    printf "\n\n"
}
