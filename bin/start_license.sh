#!/bin/bash
#
# @brief   Start license daemon
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

declare -A START_LICENSE_USAGE=(
    [USAGE_TOOL]="__start_license"
    [USAGE_ARG1]="[LICENSE FILE] License file path"
    [USAGE_ARG2]="[LOGGING FILE] Log file path"
    [USAGE_EX_PRE]="# Start license deamon"
    [USAGE_EX]="__start_license \$LICENSE_FILE \$LOGGING_FILE"
)
#
# @brief  Start license daemon
# @params Values required path of license file and log file
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __start_license "$LICF" "$LOGF"
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
function __start_license {
    local LICF=$1 LOGF=$2
    if [[ -n "${LICF}" && -n "${LOGF}" ]]; then
        MSG="Start license daemon"
        info_debug_message "$MSG" "$FUNC" "$FLEXLM_TOOL"
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        local FHOME=${config_flexlm_util[FLEX_HOME]}
        local FVERSION=${config_flexlm_util[FLEX_VERSION]}
        local FARCH=${config_flexlm_util[FLEX_ARCH]}
        local LMGRD="${FHOME}/${FVERSION}/${FARCH}/lmgrd"
        check_tool "${LMGRD}"
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            if [[ -e "${LICF}" && -f "${LICF}" ]]; then
                eval "${LMGRD} -c ${LICF} -l ${LOGF}"
                info_debug_message_end "Done" "$FUNC" "$FLEXLM_TOOL"
                return $SUCCESS
            fi
            MSG="Missing file [${LICF}]"
            info_debug_message "$MSG" "$FUNC" "$FLEXLM_TOOL"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$FLEXLM_TOOL"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$FLEXLM_TOOL"
        return $NOT_SUCCESS
    fi
    usage START_LICENSE_USAGE
    return $NOT_SUCCESS
}

