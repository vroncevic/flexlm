#!/bin/bash
#
# @brief   Licenses Server Manager (wrapper)
# @version ver.1.0.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/hash.sh
.    ${UTIL}/bin/check_op.sh
.    ${UTIL}/bin/check_root.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/logging.sh
.    ${UTIL}/bin/load_conf.sh
.    ${UTIL}/bin/load_util_conf.sh
.    ${UTIL}/bin/progress_bar.sh

FLEXLM_TOOL=flexlm
FLEXLM_VERSION=ver.1.0
FLEXLM_HOME=${UTIL_ROOT}/${FLEXLM_TOOL}/${FLEXLM_VERSION}
FLEXLM_CFG=${FLEXLM_HOME}/conf/${FLEXLM_TOOL}.cfg
FLEXLM_UTIL_CFG=${FLEXLM_HOME}/conf/${FLEXLM_TOOL}_util.cfg
FLEXLM_LOG=${FLEXLM_HOME}/log

.    ${FLEXLM_HOME}/bin/check_license.sh
.    ${FLEXLM_HOME}/bin/load_licenses.sh
.    ${FLEXLM_HOME}/bin/start_license.sh
.    ${FLEXLM_HOME}/bin/stop_license.sh

declare -A FLEXLM_USAGE=(
    [Usage_TOOL]="${FLEXLM_TOOL}"
    [Usage_ARG1]="[COMMAND] start | stop | restart | status"
    [Usage_ARG2]="[VENDOR NAME] cadence | mentor"
    [Usage_EX_PRE]="# Start license server"
    [Usage_EX]="${FLEXLM_TOOL} start mentor"
)

declare -A FLEXLM_LOGGING=(
    [LOG_TOOL]="${FLEXLM_TOOL}"
    [LOG_FLAG]="info"
    [LOG_PATH]="${FLEXLM_LOG}"
    [LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
    [BW]=50
    [MP]=100
    [SLEEP]=0.01
)

TOOL_DBG="false"
TOOL_LOG="false"
TOOL_NOTIFY="false"

#
# @brief   Main function 
# @params  Values required operation and vendor type of license
# @exitval Function __flexlm exit with integer value
#             0   - success operation
#            128 - missing argument(s) from cli
#            129 - failed to load tool script configuration from files
#            130 - failed to load configuration file with licenses
#            131 - wrong vendor argument
#            132 - wrong operation argument
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __flexlm $OP $LICENSE_PORT
#
function __flexlm {
    local OP=$1 VLIC=$2
    if [[ -n "${OP}" && -n "${VLIC}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        local STATUS_CONF STATUS_CONF_UTIL STATUS
        MSG="Loading basic and util configuration!"
        info_debug_message "$MSG" "$FUNC" "$FLEXLM_TOOL"
        progress_bar PB_STRUCTURE
        declare -A config_flexlm=()
        load_conf "$FLEXLM_CFG" config_flexlm
        STATUS_CONF=$?
        declare -A config_flexlm_util=()
        load_util_conf "$FLEXLM_UTIL_CFG" config_flexlm_util
        STATUS_CONF_UTIL=$?
        declare -A STATUS_STRUCTURE=(
            [1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL
        )
        check_status STATUS_STRUCTURE
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$FLEXLM_TOOL"
            exit 129
        fi
        TOOL_DBG=${config_flexlm[DEBUGGING]}
        TOOL_LOG=${config_flexlm[LOGGING]}
        TOOL_NOTIFY=${config_flexlm[EMAILING]}
        declare -A license_list=()
        __load_licenses "${config_flexlm_util[FLEX_LIC_CONFIG]}"
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local LFILE="LIC_FILE_" LPORT="LIC_PORT_" LLOG="LIC_LOG_"
            if [ "${VLIC}" == "mentor" ]; then
                SUFIX=$(echo ${VLIC} | awk '{print toupper($0)}')
                LFILE="LIC_FILE_${SUFIX}"
                LPORT="LIC_PORT_${SUFIX}"
                LLOG="LIC_LOG_${SUFIX}"
            elif [ "${VLIC}" == "cadence" ]; then
                SUFIX=$(echo ${VLIC} | awk '{print toupper($0)}')
                LFILE="LIC_FILE_${SUFIX}"
                LPORT="LIC_PORT_${SUFIX}"
                LLOG="LIC_LOG_${SUFIX}"
            else
                usage FLEXLM_USAGE
                exit 131
            fi
            local LIC_FILE=$(get_item "$LFILE" license_list)
            local LIC_PORT=$(get_item "$LPORT" license_list)
            local LOG_FILE=$(get_item "$LLOG" license_list)
            local OPERATIONS=${config_flexlm_util[FLEX_OPERATIONS]}
            IFS=' ' read -ra OPS <<< "${OPERATIONS}"
            check_op "${OP}" "${OPS[*]}"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
                case "${OP}" in
                    "start")
                        __start_license "$LIC_FILE" "$LOG_FILE"
                        ;;
                    "stop")
                        __stop_license $LIC_PORT
                        ;;
                    "restart")
                        __stop_license $LIC_PORT
                        sleep 2
                        __start_license "$LIC_FILE" "$LOG_FILE"
                        ;;
                    "status")
                        __check_licensec $LIC_PORT
                        ;;
                esac
                exit 0
            fi
            usage FLEXLM_USAGE
            exit 132
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$FLEXLM_TOOL"
        exit 130
    fi
    usage FLEXLM_USAGE
    exit 128
}

#
# @brief   Main entry point
# @params  required values operation and vendor type of license
# @exitval Script tool flexlm exit with integer value
#            0   - tool finished with success operation
#            127 - run tool script as root user from cli
#            128 - missing argument(s) from cli
#            129 - failed to load tool script configuration from files
#            130 - failed to load configuration file with licenses
#            131 - wrong vendor argument
#            132 - wrong operation argument
#
printf "\n%s\n%s\n\n" "${FLEXLM_TOOL} ${FLEXLM_VERSION}" "`date`"
check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
    __flexlm $1 $2
fi

exit 127

