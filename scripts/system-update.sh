#!/usr/bin/env bash

set -e

# Compatible color palette
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
PURPLE='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'
# GRAY='\033[90m'
GRAY='\033[37m'
LIGHT_BLUE='\033[94m'
LIGHT_GREEN='\033[92m'
LIGHT_RED='\033[91m'
LIGHT_YELLOW='\033[93m'
ORANGE='\033[38;5;214m'
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
RESET='\033[0m'

# Enhanced symbols and emojis
CHECKMARK="✓"
CROSS="✗"
ARROW="→"
DOUBLE_ARROW="⇒"
CLOCK="⏱"
GEAR="⚙"
ROCKET="🚀"
WARNING="⚠"
ROLLBACK="↺"
DEBUG="🔍"
SPARKLES="✨"
FIRE="🔥"
LIGHTNING="⚡"
PACKAGE="📦"
WRENCH="🔧"
SHIELD="🛡"
HOURGLASS="⏳"
TARGET="🎯"
MAGNIFY="🔎"
STAR="⭐"
DIAMOND="💎"
RAINBOW="🌈"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="/home/salledelavage/.nixos-update-state"
LOGFILE="$STATE_DIR/update-$(date +%Y%m%d-%H%M%S).log"
ROLLBACK_INFO="$STATE_DIR/rollback-info.json"
LAST_HASHES="$STATE_DIR/last-hashes.json"

mkdir -p "$STATE_DIR"

# Progress tracking
TOTAL_STEPS=0
CURRENT_STEP=0

