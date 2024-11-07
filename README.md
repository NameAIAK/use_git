# use_git
在命令行上创建新存储库
echo "# transcriptome">> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M master
git remote add origin git@github.com:AIAkun/transcriptome .git
git push -u origin master

从命令行推送现有存储库
git remote add origin git@github.com:AIAkun/transcriptome.git
git branch -M master
git push -u origin master# use_git
