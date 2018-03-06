#!/bin/bash
# @author: Dante Bazaldua
# @date: March, 2018
# @brief: Program that make a screen report to check how much
# time a user spent logged based on a binnacle.

user=''
filename=''
version=0.1
OPTS=0
HOURS=0
MINUTES=0
SECONDS=0

# checkTime: Get the last column of the file and create the calculations.
# This function is individual.
# @param  file  The file to read
# @param  user  User to find
checkTime () {
  file=$2
  user=$1
  # check whether if the string has 'still logged in'
  FFILTER=$(cat $file | grep -v 'still' | grep $user )
  SFILTER=$(echo "$FFILTER" | awk '{print $NF}' | cut -d'(' -f2 | cut -d')' -f1 )
  if grep -q '+' <<< "$SFILTER"; then
    HOURS=$(echo "$SFILTER" | grep '+' | cut -f 1 -d '+')
  else
    HOURS=0
  fi
  MINUTES=$(echo "$SFILTER" | cut -f 2 -d '+' | awk '{sum+=$1} END {print sum}')
  SECONDS=$(echo "$SFILTER" | cut -f 2 -d ':' | awk '{sum+=$1} END {print sum}')
  if [[ "$HOURS" == "0" && "$MINUTES" == "0" && "$SECONDS" == "0" ]]; then
    TSECS=0
  else
    TSECS=$(echo "($HOURS*60*60) + ($MINUTES*60) + ($SECONDS)" | bc)
  fi
  HOURS=0
  MINUTES=0
  SECONDS=0
}

# makeReport: This function calculate time in human conventions.
# Print in screen the result. Individual.
# @param  file  The file to read
# @param  user  User to find
# @param  TSECS Total of seconds of the user
makeReport () {
  file="$2"
  user="$1"
  TSECS="$3"
  HOURS=$(echo "($TSECS/(60*60)) / 1" | bc)
  MINUTES=$(echo "(($TSECS - ($HOURS*(60*60)))/(60)) / 1" | bc)
  SECONDS=$(echo "($TSECS - ($HOURS*(60*60)) - ($MINUTES*60)) / 1" | bc)
  printf "%10s \t| %2s:%2s:%2s\n" "$user" "$HOURS" "$MINUTES" "$SECONDS"
}

footReport () {
  printf "\n* Este resultado puede variar pues se ignoran los datos cuando aún sigue activo.\n"
}

show_opts () {
  while getopts "u:f:vh" optname
    do
      case "$optname" in
        "u")
          if [[ -n "$OPTARG" ]]; then
            user=$OPTARG
            OPTS=$(( OPTS + 1 ))
          else
            echo "Error: bad argument $OPTARG"
            echo "Check $0 -h for more information."
            exit 0
          fi
          ;;
        "f")
          if [[ -n "$OPTARG" ]]; then
            filename=$OPTARG
            OPTS=$(( OPTS+1 ))
            # No mode specified
            printf "Reporte de sesiones.\nArchivo: $filename\n\n"
            if [[ 1 -eq "$OPTS" ]]; then
              printf "%10s \t|  %6s\n" "USUARIO" "TIEMPO"
              ALL=$( cat $filename | cut -f1 -d' ' | sort | uniq | grep . | grep -v wtmp )
              for WORD in $ALL
              do
              	if [[ $WORD =~ $'\r' ]]; then
              		printf ""
              	else
                  checkTime "$WORD" "$filename"
              		makeReport "$WORD" "$filename" $TSECS
              	fi
              done
              footReport
              exit 0
            # Verify if two arguments, username and filename
            elif [[ 2 -eq "$OPTS" ]]; then
              printf "%10s \t|  %6s\n" "USUARIO" "TIEMPO"
              checkTime "$user" "$filename"
              makeReport "$user" "$filename" $TSECS
              footReport
              exit 0
            else
              printf "Bad usage: \n"
              printf "Check $0 -h for more information. \n"
              exit 0
            fi

            # function goes here
          else
            echo "Error: bad argument $OPTARG. Is necessay a file to check."
            echo "Check $0 -h for more information."
            exit 0
          fi
          # function goes here
          exit 0
          ;;
        "v")
          show_version
          exit 0
          ;;
        "h")
          help
          exit 0
          ;;
        "?")
          echo "Unknown option $OPTARG"
          echo "Check $0 -h for more information."
          ;;
        ":")
          echo "No argument value for option $OPTARG"
          ;;
        *)
          echo "Unknown error while processing options"
          ;;
      esac
    done
  return $OPTIND
}

show_version () {
  echo "$0 $version"
}

help () {
  printf "$0: CLI utility to search for time user-machine \
in a binnacle.\n"
  printf "usage: $0 [-u <username>] [-f <filename>] [-v] [-h]\n"
  printf "\t\t     -u: username <username> NO MANDATORY\n"
  printf "\t\t     -f: filename MANDATORY\n"
  printf "\t\t     -v: version\n"
  printf "\t\t     -h: help\n"
  printf "\t\t     <command> <opts> <args>\n"
}

if [[ -z "$@" ]]; then
  # Defult Mode
  printf "Bad usage: \n"
  printf "Check $0 -h for more information. \n"
  exit 0
fi

optinfo=$(show_opts "$@")
echo "$optinfo"