animate_loading() {
    local text="$1"
    local delay=0.1
    local spinstr='|/-\'
    local temp
    
    printf "${BOLD}${CYAN}%s " "$text"
    for i in {1..10}; do
        temp=${spinstr#?}
        printf "\b%c" "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\b${LIGHT_GREEN}${CHECKMARK}${RESET}\n"
}

print_animated_banner() {
    clear
    echo
    
    # ASCII art lines that appear one by one
    local lines=(
        "${BOLD}${LIGHT_BLUE}    ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗    ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗██████╗ ${RESET}"
        "${BOLD}${LIGHT_BLUE}    ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝    ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗${RESET}"
        "${CYAN}    ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗    ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  ██████╔╝${RESET}"
        "${CYAN}    ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║    ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  ██╔══██╗${RESET}"
        "${BLUE}    ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗██║  ██║${RESET}"
        "${DIM}${GRAY}    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝${RESET}"
    )
    
    # Display lines with fade-in effect
    for line in "${lines[@]}"; do
        echo -e "$line"
        sleep 0.15
    done
    
    echo
    
    # Animated separator - smooth drawing
    echo -e "${DIM}${CYAN}"
    printf "    "
    for i in {1..95}; do
        printf "▄"
        if ((i % 5 == 0)); then
            sleep 0.02
        fi
    done
    echo -e "${RESET}"
    
    # Animated subtitle appearance
    sleep 0.3
    echo -e "${BOLD}${WHITE}                            ${ROCKET} Automated System Management ${ROCKET}${RESET}"
    sleep 0.3
    
    # Animated bottom separator
    echo -e "${DIM}${CYAN}"
    printf "    "
    for i in {1..95}; do
        printf "▀"
        if ((i % 5 == 0)); then
            sleep 0.02
        fi
    done
    echo -e "${RESET}"
    
    echo
    
    # Feature highlights with smooth cascade
    sleep 0.4
    printf "      ${LIGHT_GREEN}${SPARKLES} Smart Updates${RESET}"
    sleep 0.3
    printf "      ${LIGHT_BLUE}${SHIELD} Safe Rollbacks${RESET}"
    sleep 0.3
    printf "      ${LIGHT_YELLOW}${DEBUG} AI Debugging${RESET}"
    echo -e "\n"
    
    # Final flourish - quick pulse
    for i in {1..2}; do
        tput cup $(($(tput lines) - 1)) 0
        echo -e "${DIM}                              Ready to update!${RESET}"
        sleep 0.2
        tput cup $(($(tput lines) - 1)) 0
        echo -e "${BOLD}${LIGHT_GREEN}                              Ready to update!${RESET}"
        sleep 0.3
    done
    
    # Clear the pulse line
    tput cup $(($(tput lines) - 1)) 0
    echo -e "                                                    "
}

print_banner() {
    echo
    echo -e "${BOLD}${LIGHT_BLUE}"
    echo "    ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗    ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗██████╗ "
    echo "    ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝    ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗"
    echo -e "    ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗    ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  ██████╔╝${RESET}"
    echo -e "${CYAN}    ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║    ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  ██╔══██╗${RESET}"
    echo -e "${BOLD}${BLUE}    ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗██║  ██║${RESET}"
    echo -e "${DIM}${GRAY}    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝${RESET}"
    echo
    echo -e "${DIM}${CYAN}    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄${RESET}"
    echo -e "                            ${ROCKET}${BOLD}${WHITE} Automated System Management ${RESET}${ROCKET}"
    echo -e "${DIM}${CYAN}    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${RESET}"
    echo
    echo -e "      ${LIGHT_GREEN}${SPARKLES} Smart Updates${RESET}      ${LIGHT_BLUE}${SHIELD} Safe Rollbacks${RESET}      ${LIGHT_YELLOW}${DEBUG} AI Debugging${RESET}"
    echo
}

print_section_divider() {
    echo -e "${DIM}${CYAN}═══════════════════════════════════════════════════════════════════════════════════════════════${RESET}"
}

print_subsection_divider() {
    echo -e "${DIM}${GRAY}───────────────────────────────────────────────────────────────────────────────────────────────${RESET}"
}

print_step_header() {
    local step="$1"
    local total="$2"
    local description="$3"
    local icon="$4"

    echo -e "\n${BOLD}${WHITE}╭─────────── ${LIGHT_BLUE}Step ${step}${WHITE}/${LIGHT_BLUE}${total}${WHITE} ────────────────────────────────────────────────────────╮${RESET}"
    echo -e "${BOLD}${WHITE}│                                                                                    │${RESET}"
    echo -e "${BOLD}${WHITE}│   ${icon} ${LIGHT_GREEN}${description}${WHITE}$(printf "%*s" $((65 - ${#description})) "")│${RESET}"
    echo -e "${BOLD}${WHITE}│                                                                                    │${RESET}"
    echo -e "${BOLD}${WHITE}╰────────────────────────────────────────────────────────────────────────────────╯${RESET}"
}

print_info_box() {
    local title="$1"
    local content="$2"
    local icon="$3"
    local color="$4"

    echo -e "\n${BOLD}${color}╭─ ${icon} ${title} ──────────────────────────────────────────────────────╮${RESET}"
    echo -e "${BOLD}${color}│${RESET} ${content}${BOLD}${color}$(printf "%*s" $((65 - ${#content})) "")│${RESET}"
    echo -e "${BOLD}${color}╰──────────────────────────────────────────────────────────────────────╯${RESET}"
}

log() {
    local level="$1"
    local message="$2"
    local timestamp="[$(date '+%H:%M:%S')]"

    # Write to logfile (without colors)
    echo "$timestamp $message" >>"$LOGFILE"

    # Display with enhanced colors and styling
    case "$level" in
    "INFO")
        echo -e "${LIGHT_BLUE}${HOURGLASS}${RESET} ${DIM}${GRAY}${timestamp}${RESET} ${message}"
        ;;
    "SUCCESS")
        echo -e "${LIGHT_GREEN}${CHECKMARK}${RESET} ${DIM}${GRAY}${timestamp}${RESET} ${LIGHT_GREEN}${message}${RESET}"
        ;;
    "ERROR")
        echo -e "${LIGHT_RED}${CROSS}${RESET} ${DIM}${GRAY}${timestamp}${RESET} ${LIGHT_RED}${BOLD}${message}${RESET}"
        ;;
    "WARNING")
        echo -e "${LIGHT_YELLOW}${WARNING}${RESET} ${DIM}${GRAY}${timestamp}${RESET} ${LIGHT_YELLOW}${message}${RESET}"
        ;;
    "DEBUG")
        echo -e "${PURPLE}${DEBUG}${RESET} ${DIM}${GRAY}${timestamp}${RESET} ${PURPLE}${message}${RESET}"
        ;;
    "ROLLBACK")
        echo -e "${ORANGE}${ROLLBACK}${RESET} ${DIM}${GRAY}${timestamp}${RESET} ${ORANGE}${BOLD}${message}${RESET}"
        ;;
    "SKIP")
        echo -e "${CYAN}${TARGET}${RESET} ${DIM}${GRAY}${timestamp}${RESET} ${CYAN}${message}${RESET}"
        ;;
    *)
        echo -e "${DIM}${GRAY}${timestamp}${RESET} ${message}"
        ;;
    esac
}

