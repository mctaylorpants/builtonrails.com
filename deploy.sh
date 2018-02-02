set -e
echo "Pushing to master..."

git push origin head

echo "Deploying builtonrails..."

SOURCE=./
DESTINATION=./_site

bundle exec jekyll build --source $SOURCE --destination $DESTINATION
surge --project $DESTINATION --domain builtonrails.com

echo "Shipped!"
