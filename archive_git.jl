# Julia script to archive branches for Git.
# Last updated on 13 Dec 2016 by Kai Xu

USAGE = """
Usage:

  Julia archive_git.jl -g GPATH -t BRANCH...

    - GPATH is the path of Git to work on
    - BRANCH... is a list of branches to archive separated by spaces

"""

# Parse arguments
GPATH = ""
TOKEEP = String[]

flag = ""
while length(ARGS) > 0
  arg = shift!(ARGS)
  if arg == "-g"
    flag = "g"
  elseif arg == "-k"
    flag = "k"
  elseif flag == "g"
    GPATH = arg
    flag = ""
  elseif flag == "k"
    push!(TOKEEP, arg)
  else
    println(USAGE)
    exit()
  end
end

println("Working on Git path: ", GPATH)
println("To keep branches: ", TOKEEP)

# Go to Git dir
cd(GPATH)

# Reach branch names
branches_str = readstring(`git branch`)
branches = split(branches_str, "\n")
branches = map(str -> replace(str, " ", ""), branches)
branches = map(str -> replace(str, "*", ""), branches)
branches = filter(str -> str != "", branches)

# Tag and remove
for b in branches
  if ~(b in TOKEEP)
    println("Tagging branch $b ...")
    run(`git tag archive/$b $b`)
    println("Deleting branch $b ...")
    run(`git branch -D $b`)
  end
end

println("Archivism done.")