print_command() {
    local cmd="$1"
    echo -e "${DIM}${CYAN}  ${DOUBLE_ARROW} ${ITALIC}Running:${RESET} ${WHITE}${BOLD}${cmd}${RESET}"
}

print_animated_progress() {
    local current="$1"
    local total="$2"
    local description="$3"
    local width=60
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))

    # Create gradient progress bar
    local bar=""
    for ((i = 0; i < filled; i++)); do
        if ((i < filled / 3)); then
            bar="${bar}${LIGHT_RED}█${RESET}"
        elif ((i < 2 * filled / 3)); then
            bar="${bar}${LIGHT_YELLOW}█${RESET}"
        else
            bar="${bar}${LIGHT_GREEN}█${RESET}"
        fi
    done

    for ((i = filled; i < width; i++)); do
        bar="${bar}${DIM}${GRAY}░${RESET}"
    done

    printf "\r${BOLD}${CYAN}${LIGHTNING} Progress: ${RESET}[%s] ${BOLD}${WHITE}%3d%%${RESET} ${DIM}${GRAY}(%d/%d)${RESET} ${ITALIC}${description}${RESET}" "$bar" "$percentage" "$current" "$total"
}

update_progress() {
    ((CURRENT_STEP++))
    print_animated_progress "$CURRENT_STEP" "$TOTAL_STEPS" "Completing step..."
    echo
}

check_nixos_needs_update() {
    log "INFO" "Checking if NixOS system needs rebuilding..."

    # Check if configuration has changed
    if sudo nixos-rebuild dry-run --no-build-nix 2>/dev/null | grep -q "would be built\|would be fetched"; then
        log "SUCCESS" "NixOS rebuild needed - changes detected"
        return 0
    else
        log "SKIP" "NixOS system is already up to date"
        return 1
    fi
}

check_home_manager_needs_update() {
    log "INFO" "Checking if Home Manager needs rebuilding..."

    if command -v home-manager >/dev/null 2>&1; then
        # Check if home-manager configuration has changed
        if home-manager build --dry-run 2>/dev/null | grep -q "would be built\|would be fetched"; then
            log "SUCCESS" "Home Manager rebuild needed - changes detected"
            return 0
        else
            log "SKIP" "Home Manager configuration is already up to date"
            return 1
        fi
    else
        log "WARNING" "Home Manager not found"
        return 1
    fi
}

