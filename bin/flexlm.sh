#!/bin/bash
#
# @brief   Licenses Server Management
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
. $UTIL/bin/checkcfg.sh
. $UTIL/bin/checkop.sh
. $UTIL/bin/hash.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

TOOL_NAME=flexlm
TOOL_VERSION=ver.1.0
TOOL_HOME=$UTIL_ROOT/$TOOL_NAME/$TOOL_VERSION
TOOL_CFG=$TOOL_HOME/conf/$TOOL_NAME.cfg
TOOL_LOG=$TOOL_HOME/log

declare -A FLEXLM_USAGE=(
	[TOOL_NAME]="__$TOOL_NAME"
	[ARG1]="[COMMAND]     start | stop | restart | status"
	[ARG2]="[VENDOR_NAME] cadence | mentor"
	[EX-PRE]="# Start license server"
	[EX]="__$TOOL_NAME start mentor"	
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

declare -A LOG=(
	[TOOL]="$TOOL_NAME"
	[FLAG]="info"
	[PATH]="$TOOL_LOG"
	[MSG]=""
)

TOOL_DEBUG="false"

FLEXLM_HOME=/opt/flexlm
FLEXLM_VERSION=ver.11.12.1
FLEXLM_ARCH=x86_64
FLEXLM_HOST=$(hostname)
FLEXLM_LIC_CONFIG="$TOOL_HOME/conf/licenses.cfg"
declare -A configurations=()
FLEXLM_OP_LIST=( start stop restart status )

#
# @brief  Load licenses parameters from configuration file
# @param  Valie required path of configuration file
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __loadlicenses "$CONFIGURATION_FILE"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __loadlicenses() {
	CONFIGURATION_FILE=$1
	if [ -n "$CONFIGURATION_FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[flexlm load configuration file]"
		fi
		__checkcfg "$CONFIGURATION_FILE"
		STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "Loading configuration"
			fi
			__get_configuration "$CONFIGURATION_FILE" configurations
			STATUS=$?
			if [ "$STATUS" -eq "$SUCCESS" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n\n" "[Done]"
				fi
				return $SUCCESS
			fi
		fi
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "Check file [$TOOL_CFG]"
			printf "%s\n\n" "[Done]"
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
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __checklic() {
    LICENSE_PORT=$1
	if [ -n "$LICENSE_PORT" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Checking license]"
		fi
		LMUTIL="$FLEXLM_HOME/$FLEXLM_VERSION/$FLEXLM_ARCH/lmutil"
		__checktool "$LMUTIL"
		STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "Check license on port [$LICENSE_PORT]"
			fi
			LICENSE_ARGS="$LICENSE_PORT@$FLEXLM_HOST"
	        eval "$LMUTIL lmstat -a -c $LICENSE_ARGS"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "CMD: $LMUTIL lmstat -a -c $LICENSE_ARGS"
				printf "%s\n\n" "[Done]"
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
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __startlic() {
    LIC_FILE=$1
    LOG_FILE=$2
    if [ -n "$LIC_FILE" ] && [ -n "$LOG_FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Start license daemon]"
		fi
		LMGRD="$FLEXLM_HOME/$FLEXLM_VERSION/$FLEXLM_ARCH/lmgrd"
        __checktool "$LMGRD"
        STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
            if [ -e "$LIC_FILE" ] && [ -f "$LIC_FILE" ]; then 
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n" "Starting license daemon"
				fi
                eval "$LMGRD -c $LIC_FILE -l $LOG_FILE"
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n" "CMD: $LMGRD -c $LIC_FILE -l $LOG_FILE"
					printf "%s\n\n" "[Done]"
				fi
                return $SUCCESS
            fi
            printf "%s\n\n" "Check LM_LICENSE_FILE [$LIC_FILE]"
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
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __stoplic() {
    LICENSE_PORT=$1
    if [ -n "$LICENSE_PORT" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Stop license daemon]"
		fi
		LMUTIL="$FLEXLM_HOME/$FLEXLM_VERSION/$FLEXLM_ARCH/lmutil"
        __checktool "$LMUTIL"
        STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "Stopping license daemon on port [$LICENSE_PORT]"
			fi
			LICENSE_ARGS="$LICENSE_PORT@$FLEXLM_HOST"
            eval "$LMUTIL lmdown -c $LICENSE_ARGS"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "CMD: $LMUTIL lmdown -c $LICENSE_ARGS"
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        return $NOT_SUCCESS
    fi 
	__usage $STOPLIC_USAGE
	return $NOT_SUCCESS
}

#
# @brief  Main function 
# @params Values required operation and vendor type of license
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __flexlm $OPERATION $LICENSE_PORT
#
function __flexlm() {
    OPERATION=$1
    VENDOR_LICENSE=$2
    if [ -n "$OPERATION" ] && [ -n "$VENDOR_LICENSE" ]; then
		__checkcfg "$FLEXLM_LIC_CONFIG"
		STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			__loadlicenses "$FLEXLM_LIC_CONFIG"
			STATUS=$?
			if [ "$STATUS" -eq "$SUCCESS" ]; then
				LFILE="LICENSE_FILE_"
				LPORT="LICENSE_PORT_"
				LLOG="LICENSE_LOG_"
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
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "%s\n\n" "Check argument [$VENDOR_LICENSE]"
					fi
					__usage $FLEXLM_USAGE
					exit 131
				fi
				LIC_FILE=$(__get_item "$LFILE" configurations)
				LIC_PORT=$(__get_item "$LPORT" configurations)
				LOG_FILE=$(__get_item "$LLOG" configurations)
				__checkop "$OPERATION" "${FLEXLM_OP_LIST[*]}"
				STATUS=$?
				if [ "$STATUS" -eq "$SUCCESS" ]; then
					case "$OPERATION" in
						"start") 	
							if [ "$TOOL_DEBUG" == "true" ]; then
								printf "%s\n" "Starting $VENDOR_LICENSE license"
							fi	
							__startlic "$LIC_FILE" "$LOG_FILE"
							if [ "$TOOL_DEBUG" == "true" ]; then
								printf "%s\n\n" "[Done]"
							fi
							;;
						"stop")	  
							if [ "$TOOL_DEBUG" == "true" ]; then
								printf "%s\n" "Stoping $VENDOR_LICENSE license"
							fi
							__stoplic $LIC_PORT
							if [ "$TOOL_DEBUG" == "true" ]; then
								printf "%s\n\n" "[Done]"
							fi
							;;
						"restart")
							if [ "$TOOL_DEBUG" == "true" ]; then
								printf "%s\n\n" "Restart $VENDOR_LICENSE license"
							fi
							__stoplic $LIC_PORT
							sleep 2
							__startlic "$LIC_FILE" "$LOG_FILE"
							if [ "$TOOL_DEBUG" == "true" ]; then
								printf "%s\n\n" "[Done]"
							fi	
							;;
						"status")	
							if [ "$TOOL_DEBUG" == "true" ]; then
								printf "%s\n" "Checking $VENDOR_LICENSE license"
							fi
							__checklic $LIC_PORT
							if [ "$TOOL_DEBUG" == "true" ]; then
								printf "%s\n\n" "[Done]"
							fi
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
printf "\n%s\n%s\n\n" "$TOOL_NAME $TOOL_VERSION" "`date`"
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
	__flexlm "$1" "$2"
fi

exit 127

