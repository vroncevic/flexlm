#!/bin/bash
#
# @brief   Licenses Server Manager (wrapper)
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
# 
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/hash.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/checkop.sh
. $UTIL/bin/sendmail.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/loadconf.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/progressbar.sh

FLEXLM_TOOL=flexlm
FLEXLM_VERSION=ver.1.0
FLEXLM_HOME=$UTIL_ROOT/$FLEXLM_TOOL/$FLEXLM_VERSION
FLEXLM_CFG=$FLEXLM_HOME/conf/$FLEXLM_TOOL.cfg
FLEXLM_UTIL_CFG=$FLEXLM_HOME/conf/${FLEXLM_TOOL}_util.cfg
FLEXLM_LOG=$FLEXLM_HOME/log

declare -A FLEXLM_USAGE=(
	[USAGE_TOOL]="__$FLEXLM_TOOL"
	[USAGE_ARG1]="[COMMAND]     start | stop | restart | status"
	[USAGE_ARG2]="[VENDOR_NAME] cadence | mentor"
	[USAGE_EX_PRE]="# Start license server"
	[USAGE_EX]="__$FLEXLM_TOOL start mentor"
)

declare -A CHECKLIC_USAGE=(
	[USAGE_TOOL]="__checklic"
	[USAGE_ARG1]="[PORT_NUMBER] Port number for license"
	[USAGE_EX_PRE]="# Check license on port 5280"
	[USAGE_EX]="__checklic 5280"
)

declare -A STOPLIC_USAGE=(
	[USAGE_TOOL]="__stoplic"
	[USAGE_ARG1]="[PORT_NUMBER] Port number for license"
	[USAGE_EX_PRE]="# Stop license deamon with port number 5280"
	[USAGE_EX]="__stoplic 5280"
)

declare -A STARTLIC_USAGE=(
	[USAGE_TOOL]="__startlic"
	[USAGE_ARG1]="[LICENSE_FILE] License file path"
	[USAGE_ARG2]="[LOG_FILE]     Log file path"
	[USAGE_EX_PRE]="# Start license deamon"
	[USAGE_EX]="__startlic \$LICENSE_FILE \$LOG_FILE"
)

