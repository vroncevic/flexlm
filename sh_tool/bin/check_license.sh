#!/bin/bash
#
# @brief   Check license (status) on port
# @version ver.1.0.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

declare -A CHECK_LICENSE_Usage=(
    [Usage_TOOL]="__check_license"
    [Usage_ARG1]="[PORT NUMBER] Port number for license"
    [Usage_EX_PRE]="# Check license on port 5280"
    [Usage_EX]="__check_license 5280"
)

#
# @brief  Check license (status) on port
# @param  Valie required port number
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __check_license "5280"
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
function __check_license {
    local LP=$1
    if [ -n "${LP}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Checking license on port [${LP}]"
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
            eval "${LMUTIL} lmstat -a -c ${LA}"
            info_debug_message_end "Done" "$FUNC" "$FLEXLM_TOOL"
            return $SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$FLEXLM_TOOL"
        return $NOT_SUCCESS
    fi
    usage CHECK_LICENSE_Usage
    return $NOT_SUCCESS
}

