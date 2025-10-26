#!/bin/sh
set -e

# Function to log with timestamp and level
log() {
    level=$1
    message=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message"
}

# Check core API key configuration (required for LLM functionality)
if [ -z "$API_KEY" ]; then
    log "ERROR" "API_KEY is required for core LLM functionality"
    log "ERROR" "Set API_KEY in .env file (OpenAI API key)"
    exit 1
fi
log "INFO" "Core API key (OpenAI) is configured"

# Check search provider configuration
SEARCH_PROVIDER=${SEARCH_PROVIDER:-deepseek}  # Default to deepseek if not set
log "INFO" "Search provider configured as: $SEARCH_PROVIDER"

case "$SEARCH_PROVIDER" in
    "openai")
        log "INFO" "Using OpenAI for search"
        ;;
    "deepseek")
        if [ -z "$DEEPSEEK_API_KEY" ]; then
            log "ERROR" "SEARCH_PROVIDER is set to 'deepseek' but DEEPSEEK_API_KEY is not set"
            log "ERROR" "Set DEEPSEEK_API_KEY in .env file"
            exit 1
        fi
        log "INFO" "Deepseek API key is configured"
        ;;
    "bing"|"google"|"baidu")
        log "INFO" "Using $SEARCH_PROVIDER as search provider"
        ;;
    *)
        log "ERROR" "Unknown SEARCH_PROVIDER: $SEARCH_PROVIDER"
        log "ERROR" "Valid options: openai, deepseek, bing, google, baidu"
        exit 1
        ;;
esac

# Execute the main container command
if [ $# -eq 0 ]; then
    # If no command provided, use the container's default CMD
    log "INFO" "Starting main process with default command"
    # Use the default command from the base image
    exec python -m uvicorn app.main:app --host 0.0.0.0 --port 8000
else
    # If command provided, use it
    log "INFO" "Starting main process: $*"
    exec "$@"
fi