save_rollback_point() {
    print_info_box "Saving Rollback Point" "Creating system snapshot for safe recovery..." "${SHIELD}" "${LIGHT_BLUE}"

    local nixos_generation=$(sudo nix-env --list-generations -p /nix/var/nix/profiles/system | tail -1 | awk '{print $1}')
    local hm_generation=""

    if command -v home-manager >/dev/null 2>&1; then
        hm_generation=$(nix-env --list-generations -p ~/.local/state/nix/profiles/home-manager | tail -1 | awk '{print $1}' 2>/dev/null || echo "")
    fi

    cat >"$ROLLBACK_INFO" <<EOF
{
    "timestamp": "$(date -Iseconds)",
    "nixos_generation": "$nixos_generation",
    "home_manager_generation": "$hm_generation",
    "git_commit": "$(cd /etc/nixos 2>/dev/null && git rev-parse HEAD 2>/dev/null || echo 'unknown')"
}
EOF

    echo -e "  ${LIGHT_GREEN}${CHECKMARK} Rollback point created successfully${RESET}"
    echo -e "    ${CYAN}${PACKAGE} NixOS Generation:${RESET} ${WHITE}${BOLD}#${nixos_generation}${RESET}"
    echo -e "    ${CYAN}${PACKAGE} Home Manager Generation:${RESET} ${WHITE}${BOLD}#${hm_generation}${RESET}"
}

rollback_system() {
    echo -e "\n${BOLD}${LIGHT_RED}╔═══════════════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${LIGHT_RED}║                          ${FIRE} EMERGENCY ROLLBACK INITIATED ${FIRE}                         ║${RESET}"
    echo -e "${BOLD}${LIGHT_RED}╚═══════════════════════════════════════════════════════════════════════════════════╝${RESET}\n"

    if [[ ! -f "$ROLLBACK_INFO" ]]; then
        log "ERROR" "No rollback information found - cannot proceed"
        return 1
    fi

    local nixos_gen=$(jq -r '.nixos_generation' "$ROLLBACK_INFO")
    local hm_gen=$(jq -r '.home_manager_generation' "$ROLLBACK_INFO")

    print_info_box "Rolling Back NixOS" "Reverting to generation #${nixos_gen}..." "${ROLLBACK}" "${ORANGE}"
    print_command "sudo nix-env --switch-generation $nixos_gen -p /nix/var/nix/profiles/system"
    sudo nix-env --switch-generation "$nixos_gen" -p /nix/var/nix/profiles/system

    print_command "sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch"
    sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch

    if [[ "$hm_gen" != "null" && "$hm_gen" != "" ]]; then
        print_info_box "Rolling Back Home Manager" "Reverting to generation #${hm_gen}..." "${ROLLBACK}" "${ORANGE}"
        print_command "nix-env --switch-generation $hm_gen -p ~/.local/state/nix/profiles/home-manager"
        nix-env --switch-generation "$hm_gen" -p ~/.local/state/nix/profiles/home-manager 2>/dev/null || true
        ~/.local/state/nix/profiles/home-manager/activate 2>/dev/null || true
    fi

    echo -e "\n${BOLD}${LIGHT_GREEN}╔═══════════════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}║                         ${DIAMOND} ROLLBACK COMPLETED SUCCESSFULLY ${DIAMOND}                        ║${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}╚═══════════════════════════════════════════════════════════════════════════════════╝${RESET}"
}

check_for_changes() {
    local current_hashes=$(mktemp)

    # Get current configuration hashes
    if [[ -d "/etc/nixos" ]]; then
        find /etc/nixos -name "*.nix" -type f -exec sha256sum {} \; | sort >"$current_hashes"
    fi

    if [[ -d "/home/salledelavage/nixos" ]]; then
        find /home/salledelavage/nixos -name "*.nix" -type f -exec sha256sum {} \; | sort >>"$current_hashes"
    fi

    # Compare with last known hashes
    if [[ -f "$LAST_HASHES" ]] && diff -q "$LAST_HASHES" "$current_hashes" >/dev/null 2>&1; then
        rm "$current_hashes"
        return 1 # No changes
    fi

    mv "$current_hashes" "$LAST_HASHES"
    return 0 # Changes detected
}

