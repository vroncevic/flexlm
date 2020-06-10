#!/bin/bash
#
# @brief   Load licenses parameters from configuration file
# @version ver.1.0.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

declare -A LOAD_LICENSES_USAGE=(
    [USAGE_TOOL]="__load_licenses"
    [USAGE_ARG1]="[CONFIG FILE] Configuration file woth licenses"
    [USAGE_EX_PRE]="# Load license"
    [USAGE_EX]="__load_licenses \$CFG"
)

#
# @brief  Load licenses parameters from configuration file
# @param  Value required path of configuration file
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __load_licenses "$CF"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function __load_licenses() {
    local CF=$1
    if [ -n "${CF}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Loading licenses from file [${CF}]"
        info_debug_message "$MSG" "$FUNC" "$FLEXLM_TOOL"
        load_util_conf "$CF" license_list
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            info_debug_message_end "Done" "$FUNC" "$FLEXLM_TOOL"
            return $SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$FLEXLM_TOOL"
        return $NOT_SUCCESS
    fi
    usage LOAD_LICENSES_USAGE
    return $NOT_SUCCESS
}

