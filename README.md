# genchlg

This is an bash wrapper for [changelog-generator](https://github.com/lob/generate-changelog), to automatic create, commit, push, an CHANGELOG.md from your git repo commits.

>Please, feel free to report issues/bugs to github. You can also leave any suggestion to improve the script.

## Why?

During the development of [bash_error_lib](https://github.com/iptoux/bash_error_lib), i missed an tool to create an CHANGELOG.md for my project. On **GitHub** i found the repo from [@lob](https://github.com/lob). He has the **changelog-generator** there. This is my choice as base, but there is no "automatic" control in bash.


## Usage?

#### Download/Clone/Install/Setup

```
mkdir gittmp && cd gittmp
git clone https://github.com/iptoux/genchlg.git
```
Now, copy `genchlg.sh` **to your git project** folder, and make it "executable".

```
cp genchlg.sh /path/to/your/git/repo
chmod +x /path/to/your/git/repogenchlg.sh
```
Done! You can now run the command `./genchlg.sh`.

#### Run command in your git repo

```
cd /path/to/your/git/repo
./genchlg.sh
```

## Important information's

#### selected parts copied from [@lob's repo](https://github.com/lob/generate-changelog), because you need this information to use this wrapper successfully.

>To use this module, your commit messages have to be in this format:
>type(category): description [flags]
>
>- breaking build ci chore docs feat fix other perf refactor revert style test
>
>Where flags is an optional comma-separated list of one or more of 
>the following (must be surrounded in square brackets):
>
>breaking: alters type to be a breaking change
>
>And category can be anything of your choice. If you use a type not 
>found in the list (but it still follows the same format of the 
>message), it'll be grouped under other.

---

## Screens/Output

Images not yet included, the output should somthing like the following.

#### CLI

```
iptoux@2040:~/gits/genchlg$ ./genchlg.sh 
CHANGELOG.md gen.
──────────────────────────────────────────────────
[->] Checking depencies: done.
[->] CHANGELOG.md - Type/Mode?
[->] [1:Major (+.x.x)] // [2:Minor (x.+.x)] // [3:Patch (x.x.+)]
[->] Select: 1
[->] Shure? (y/n): y

Generate/Update an Major (+.x.x) CHANGELOG.md in your repository.
──────────────────────────────────────────────────
[->] Generate CHANGELOG.md: done.
[->] Commiting CHANGELOG.md: done.
[->] StepUp version/set tags on repo: done.
[->] Auto-push disabled. You can enable it by setting false (true) in head of this file.
[->] Push it to git? (y/n): y
[->] Select y/Y -> pushing to git: done.

Finish, all steps done!

iptoux@2040:~/gits/genchlg$ 
```

(img1)


## @Todo

- [ ] Adding script auto-update.