declare -A FLEXLM_LOG=(
	[LOG_TOOL]="$FLEXLM_TOOL"
	[LOG_FLAG]="info"
	[LOG_PATH]="$FLEXLM_LOG"
	[LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
	[BAR_WIDTH]=50
	[MAX_PERCENT]=100
	[SLEEP]=0.01
)

TOOL_DBG="false"

#
# @brief  Load licenses parameters from configuration file
# @param  Value required path of configuration file
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __loadlicenses "$CONFIGURATION_FILE"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __loadlicenses() {
	local CONFIGURATION_FILE=$1
	if [ -n "$CONFIGURATION_FILE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		MSG="Loading config file [$CONFIGURATION_FILE]"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
		else
			printf "$SEND" "$FLEXLM_TOOL" "$MSG"
		fi
		__loadutilconf "$CONFIGURATION_FILE" licenselist
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "Done"
			else
				printf "$SEND" "$FLEXLM_TOOL" "Done"
			fi
			if [ "${configflexlm[LOGGING]}" == "true" ]; then
				FLEXLM_LOG[LOG_MSGE]=$MSG
				FLEXLM_LOG[LOG_FLAG]="info"
				__logging FLEXLM_LOG
			fi
			return $SUCCESS
		fi
	fi
	MSG="Missing configuration file $CONFIGURATION_FILE"
	if [ "${configflexlm[LOGGING]}" == "true" ]; then
		FLEXLM_LOG[MSG]=$MSG
		FLEXLM_LOG[FLAG]="error"
		__logging FLEXLM_LOG
	fi
	if [ "${configflexlm[EMAILING]}" == "true" ]; then
		__sendmail "$MSG" "${configflexlm[ADMIN_EMAIL]}"
	fi
    return $NOT_SUCCESS
}

#
# @brief  Check licenses
# @param  Valie required port number
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checklic "$LICENSE_PORT"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __checklic() {
    local LICENSE_PORT=$1
	if [ -n "$LICENSE_PORT" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local LMUTIL="$FLEXLM_HOME/$FLEXLM_VERSION/$FLEXLM_ARCH/lmutil"
		__checktool "$LMUTIL"
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			MSG="Checking license [$LICENSE_PORT]"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$FLEXLM_TOOL" "$MSG"
			fi
			if [ "${configflexlm[LOGGING]}" == "true" ]; then
				FLEXLM_LOG[MSG]=$MSG
				FLEXLM_LOG[FLAG]="info"
				__logging FLEXLM_LOG
			fi
			local LICENSE_ARGS="$LICENSE_PORT@$FLEXLM_HOST"
	        eval "$LMUTIL lmstat -a -c $LICENSE_ARGS"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "Done"
			else
				printf "$SEND" "$FLEXLM_TOOL" "Done"
			fi
	        return $SUCCESS
		fi 
		MSG="Missing external tool $LMUTIL"
		if [ "${configflexlm[LOGGING]}" == "true" ]; then
			FLEXLM_LOG[MSG]=$MSG
			FLEXLM_LOG[FLAG]="error"
			__logging FLEXLM_LOG
		fi
		if [ "${configflexlm[EMAILING]}" == "true" ]; then
			__sendmail "$MSG" "${configflexlm[ADMIN_EMAIL]}"
		fi
		return $NOT_SUCCESS
	fi
	__usage CHECKLIC_USAGE
	return $NOT_SUCCESS
}

#
# @brief  Starting license daemon
# @params Vlaues required path of license file and log file
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __startlic "$LIC_FILE" "$LOG_FILE"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __startlic() {
    local LIC_FILE=$1
    local LOG_FILE=$2
    if [ -n "$LIC_FILE" ] && [ -n "$LOG_FILE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local LMGRD="$FLEXLM_HOME/$FLEXLM_VERSION/$FLEXLM_ARCH/lmgrd"
        __checktool "$LMGRD"
        local STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            if [ -e "$LIC_FILE" ] && [ -f "$LIC_FILE" ]; then 
				MSG="Start license daemon [$LIC_FILE] [$LOG_FILE]"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
				else
					printf "$SEND" "$FLEXLM_TOOL" "$MSG"
				fi
				if [ "${configflexlm[LOGGING]}" == "true" ]; then
					FLEXLM_LOG[MSG]=$MSG
					FLEXLM_LOG[FLAG]="info"
					__logging FLEXLM_LOG
				fi
                eval "$LMGRD -c $LIC_FILE -l $LOG_FILE"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "Done"
				else
					printf "$SEND" "$FLEXLM_TOOL" "Done"
				fi
                return $SUCCESS
            fi
            MSG="Please check LM_LICENSE_FILE [$LIC_FILE]"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$FLEXLM_TOOL" "$MSG"
			fi
			if [ "${configflexlm[LOGGING]}" == "true" ]; then
				FLEXLM_LOG[MSG]=$MSG
				FLEXLM_LOG[FLAG]="error"
				__logging FLEXLM_LOG
			fi
			if [ "${configflexlm[EMAILING]}" == "true" ]; then
				__sendmail "$MSG" "${configflexlm[ADMIN_EMAIL]}"
			fi
        fi
		MSG="Missing external tool $LMGRD"
		if [ "${configflexlm[LOGGING]}" == "true" ]; then
			FLEXLM_LOG[MSG]=$MSG
			FLEXLM_LOG[FLAG]="error"
			__logging FLEXLM_LOG
		fi
		if [ "${configflexlm[EMAILING]}" == "true" ]; then
			__sendmail "$MSG" "${configflexlm[ADMIN_EMAIL]}"
		fi
        return $NOT_SUCCESS
    fi
    __usage STARTLIC_USAGE
    return $NOT_SUCCESS
}

#
# @brief  Stop license daemon 
# @param  Value required port number
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __stoplic "$LICENSE_PORT"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __stoplic() {
    local LICENSE_PORT=$1
    if [ -n "$LICENSE_PORT" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local LMUTIL="$FLEXLM_HOME/$FLEXLM_VERSION/$FLEXLM_ARCH/lmutil"
        __checktool "$LMUTIL"
        local STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
			local LICENSE_ARGS="$LICENSE_PORT@$FLEXLM_HOST"
			MSG="Stop license daemon [$LICENSE_PORT]"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$FLEXLM_TOOL" "$MSG"
			fi
			if [ "${configflexlm[LOGGING]}" == "true" ]; then
				FLEXLM_LOG[MSG]=$MSG
				FLEXLM_LOG[FLAG]="info"
				__logging FLEXLM_LOG
			fi
            eval "$LMUTIL lmdown -c $LICENSE_ARGS"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "Done"
			else
				printf "$SEND" "$FLEXLM_TOOL" "Done"
			fi
			if [ "${configflexlm[LOGGING]}" == "true" ]; then
				FLEXLM_LOG[MSG]=$MSG
				FLEXLM_LOG[FLAG]="info"
				__logging FLEXLM_LOG
			fi
            return $SUCCESS
        fi
		MSG="Missing external tool $LMUTIL"
		if [ "${configflexlm[LOGGING]}" == "true" ]; then
			FLEXLM_LOG[MSG]=$MSG
			FLEXLM_LOG[FLAG]="error"
			__logging FLEXLM_LOG
		fi
		if [ "${configflexlm[EMAILING]}" == "true" ]; then
			__sendmail "$MSG" "${configflexlm[ADMIN_EMAIL]}"
		fi
        return $NOT_SUCCESS
    fi 
	__usage STOPLIC_USAGE
	return $NOT_SUCCESS
}

#
# @brief   Main function 
# @params  Values required operation and vendor type of license
# @exitval Function __flexlm exit with integer value
# 			0   - success operation
#			128 - missing argument(s)
#			129 - missing configuration file
#			130 - error loading configuration
#			131 - wrong second argument
#			132 - wrong first argument
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __flexlm $OPERATION $LICENSE_PORT
#
function __flexlm() {
    local OPERATION=$1
    local VENDOR_LICENSE=$2
    if [ -n "$OPERATION" ] && [ -n "$VENDOR_LICENSE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="Loading basic and util configuration"
		printf "$SEND" "$OSSL_TOOL" "$MSG"
		__progressbar PB_STRUCTURE
		printf "%s\n\n" ""
		FLEXLM_HOST=$(hostname)
		FLEXLM_OP_LIST=( start stop restart status )
		declare -A configflexlm=()
		__loadconf $FLEXLM_CFG configflexlm
		local STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Failed to load tool script configuration"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$FLEXLM_TOOL" "$MSG"
			fi
			exit 129
		fi
		declare -A configflexlmutil=()
		__loadutilconf $FLEXLM_UTIL_CFG configflexlmutil
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Failed to load tool script utilities configuration"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$FLEXLM_TOOL" "$MSG"
			fi
			exit 130
		fi
		if [ $STATUS -eq $SUCCESS ]; then
			__loadlicenses "$configflexlmutil{FLEXLM_LIC_CONFIG}"
			STATUS=$?
			if [ $STATUS -eq $SUCCESS ]; then
				local LFILE="LICENSE_FILE_"
				local LPORT="LICENSE_PORT_"
				local LLOG="LICENSE_LOG_"
				if [ "$VENDOR_LICENSE" == "mentor" ]; then
					SUFIX=$(echo $VENDOR_LICENSE | awk '{print toupper($0)}')
					LFILE="LICENSE_FILE_${SUFIX}"
					LPORT="LICENSE_PORT_${SUFIX}"
					LLOG="LICENSE_LOG_${SUFIX}"
				elif [ "$VENDOR_LICENSE" == "cadence" ]; then
					SUFIX=$(echo $VENDOR_LICENSE | awk '{print toupper($0)}')
					LFILE="LICENSE_FILE_${SUFIX}"
					LPORT="LICENSE_PORT_${SUFIX}"
					LLOG="LICENSE_LOG_${SUFIX}"
				else
					MSG="Please check argument [$VENDOR_LICENSE]"
					if [ "$TOOL_DBG" == "true" ]; then
						printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
					else
						printf "$SEND" "$FLEXLM_TOOL" "$MSG"
					fi
					__usage FLEXLM_USAGE
					exit 132
				fi
				local LIC_FILE=$(__get_item "$LFILE" licenselist)
				local LIC_PORT=$(__get_item "$LPORT" licenselist)
				local LOG_FILE=$(__get_item "$LLOG" licenselist)
				__checkop "$OPERATION" "${FLEXLM_OP_LIST[*]}"
				STATUS=$?
				if [ $STATUS -eq $SUCCESS ]; then
					case "$OPERATION" in
						"start")
							__startlic "$LIC_FILE" "$LOG_FILE"
							;;
						"stop")
							__stoplic $LIC_PORT
							;;
						"restart")
							__stoplic $LIC_PORT
							sleep 2
							__startlic "$LIC_FILE" "$LOG_FILE"	
							;;
						"status")
							__checklic $LIC_PORT
							;;
					esac
					exit 0
				fi
				__usage FLEXLM_USAGE
				exit 133
			fi
			exit 130
		fi
		exit 131
    fi
	__usage FLEXLM_USAGE
	exit 128
}

#
# @brief   Main entry point
# @params  required values operation and vendor type of license
# @exitval Script tool flexlm exit with integer value
#			0   - tool finished with success operation 
# 			127 - run tool script as root user from cli
#			128 - missing argument(s) from cli 
#			129 - failed to load tool script configuration from file 
#			130 - failed to load configuration file with licenses 
#			131 - failed to load tool script utilities configuration from file
#			132 - wrong vendor argument
#			133 - wrong operation to be done
#
printf "\n%s\n%s\n\n" "$FLEXLM_TOOL $FLEXLM_VERSION" "`date`"
__checkroot
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
	__flexlm "$1" "$2"
fi

exit 127

