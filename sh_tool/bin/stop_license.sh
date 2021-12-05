#!/bin/bash
#
# @brief   FlexLM Manager
# @version ver.2.0
# @date    Sun Nov 21 11:40:40 CET 2021
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#

declare -A STOP_LICENSE_USAGE=(
    [USAGE_TOOL]="__stop_license"
    [USAGE_ARG1]="[PORT NUMBER] Port number for license"
    [USAGE_EX_PRE]="# Stop license deamon with port number 5280"
    [USAGE_EX]="__stop_license 5280"
)

#
# @brief  Stop license daemon
# @param  Value required port number
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __stop_license "$LP"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function __stop_license {
    local LP=$1
    if [ -n "${LP}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Stop license daemon on port [${LP}]"
        info_debug_message "$MSG" "$FUNC" "$FLEXLM_TOOL"
        local FHOME=${config_flexlm_util[FLEX_HOME]}
        local FVERSION=${config_flexlm_util[FLEX_VERSION]}
        local FARCH=${config_flexlm_util[FLEX_ARCH]}
        local FHOST=${config_flexlm_util[FLEX_HOST]}
        local LMUTIL="${FHOME}/${FVERSION}/${FARCH}/lmutil"
        check_tool "${LMUTIL}"
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local LA="${LP}@${FHOST}"
            eval "${LMUTIL} lmdown -c ${LA}"
            info_debug_message_end "Done" "$FUNC" "$FLEXLM_TOOL"
            return $SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$FLEXLM_TOOL"
        return $NOT_SUCCESS
    fi
    usage STOP_LICENSE_USAGE
    return $NOT_SUCCESS
}

