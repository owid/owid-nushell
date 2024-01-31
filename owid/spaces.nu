#
#  spaces.nu
#
#  Use "owid spaces ..." instead of "aws s3 ..." to interact with DigitalOcean spaces
#  using the AWS CLI. It encourages you to have no [default] credentials in ~/.aws, meaning
#  you can't mess up and accidentally use the wrong credentials.
#  

# Set up the owid-spaces profile for S3
export def configure [] {
    aws configure --profile=owid-spaces
}

export def nyc3 [...args] {
    aws --profile=owid-spaces s3 --endpoint-url=https://nyc3.digitaloceanspaces.com ...$args
}
export def fra1 [...args] {
    aws --profile=owid-spaces s3 --endpoint-url=https://fra1.digitaloceanspaces.com ...$args
}

export def r2 [...args] {
    aws --profile=r2 s3 --endpoint-url=https://078fcdfed9955087315dd86792e71a7e.r2.cloudflarestorage.com ...$args
}

export def main [] {
    echo "Usage: owid spaces [nyc3|fra1|r2] [args]"
}