#=  ================================================================================================
    AWS, AWSS3 snippets and configs

    author:     mahiki@users.noreply.github.com
=   ===============================================================================================#

using DesertIslandDisk
using AWSS3
using Parquet2

# SSO CONFIG #
# ========== #
creds = AWSCredentials(profile="my-profile") # from SSO session
config = AWSConfig(;creds, region="my-region")
path = S3Path("s3://bucket/object.parquet"; config)
ds = Parquet2.Dataset(path)
#   note this has an open issue https://gitlab.com/ExpandingMan/Parquet2.jl/-/issues/26
# TODO: go through a full example of this