debug_with_claude() {
    local error_output="$1"
    local command="$2"
    local attempt="$3"

    echo -e "\n${BOLD}${PURPLE}╔═══════════════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${PURPLE}║                        ${SPARKLES} CLAUDE CODE AI DEBUGGING ${SPARKLES}                         ║${RESET}"
    echo -e "${BOLD}${PURPLE}╚═══════════════════════════════════════════════════════════════════════════════════╝${RESET}\n"

    local claude_prompt=$(mktemp)

    cat >"$claude_prompt" <<EOF
I'm getting an error while updating my NixOS system (attempt $attempt). Here's the context:

Command that failed: $command

Error output:
$error_output

Can you help me fix this issue? Please:
1. Analyze the error and identify the root cause
2. Suggest specific changes to fix the issue
3. Provide the exact commands or file edits needed

My system is located at /home/salledelavage/nixos/ and I'm using home-manager.
EOF

    log "DEBUG" "Launching Claude Code for AI-powered debugging (attempt $attempt)..."

    if command -v claude-code >/dev/null 2>&1; then
        claude-code "$(cat "$claude_prompt")"
    else
        log "ERROR" "Claude Code not found. Error details:"
        cat "$claude_prompt"
    fi

    rm "$claude_prompt"

    echo -e "\n${BOLD}${LIGHT_YELLOW}╭─ Choose Your Next Action ─────────────────────────────────────────╮${RESET}"
    echo -e "${BOLD}${LIGHT_YELLOW}│${RESET}                                                                    ${BOLD}${LIGHT_YELLOW}│${RESET}"
    echo -e "${BOLD}${LIGHT_YELLOW}│${RESET}  ${LIGHT_GREEN}${LIGHTNING} [Enter]${RESET} - Retry the command after fixing the issue        ${BOLD}${LIGHT_YELLOW}│${RESET}"
    echo -e "${BOLD}${LIGHT_YELLOW}│${RESET}  ${ORANGE}${ROLLBACK} [r/R]${RESET}   - Rollback to previous working configuration     ${BOLD}${LIGHT_YELLOW}│${RESET}"
    echo -e "${BOLD}${LIGHT_YELLOW}│${RESET}  ${LIGHT_RED}${CROSS} [q/Q]${RESET}   - Quit the update process immediately           ${BOLD}${LIGHT_YELLOW}│${RESET}"
    echo -e "${BOLD}${LIGHT_YELLOW}│${RESET}                                                                    ${BOLD}${LIGHT_YELLOW}│${RESET}"
    echo -e "${BOLD}${LIGHT_YELLOW}╰────────────────────────────────────────────────────────────────────╯${RESET}"
    echo -ne "\n${BOLD}${WHITE}${STAR} Your choice: ${RESET}"

    read response

    case "$response" in
    r | R)
        rollback_system
        exit 0
        ;;
    q | Q)
        log "ERROR" "Update process aborted by user"
        exit 1
        ;;
    *)
        log "INFO" "Retrying command after user intervention..."
        return 0
        ;;
    esac
}

run_with_retry() {
    local cmd="$1"
    local description="$2"
    local check_needed="$3"
    local max_attempts=5
    local attempt=1

    # If check function provided, validate if update is needed
    if [[ -n "$check_needed" && "$check_needed" != "true" ]]; then
        if ! $check_needed; then
            log "SKIP" "$description - no changes needed"
            update_progress
            return 0
        fi
    fi

    while [[ $attempt -le $max_attempts ]]; do
        if [[ $attempt -eq 1 ]]; then
            log "INFO" "$description"
        else
            log "WARNING" "$description (retry attempt $attempt/$max_attempts)"
        fi

        print_command "$cmd"

        local temp_log=$(mktemp)
        local exit_code=0

        echo -e "${DIM}${CYAN}  ${GEAR} Output:${RESET}"
        if eval "$cmd" 2>&1 | tee "$temp_log" | sed 's/^/    /'; then
            log "SUCCESS" "$description completed successfully"
            update_progress
            rm "$temp_log"
            return 0
        else
            exit_code=$?
            log "ERROR" "$description failed with exit code $exit_code (attempt $attempt/$max_attempts)"

            local error_output=$(cat "$temp_log")
            rm "$temp_log"

            if [[ $attempt -eq $max_attempts ]]; then
                log "ERROR" "Maximum retry attempts reached. Initiating emergency rollback..."
                rollback_system
                exit 1
            fi

            debug_with_claude "$error_output" "$cmd" "$attempt"
            ((attempt++))
        fi
    done
}

