# Installation

```
git clone https://github.com/zaro0508/git-gerrit.git ~/.git-gerrit
ln -s ~/.git-gerrit/git-gerrit.sh /usr/local/bin/git-gerrit
```

# Usage

1. Clone a gerrit repo
2. cd into repo
3. git-gerrit $changeId $pastchsetId

__For example:__
```
git clone https://gerrit.googlesource.com/gerrit-ci-scripts
zaro0508@elitebook:~/work-gerrit$ git clone https://gerrit.googlesource.com/gerrit-ci-scripts
Cloning into 'gerrit-ci-scripts'...
remote: Total 1366 (delta 406), reused 1366 (delta 406)
Receiving objects: 100% (1366/1366), 677.31 KiB | 0 bytes/s, done.
Resolving deltas: 100% (406/406), done.
Checking connectivity... done.

zaro0508@elitebook:~/work-gerrit$ cd gerrit-ci-scripts/
~/work-gerrit/gerrit-ci-scripts [master|✔] 
10:09 $ git-gerrit 92297 1
remote: Counting objects: 266, done
remote: Finding sources: 100% (4/4)
remote: Total 4 (delta 0), reused 2 (delta 0)
Unpacking objects: 100% (4/4), done.
From https://gerrit.googlesource.com/gerrit-ci-scripts
 * branch            refs/changes/97/92297/1 -> FETCH_HEAD

Switched to branch 'c92297_1'
~/work-gerrit/gerrit-ci-scripts [c92297_1 L|✔] 
10:10 $ git branch
* c92297_1
  master
```
