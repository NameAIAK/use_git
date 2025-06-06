# use_git
<!-- 在命令行上创建新存储库 -->
echo "# transcriptome">> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M master
git remote add origin git@github.com:AIAkun/transcriptome .git
git push -u origin master

<!-- 从命令行推送现有存储库 -->
git remote add origin git@github.com:AIAkun/transcriptome.git
git branch -M master
git push -u origin master# use_git


<!-- windows下载git ： https://gitforwindows.org/ -->

<!-- 创建秘钥 -->
ssh-keygen -t rsa -C "email" 
<!-- #按步骤全部执行Enter键，秘钥存放在/c/Users/{username}/.ssh/id_rsa.pub，将秘钥复制到git，登录github,打开”settings”中的SSH Keys页面，然后点击“Add SSH Key”,填上任意title，在Key文本框里黏贴id_rsa.pub文件的内容。 -->

<!-- 在GitHub设置中，转到“Developer settings”->“Personal access tokens”，然后点击“Generate new token”生成新的令牌。 克隆所有仓库 -->
curl -H "Authorization: token github_pat_11AWLKOTI0WHZRxJgLpy1Y_Qv1VJ0aYiZeFmKVtWlToyZzqNR6dg7zsRTM7XLMYQkurP8FuO" https://api.github.com/users/NameAIAK/repos?per_page=100 | grep -o 'git@[^"]*' | xargs -L1 git clone

<!-- 打开git bash进入仓库 -->
<!-- 设置邮件和用户名 -->
git config --global user.email '1303385@163.com'
git config --global user.name 'NameAIAK'

<!-- 在本地对仓库进行操作，修改，提交 -->
<!-- 假设添加一个test.txt文件 -->
touch test.txt
git add .
git status
git commit -m 'add testfile' #提交是要填写描述，不可为空
git push -u origin master
