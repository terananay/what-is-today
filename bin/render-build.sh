set -o errexit

# exiftoolのインストール
sudo apt-get update
sudo apt-get install -y libimage-exiftool-perl

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate