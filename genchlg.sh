#!/bin/bash
# @version 0.5.0
# This is an bash wrapper, to automatic create, commit, push, an
# CHANGELOG.md from your git repo commits.
#
# @Author: Maik Roland <iptoux> Damm
# GitHub: https://github.com/iptoux/bash_error_lib
#
# Source: https://github.com/lob/generate-changelog
#
# Please, feel free to report issues/bugs to github.
# You can also leave any suggestion to improve the script.
#
# @ToDo
#   * Adding Script autoupdate
#
#########################################################################

# To use this module, your commit messages have to be in this format:
# type(category): description [flags]
# -> breaking build ci chore docs feat fix other perf refactor 
# -> revert style test

# Where flags is an optional comma-separated list of one or more of 
# the following (must be surrounded in square brackets):

# -> breaking: alters type to be a breaking change

# And category can be anything of your choice. If you use a type not 
# found in the list (but it still follows the same format of the 
# message), it'll be grouped under other.


# Enable auto-push?
APUSH=false

# default command of the original github changelog tool. 
CMD="changelog"


################DONT################EDIT################HERE################

# Declare neded global vars
declare -g mk="[->] "
declare -g chtype

# clear chtype to clear variable on rerun.
unset chtype

# Function to check for needed depencies.
chlg_check() {

    if command -v npm &> /dev/null; then
        return 0
    else
        echo -e "\nERROR:"
        echo -e "\n-> The command npm is not found, please check or install it via:\n"
        echo -e "\n-> sudo apt install npm\t\t\t# Debian"
        echo -e "-> sudo pacman -S npm\t\t\t# Arch linux\n"
        printf '%.s─' $(seq 1 "$(($(tput cols)/2))")
        printf '\n'
        echo "-> cd in your git repo"
        echo "-> run: test -f package.json || echo '{}' >package.json"
        echo ""
        exit 1
    fi

    # shellcheck disable=SC2317
    if command -v "${CMD}" -h &> /dev/null; then
        return 0
    else
        printf "\nERROR:"
        printf "\n-> The command %s (via npm) is not found, please check or install it via:\n" "${CMD}"
        printf "\n-> npm i generate-changelog -D\t\t# install it as a dev dependency\n"
        echo -e "-> sudo npm i generate-changelog -g\t# install it globaly\n"
        exit 1
    fi
    
}

# Fuction -> Fallback if Auto-push is of (control for user)
chlg_push() {


    if [ ${APUSH} == false ]; then

        echo "${mk}Auto-push disabled. You can enable it by setting $APUSH (true) in head of this file."
        
        read -r -p "${mk}Push it to git? (y/n): " IN

            case ${IN} in
                y|Y)    
                    echo -n "${mk}Select y/Y -> pushing to git: "
                    git push origin
                    git push origin --tags
                    echo "done."
                    ;;
                n|N) echo "${mk}Select n/N -> skipping...." ;;
                *) echo "select default (n)" ;;
            esac

    else
        chlg_push_auto
    fi
        
    return
}

# Function to automatic push after commit
chlg_push_auto() {

    echo -n "${mk}[Auto-push] Pushing to git: "
    git push origin
    git push origin --tags
    echo "done."
}

# Function to commit by type/mode
chlg_commit() {

    echo -n "${mk}Commiting CHANGELOG.md: " 
    
        git add CHANGELOG.md
        git commit -m "docs: updated CHANGELOG.md ['${chtype}',version]"
    
    echo "done."
    echo -n "${mk}StepUp version/set tags on repo: "
    
        npm version "${chtype}"
    
    echo -e "done."
    return
}

# Function to ask user if he is shure.
chlg_shure() {

    read -r -p "${mk}Shure? (y/n): " IN

        case ${IN} in
            y|Y) echo true ;;
            n|N) echo false ;;
            *) echo false ;;
        esac
}

# Function that combines all steps, needed to generate 
# the Major CHANGELOG.md
chlg_major() {

    if [ "$(chlg_shure)" == false ]; then
        echo "Select n/N -> (exit)"
        return
    fi

    chtype="major"

    printf '\nGenerate/Update an Major (+.x.x) CHANGELOG.md in your repository.\n'
    printf '%.s─' $(seq 1 "$(($(tput cols)/2))")
    printf '\n'

    # -> generate changelog
    # -> adding to git & commit
    # -> update version by type (major/minor/patch)
    echo -n "${mk}Generate CHANGELOG.md: "
    changelog -M
    echo "done."
    
    chlg_commit

    chlg_push

    echo -e "\nFinish, all steps done!\n"

    exit 0
}

# Function that combines all steps, needed to generate 
# the minor CHANGELOG.md
chlg_minor() {
    
    if [ "$(chlg_shure)" == false ]; then
        echo "Select n/N -> (exit)"
        exit 0
    fi

    chtype="minor"

    printf '\nGenerate/Update an Minor (x.+.x) CHANGELOG.md in your repository.\n'
    printf '%.s─' $(seq 1 "$(($(tput cols)/2))")
    printf '\n'

    # -> generate changelog
    # -> adding to git & commit
    # -> update version by type (major/minor/patch)
    echo -n "${mk}Generate CHANGELOG.md: "
    changelog -m
    echo "done."
    
    chlg_commit

    chlg_push

    echo -e "\nFinish, all steps done!\n"

    exit 0
}

# Function that combines all steps, needed to generate 
# the patch CHANGELOG.md
chlg_patch() {

    if [ "$(chlg_shure)" == false ]; then
        echo "Select n/N -> (exit)"
        exit 0
    fi

    chtype="patch"

    printf '\nGenerate/Update an Patch (x.x.+) CHANGELOG.md in your repository.\n'
    printf '%.s─' $(seq 1 "$(($(tput cols)/2))")
    printf '\n'

    # -> generate changelog
    # -> adding to git & commit
    # -> update version by type (major/minor/patch)
    echo -n "${mk}Generate CHANGELOG.md: "
    changelog -p
    echo "done."
    
    chlg_commit

    chlg_push

    echo -e "\nFinish, all steps done!\n"

    exit 0
}

# Main function (like in c)
genchlg() {

    echo "CHANGELOG.md gen."
    printf '%.s─' $(seq 1 "$(($(tput cols)/2))")

    echo -ne "\n${mk}Checking depencies: "
    chlg_check
    echo "done."

    echo "${mk}CHANGELOG.md - Type/Mode?"
    echo "${mk}[1:Major (+.x.x)] // [2:Minor (x.+.x)] // [3:Patch (x.x.+)]"

    prompt="${mk}Select: "

    read -rp "${prompt}" MODE

        case ${MODE} in
            1) chlg_major "${MODE}";;
            2) chlg_minor "${MODE}";;
            3) chlg_patch "${MODE}";;
            *) echo "${mk}Invalid option. Try another one.";;
        esac
}

genchlg