#!/bin/bash

# bash_optionmaker, Copyright 2013 Vicente Oscar Mier Vela
#    This file is part of bash_optionmaker.
#
#    bash_optionmaker is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    bash_optionmaker is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with bash_optionmaker.  If not, see <http://www.gnu.org/licenses/>.

#		Remember:	Append Defaults to SEC_3
#				Insert booles to SEC_4_6
#				Insert args to SEC_4_8

#	1.a. Unrecognized option error message
SEC_1_a_FNAME='function unrecognized() {'
SEC_1_a='
	FNAME=${1}
	OPTION=${2}
	{
	printf "%s: unrecognized option '"'"'%s'"'"'\nTry %s --help for more information.\n" "${FNAME}" "${OPTION}" "${FNAME}"
	} 1>&2
}
'
#	1.b. Invalid option argument error message
SEC_1_b_FNAME='function invalid() {'
SEC_1_b='
	FNAME=${1}
	OPTION=${2}
	ARGUMENT=${3}
	{
	printf "%s: invalid %s argument %s'"'"'\n" "${FNAME}" "${OPTION}" "${ARGUMENT}"
	} 1>&2
}
'
#	2. Help message function
SEC_2_FNAME='function help_msg() {'
SEC_2='
	:
}
'
#	Function start
SEC_FUNC_a='function my_func() {
'
#	3. Default values
SEC_3='VERBOSE='"'"'false'"'"'
'
#	4.a. Case inside while loop beginning
SEC_4_a='while test ${#} -gt 0 ; do
	OPT=${1}
	shift
	case "${OPT}" in
'
#	4.1. Boolean selection
SEC_4_1=''
#	4.2. Argument selection
SEC_4_2=''
#	4.3. List selection
SEC_4_3=''
#	4.4. Verbose boolean
SEC_4_4='	-v|--verbose)
			VERBOSE=:
	;;'
#	4.5. Help message and exit
SEC_4_5='	-h|--help)
			help_msg
			return 0
	;;'
#	4.6. Separable booleans
#	Assume SEC_4_6 is incomplete
#	Insert strings, and finish with a tab
SEC_4_6='-h*|-v*)
'
#	4.7. Boolean separator
SEC_4_7='			REST="`printf '"'"'%s'"'"' \"${OPT}\" | sed '"'"'s/^..//'"'"'`"
			OPT="`printf '"'"'%s'"'"' \"${OPT}\" | sed '"'"'s/^\(..\).*/\1/'"'"'`"
			set dummy "${OPT}" '"'"'-'"'"'"${REST}" ${1+"${@}"}
			shift
	;;'
#	4.8. Separable args
#	SEC_4_8 is incomplete
#	Insert strings, and finish with a tab
SEC_4_8=')
'
#	4.9. Argument separator
SEC_4_9='			ARG="`printf '"'"'%s'"'"' \"${OPT}\" | sed '"'"'s/^..//'"'"'`"
			OPT="`printf '"'"'%s'"'"' \"${OPT}\" | sed '"'"'s/^\(..\).*/\1/'"'"'`"
			set dummy "${OPT}" "${ARG}" ${1+"${@}"}
			shift
	;;'
#	4.10. -- breaker
SEC_4_10='	--)
			break
	;;'
#	4.11. Unrecognized option
SEC_4_11='	-*)
			unrecognized "${FUNCNAME}" "${OPT}"
			return 1
	;;'
#	4.12. *) Ender
SEC_4_12='	*)
			set dummy "${OPT}" ${1+"${@}"}
			shift
			break
	;;'
#	4.b. Case inside while loop ending
SEC_4_b='
	esac
done
'
#	Function end
SEC_FUNC_b='}'

while read LINE ; do
	ATTRIB=`echo ${LINE} | sed 's/^\([^:][^:]*\):.*$/\1/'`
	VALUE=`echo ${LINE} | sed 's/^[^:][^:]*://'`
	if test "${ATTRIB}" = 'arg' ; then
		SHORT='-a'
		LONG='--arg'
		LONGUPPER='ARG'
		DEFAULT='0'
		INVALID=''
		while read LINE ; do
			ATTRIB=`echo ${LINE} | sed 's/^\([^:][^:]*\):.*$/\1/'`
			VALUE=`echo ${LINE} | sed 's/^[^:][^:]*://'`
			if test "${ATTRIB}" = 'end' ; then
				break
			fi
			case "${ATTRIB}" in
				default)
					DEFAULT="${VALUE}"
			;;	short)
					SHORT='-'"${VALUE}"
			;;	long)
					LONG='--'"${VALUE}"
					LONGUPPER="`echo \"${VALUE}\" | tr [a-z] [A-Z]`"
			;;	invalid)
					INVALID="${INVALID}"'			if '"${VALUE}"' ; then
				invalid "${FUNCNAME}" "${OPT}" "${1}"
				return 2
			fi
'
			;;
			esac
		done
		SEC_4_2="${SEC_4_2}"'	'"${SHORT}"'|'"${LONG}"')
'"${INVALID}"'			'"${LONGUPPER}"'=${1}
			shift
	;;'
		SEC_3="${SEC_3}${LONGUPPER}"'='"${DEFAULT}"'
'
		if test "${SEC_4_8}" = ')
