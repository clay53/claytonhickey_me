# Define an array of target directories
TARGET_DIRS=("bin" "blogs-v0" "blogs-v1" "includes" "copy") # Add more directories as needed

# Start dune build -w in the background
dune build -w &
#echo "test" &
# Save the PID of the dune build process
DUNE_PID=$!

webfsd -F -p 8000 -f index.html -r www &
WEBFSD_PID=$!

# Initialize an array to store the PIDs of inotifywait processes
declare -a INOTIFY_PIDS

# Function to clean up background jobs on script exit
cleanup() {
    echo "Stopping dune build..."
    kill $DUNE_PID
    echo "Stopping webfsd..."
    kill $WEBFSD_PID
    for pid in "${INOTIFY_PIDS[@]}"; do
        echo "Stopping inotifywait process $pid..."
        kill "$pid"
    done
}

# Trap EXIT and call the cleanup function
trap cleanup EXIT

# Function to start monitoring a directory
monitor_directory() {
    local dir=$1
    while true; do
        # Wait for a change in the directory with a debounce period
        if inotifywait -r -e modify,create,delete,move -qq --timefmt '%s' --format '%T' -t 1 "$dir"; then
            #echo "changed!"
            ocaml no_dune.ml
        fi
    done &
    INOTIFY_PIDS+=($!)
}

# Check if the target directories exist and start monitoring
for dir in "${TARGET_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "The directory $dir does not exist."
        exit 1
    else
        monitor_directory "$dir"
    fi
done

# Wait for inotifywait processes to exit
wait "${INOTIFY_PIDS[@]}"