calculate_total_steps() {
    TOTAL_STEPS=1 # Always update channels

    # Check if NixOS rebuild is needed
    if check_nixos_needs_update; then
        ((TOTAL_STEPS++))
    fi

    # Check if Home Manager rebuild is needed
    if check_home_manager_needs_update; then
        ((TOTAL_STEPS++))
    fi

    # Add flake updates if present
    if [[ -f "/etc/nixos/flake.nix" ]]; then
        ((TOTAL_STEPS++))
    fi

    if [[ -f "/home/salledelavage/nixos/flake.nix" ]]; then
        ((TOTAL_STEPS++))
    fi
}

print_update_plan() {
    local plan_items=()

    plan_items+=("${PACKAGE} Update NixOS channels")

    if [[ -f "/etc/nixos/flake.nix" ]]; then
        plan_items+=("${LIGHTNING} Update system flake inputs")
    fi

    if [[ -f "/home/salledelavage/nixos/flake.nix" ]]; then
        plan_items+=("${LIGHTNING} Update home flake inputs")
    fi

    if check_nixos_needs_update; then
        plan_items+=("${WRENCH} Rebuild NixOS system")
    fi

    if check_home_manager_needs_update; then
        plan_items+=("${GEAR} Rebuild Home Manager configuration")
    fi

    echo -e "\n${BOLD}${LIGHT_BLUE}╭─ Update Execution Plan ─────────────────────────────────────────────╮${RESET}"
    echo -e "${BOLD}${LIGHT_BLUE}│${RESET}                                                                      ${BOLD}${LIGHT_BLUE}│${RESET}"

    for i in "${!plan_items[@]}"; do
        echo -e "${BOLD}${LIGHT_BLUE}│${RESET}  ${LIGHT_GREEN}$((i + 1)).${RESET} ${plan_items[$i]}$(printf "%*s" $((60 - ${#plan_items[$i]})) "")${BOLD}${LIGHT_BLUE}│${RESET}"
    done

    echo -e "${BOLD}${LIGHT_BLUE}│${RESET}                                                                      ${BOLD}${LIGHT_BLUE}│${RESET}"
    echo -e "${BOLD}${LIGHT_BLUE}╰──────────────────────────────────────────────────────────────────────╯${RESET}"
}

print_final_summary() {
    local start_time="$1"
    local end_time="$2"
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    local time_str=""

    if [[ $minutes -gt 0 ]]; then
        time_str="${minutes}m ${seconds}s"
    else
        time_str="${seconds}s"
    fi

    echo -e "\n${BOLD}${LIGHT_GREEN}╔═══════════════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}║                                                                                   ║${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}║            ${ROCKET}${SPARKLES} UPDATE COMPLETED SUCCESSFULLY ${SPARKLES}${ROCKET}                        ║${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}║                                                                                   ║${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}╠═══════════════════════════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}║${RESET}                                                                               ${BOLD}${LIGHT_GREEN}║${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}║${RESET}  ${DIAMOND} All system components updated successfully                           ${BOLD}${LIGHT_GREEN}║${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}║${RESET}  ${SHIELD} All changes logged and are fully reversible                         ${BOLD}${LIGHT_GREEN}║${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}║${RESET}  ${CLOCK} Execution time: ${WHITE}${BOLD}${time_str}${RESET}$(printf "%*s" $((48 - ${#time_str})) "")${BOLD}${LIGHT_GREEN}║${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}║${RESET}  📁 Log file: ${WHITE}${BOLD}${LOGFILE}${RESET}$(printf "%*s" $((47 - ${#LOGFILE})) "")${BOLD}${LIGHT_GREEN}║${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}║${RESET}                                                                               ${BOLD}${LIGHT_GREEN}║${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}╚═══════════════════════════════════════════════════════════════════════════════════╝${RESET}"
}

