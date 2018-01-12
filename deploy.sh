set -e
echo "Deploying builtonrails..."

SOURCE=./
DESTINATION=./_site

bundle exec jekyll build --source $SOURCE --destination $DESTINATION
surge --project $DESTINATION --domain builtonrails.com

echo "Shipped!"
