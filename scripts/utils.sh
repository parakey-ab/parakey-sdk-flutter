#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
GREY='\033[0;90m'
RESET='\033[0m'

echo_green() {
  echo -e "${GREEN}$1${RESET}"
}

echo_grey() {
  echo -e "${GREY}$1${RESET}"
}

echo_yellow() {
  echo -e "${YELLOW}$1${RESET}"
}

prompt_enter_to_continue() {
  local message=${1:-"Enter to continue"}
  local colored_message
  colored_message="$(printf '%b' "${CYAN}${message}${RESET}")"
  read -r -p "${colored_message}"
  echo -e "\n"
}

validate_semver() {
  if ! [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid format"
    exit 1
  fi
}

read_flutter_version() {
  read -p "Enter flutter version (x.y.z): " flutter_version
  validate_semver $flutter_version;
}

read_android_version() {
  read -p "Enter android version (x.y.z): " android_version
  validate_semver "$android_version"
}

read_ios_version() {
  read -p "Enter iOS version (x.y.z): " ios_version
  validate_semver "$ios_version"
}