main() {
    local start_time=$(date +%s)

    # Use animated banner if --animate flag is passed
    if [[ "$1" == "--animate" ]]; then
        print_animated_banner
    else
        print_banner
    fi

    log "INFO" "Initializing NixOS system update process..."

    # Check if there are any configuration changes
    print_info_box "Configuration Analysis" "Scanning for changes in Nix configurations..." "${MAGNIFY}" "${LIGHT_BLUE}"
    if ! check_for_changes; then
        print_info_box "No Updates Required" "System is already up to date!" "${CHECKMARK}" "${LIGHT_GREEN}"
        echo -e "${DIM}${ITALIC}No configuration changes detected. Exiting gracefully.${RESET}"
        exit 0
    fi

    print_info_box "Changes Detected" "Configuration modifications found - proceeding..." "${LIGHTNING}" "${LIGHT_GREEN}"
    log "SUCCESS" "Configuration changes detected - update required"

    calculate_total_steps
    print_update_plan

    print_section_divider
    print_animated_progress 0 "$TOTAL_STEPS" "Initializing..."
    echo
    print_section_divider

    # Save rollback point before starting
    save_rollback_point
    print_subsection_divider

    # Update channels
    print_step_header $((CURRENT_STEP + 1)) "$TOTAL_STEPS" "Updating NixOS Channels" "${PACKAGE}"
    run_with_retry "sudo nix-channel --update" "Updating NixOS channels" "true"

    # Update flakes if using flakes
    if [[ -f "/etc/nixos/flake.nix" ]]; then
        print_step_header $((CURRENT_STEP + 1)) "$TOTAL_STEPS" "Updating System Flake Inputs" "${LIGHTNING}"
        run_with_retry "sudo nix flake update /etc/nixos" "Updating system flake inputs" "true"
    fi

    if [[ -f "/home/salledelavage/nixos/flake.nix" ]]; then
        print_step_header $((CURRENT_STEP + 1)) "$TOTAL_STEPS" "Updating Home Flake Inputs" "${LIGHTNING}"
        run_with_retry "cd /home/salledelavage/nixos && nix flake update" "Updating home flake inputs" "true"
    fi

    # Rebuild NixOS system (only if needed)
    print_step_header $((CURRENT_STEP + 1)) "$TOTAL_STEPS" "Rebuilding NixOS System" "${WRENCH}"
    run_with_retry "sudo nixos-rebuild switch" "Rebuilding NixOS system" "check_nixos_needs_update"

    # Update home-manager (only if needed)
    print_step_header $((CURRENT_STEP + 1)) "$TOTAL_STEPS" "Rebuilding Home Manager" "${GEAR}"
    run_with_retry "home-manager switch" "Rebuilding home-manager configuration" "check_home_manager_needs_update"

    # Clean up old logs (keep last 10)
    find "$STATE_DIR" -name "update-*.log" -type f | sort | head -n -10 | xargs -r rm 2>/dev/null || true

    local end_time=$(date +%s)
    print_final_summary "$start_time" "$end_time"
}

# Handle interrupts gracefully
trap 'echo -e "\n${LIGHT_RED}${CROSS} Update process interrupted by user${RESET}"; rollback_system; exit 130' INT TERM

# Check for required dependencies
if ! command -v jq >/dev/null 2>&1; then
    echo -e "${LIGHT_RED}${CROSS} Error: ${BOLD}jq${RESET}${LIGHT_RED} is required but not installed.${RESET}"
    echo -e "${LIGHT_YELLOW}${WRENCH} Please install it with: ${WHITE}${BOLD}nix-env -iA nixpkgs.jq${RESET}"
    exit 1
fi

main "$@"