'
		then
			SEC_4_8="${SHORT}"'*'"${SEC_4_8}"
		else
			SEC_4_8="${SHORT}"'*|'"${SEC_4_8}"
		fi
	fi
	if test "${ATTRIB}" = 'boole' ; then
		DEFAULT='false'
		SHORT='b'
		LONG='boole'
		while read LINE ; do
			ATTRIB=`echo ${LINE} | sed 's/^\([^:][^:]*\):.*$/\1/'`
			VALUE=`echo ${LINE} | sed 's/^[^:][^:]*://'`
			if test "${ATTRIB}" = 'end' ; then
				break
			fi
			case "${ATTRIB}" in
				default)
					DEFAULT="${VALUE}"
					if test "${DEFAULT}" = ':' ; then
						TOGGLE="'"'false'"'"
					else
						TOGGLE=':'
					fi
			;;	short)
					SHORT='-'"${VALUE}"
			;;	long)
					LONG='--'"${VALUE}"
					LONGUPPER="`echo \"${VALUE}\" | tr [a-z] [A-Z]`"
			;;
			esac
		done
		SEC_4_1="${SEC_4_1}"'	'"${SHORT}"'|'"${LONG}"')
			'"${LONGUPPER}"'='"${TOGGLE}"'
	;;'
		SEC_3="${SEC_3}${LONGUPPER}"'='"${DEFAULT}"'
'
		SEC_4_6="${SHORT}"'*|'"${SEC_4_6}"
	fi
	if test "${ATTRIB}" = 'list' ; then
		SHORT='l'
		LONG='list'
		INVALID=''
		while read LINE ; do
			ATTRIB=`echo ${LINE} | sed 's/^\([^:][^:]*\):.*$/\1/'`
			VALUE=`echo ${LINE} | sed 's/^[^:][^:]*://'`
			if test "${ATTRIB}" = 'end' ; then
				break
			fi
			case "${ATTRIB}" in
				short)
					SHORT='-'"${VALUE}"
			;;	long)
					LONG='--'"${VALUE}"
					LONGUPPER="`echo \"${VALUE}\" | tr [a-z] [A-Z]`"'S'
			;;	invalid)
					INVALID="${INVALID}"'			if '"${VALUE}"' ; then
				invalid "${FUNCNAME}" "${OPT}" "${1}"
				return 2
			fi
'
			;;
			esac
		done
		SEC_4_3="${SEC_4_3}"'	'"${SHORT}"'|'"${LONG}"')
'"${INVALID}"'			'"${LONGUPPER}"'=${'"${LONGUPPER}"'+${'"${LONGUPPER}"'}:}${1}
			shift
	;;'
	fi
	if test "${ATTRIB}" = 'help' ; then
		SEC_2='
	printf '"'"'%s'"'"' '"'"
		while read LINE ; do
			ATTRIB=`echo ${LINE} | sed 's/^\([^:][^:]*\):.*$/\1/'`
			if test "${ATTRIB}" = 'end' ; then
				break
			fi
			SEC_2="${SEC_2}${LINE}
"
		done
		SEC_2="${SEC_2}'"'
}
'
	fi
	if test "${ATTRIB}" = 'fname' ; then
		read LINE
		SEC_FUNC_a='function '"${LINE}"'() {
'
		SEC_1_a_FNAME='function unrecognized_'"${LINE}"'() {'
		SEC_1_b_FNAME='function invalid_'"${LINE}"'() {'
		SEC_2_FNAME='function help_msg_'"${LINE}"'() {'
		SEC_4_2=`echo "${SEC_4_2}" | sed 's/^[\t][\t]*invalid/&_'"${LINE}"'/g'`
		SEC_4_3=`echo "${SEC_4_3}" | sed 's/^[\t][\t]*invalid/&_'"${LINE}"'/g'`
		SEC_4_5='	-h|--help)
					help_msg_'"${LINE}"'
					return 0
			;;'
		SEC_4_11='	-*)
					unrecognized_'"${LINE}"' "${FUNCNAME}" "${OPT}"
					return 1
			;;'
	fi
done

printf '%s' "${SEC_1_a_FNAME}"
printf '%s' "${SEC_1_a}"
echo
printf '%s' "${SEC_1_b_FNAME}"
printf '%s' "${SEC_1_b}"
echo
printf '%s' "${SEC_2_FNAME}"
printf '%s' "${SEC_2}"
echo
printf '%s' "${SEC_FUNC_a}"
{
printf '%s' "${SEC_3}"
printf '%s' "${SEC_4_a}"
printf '	%s' "${SEC_4_1}"
printf '%s' "${SEC_4_2}"
printf '%s' "${SEC_4_3}"
printf '%s' "${SEC_4_4}"
printf '%s' "${SEC_4_5}"
printf '	%s' "${SEC_4_6}"
printf '%s' "${SEC_4_7}"
if test "${SEC_4_8}" != ')
' ; then
	printf '	%s' "${SEC_4_8}"
	printf '%s' "${SEC_4_9}"
fi
printf '%s' "${SEC_4_10}"
printf '%s' "${SEC_4_11}"
printf '%s' "${SEC_4_12}"
printf '%s' "${SEC_4_b}"
} | sed 's/^/	/'
printf '%s' "${SEC_FUNC_b}"
echo
