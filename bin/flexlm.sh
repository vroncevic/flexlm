#!/bin/bash
#
# @brief   Licenses Server Manager
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
# 
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/checkop.sh
. $UTIL/bin/hash.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

FLEXLM_TOOL=flexlm
FLEXLM_VERSION=ver.1.0
FLEXLM_HOME=$UTIL_ROOT/$FLEXLM_TOOL/$FLEXLM_VERSION
FLEXLM_CFG=$FLEXLM_HOME/conf/$FLEXLM_TOOL.cfg
FLEXLM_LOG=$FLEXLM_HOME/log

declare -A FLEXLM_USAGE=(
	[TOOL_NAME]="__$FLEXLM_TOOL"
	[ARG1]="[COMMAND]     start | stop | restart | status"
	[ARG2]="[VENDOR_NAME] cadence | mentor"
	[EX-PRE]="# Start license server"
	[EX]="__$FLEXLM_TOOL start mentor"
)

declare -A CHECKLIC_USAGE=(
	[TOOL_NAME]="__checklic"
	[ARG1]="[PORT_NUMBER] Port number for license"
	[EX-PRE]="# Check license on port 5280"
	[EX]="__checklic 5280"
)

declare -A STOPLIC_USAGE=(
	[TOOL_NAME]="__stoplic"
	[ARG1]="[PORT_NUMBER] Port number for license"
	[EX-PRE]="# Stop license deamon with port number 5280"
	[EX]="__stoplic 5280"
)

declare -A STARTLIC_USAGE=(
	[TOOL_NAME]="__startlic"
	[ARG1]="[LICENSE_FILE] License file path"
	[ARG2]="[LOG_FILE]     Log file path"
	[EX-PRE]="# Start license deamon"
	[EX]="__startlic \$LICENSE_FILE \$LOG_FILE"
)

TOOL_DBG="false"

FLEXLM_HOME=/data/apps/flexlm
FLEXLM_VERSION=ver.11.12.1
FLEXLM_ARCH=x86_64
FLEXLM_HOST=$(hostname)
FLEXLM_LIC_CONFIG="$FLEXLM_HOME/conf/licenses.cfg"
declare -A cfgflelm=()
FLEXLM_OP_LIST=( start stop restart status )

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
function __loadlicenses() {
	local CONFIGURATION_FILE=$1
	if [ -n "$CONFIGURATION_FILE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Loading config file [$CONFIGURATION_FILE]"
			printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
		fi
		__loadutilconf "$CONFIGURATION_FILE" cfgflelm
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$FLEXLM_TOOL" "$FUNC" "Done"
			fi
			return $SUCCESS
		fi
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
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking license [$LICENSE_PORT]"
			printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
		fi
		local LMUTIL="$FLEXLM_HOME/$FLEXLM_VERSION/$FLEXLM_ARCH/lmutil"
		__checktool "$LMUTIL"
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			local LICENSE_ARGS="$LICENSE_PORT@$FLEXLM_HOST"
	        eval "$LMUTIL lmstat -a -c $LICENSE_ARGS"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$FLEXLM_TOOL" "$FUNC" "Done"
			fi
	        return $SUCCESS
		fi 
		return $NOT_SUCCESS
	fi
	__usage $CHECKLIC_USAGE
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
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Start license daemon [$LIC_FILE] [$LOG_FILE]"
			printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
		fi
		local LMGRD="$FLEXLM_HOME/$FLEXLM_VERSION/$FLEXLM_ARCH/lmgrd"
        __checktool "$LMGRD"
        local STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
            if [ -e "$LIC_FILE" ] && [ -f "$LIC_FILE" ]; then 
                eval "$LMGRD -c $LIC_FILE -l $LOG_FILE"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$FLEXLM_TOOL" "$FUNC" "Done"
				fi
                return $SUCCESS
            fi
            MSG="Check LM_LICENSE_FILE [$LIC_FILE]"
			printf "$SEND" "$FLEXLM_TOOL" "$MSG"
        fi
        return $NOT_SUCCESS
    fi
    __usage $STARTLIC_USAGE
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
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Stop license daemon [$LICENSE_PORT]"
			printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
		fi
		local LMUTIL="$FLEXLM_HOME/$FLEXLM_VERSION/$FLEXLM_ARCH/lmutil"
        __checktool "$LMUTIL"
        local STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
			local LICENSE_ARGS="$LICENSE_PORT@$FLEXLM_HOST"
            eval "$LMUTIL lmdown -c $LICENSE_ARGS"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$FLEXLM_TOOL" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
        return $NOT_SUCCESS
    fi 
	__usage $STOPLIC_USAGE
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
		local MSG=""
		__checkcfg "$FLEXLM_LIC_CONFIG"
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			__loadlicenses "$FLEXLM_LIC_CONFIG"
			STATUS=$?
			if [ "$STATUS" -eq "$SUCCESS" ]; then
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
					if [ "$TOOL_DBG" == "true" ]; then
						MSG="Check argument [$VENDOR_LICENSE]"
						printf "$DSTA" "$FLEXLM_TOOL" "$FUNC" "$MSG"
					fi
					__usage $FLEXLM_USAGE
					exit 131
				fi
				local LIC_FILE=$(__get_item "$LFILE" cfgflelm)
				local LIC_PORT=$(__get_item "$LPORT" cfgflelm)
				local LOG_FILE=$(__get_item "$LLOG" cfgflelm)
				__checkop "$OPERATION" "${FLEXLM_OP_LIST[*]}"
				STATUS=$?
				if [ "$STATUS" -eq "$SUCCESS" ]; then
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
				__usage $FLEXLM_USAGE
				exit 132
			fi
			exit 130
		fi
		exit 129
    fi
	__usage $FLEXLM_USAGE
	exit 128
}

#
# @brief   Main entry point
# @params  required values operation and vendor type of license
# @exitval Script tool flexlm exit with integer value
#			0   - success operation 
# 			127 - run as root user
#			128 - missing argument
#			129 - missing configuration file
#			130 - error loading configuration
#			131 - wrong second argument
#			132 - wrong first argument
#
printf "\n%s\n%s\n\n" "$FLEXLM_TOOL $FLEXLM_VERSION" "`date`"
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
	__flexlm "$1" "$2"
fi

exit 127
