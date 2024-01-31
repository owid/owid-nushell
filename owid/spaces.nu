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

# Interact with S3 using the owid-spaces profile
export def main [...args] {
    aws --profile=owid-spaces s3 --endpoint-url=https://nyc3.digitaloceanspaces.com ...$args
}
