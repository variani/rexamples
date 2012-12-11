# R examples

## Git commands

References

* [http://git.or.cz/course/svn.html](http://git.or.cz/course/svn.html)

### update

    # svn update
    git pull

> An equivalent of "svn update" would be "git pull --rebase". 
> Also please remember that you can do "git fetch" separately from the "git merge" part of "git pull".
> 
> via [stackoveflow.com](http://stackoverflow.com/questions/1309878/a-git-pull-command-works-like-svn-update#comment1145653_1309878)

### commit

Configuration

    git remote add origin https://github.com/username/Hello-World.git

Commit

    git add README
    git commit -m 'first commit'
    git push origin master    