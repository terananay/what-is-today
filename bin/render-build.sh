set -o errexit

# exiftoolのインストール
cd $HOME
wget -O exiftool.tar.gz https://exiftool.org/Image-ExifTool-12.40.tar.gz
tar -xzf exiftool.tar.gz
cd Image-ExifTool-12.40
perl Makefile.PL
make
make test
make install

# 環境変数の設定
export PATH=$HOME/perl5/bin:$PATH

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
