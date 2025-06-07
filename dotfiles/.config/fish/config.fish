if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Aliases
alias bat "batcat"
alias fd "fdfind"

# Update path (exported for CUDA and tools)
set -x PATH /usr/local/cuda/bin $PATH
set -x LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH

# Keep at end
zoxide init fish | source
