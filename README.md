# What is it ?

A simple bash script for linux system to upload, retrieve, delete and list files on several online storage providers using the Faascape platform (https://www.faascape.com) as proxy.

You can use your own accounts for each provider or access everything with your Faascape account.

To change target provider, you have to use the faascape dashboard management or provide several system variables.

There is currently three providers available :

- Amazon S3
- Microsoft Azure Storage
- Google Storage

Region used for storage depends of the choosen access point.

More providers will be automatically supported as Faascape integrates them.

This is a very future proofed way to manage your storage. If you want to change your provider or have different providers for various project, you don't have to change your script.  

# A word about security

Two modes of operation may be used :

- standard : you retrieve a token from the Faascape platform and use it to call faascape endpoints.
- autonomous : you can provide your own credentials related to target provider when calling Faascape endpoint. Of course, it is not good security practice to handover your private id to a third party. This feature has been essentially provided to handle local Faascape proxy but you can use if needed on remote proxies. We plan to build a docker image to distribute as a standard local proxy.

# Prerequisite

curl must be installed on your system.

# Quick overview
```
fscp-storage.sh COMMAND [STORAGE_TARGET_PATH] [FILENAME]
```

COMMAND : upload|get|delete|help

Example :
```

fscp-storage.sh upload /backup/appl1/bu-20160101.tar.gz bu.tar.gz 

```

This command send the file bu.tar.gz in /backup/appl1/bu-20160101.tar.gz for selected storage provider.

# Mandatory system variables

The script relies on several system variables describing its context

## FSCP_ENDPOINT

FSCP_POINT defines the url access point you want to use.

Example : https://api.amz-eu-west-1.faascape.com

It depends of your Faascape environment configuration.

## FSCP_TOKEN

Token from Faascape used to authenticate your request.


# Optional system variables

## FSCP_PROVIDER

You can override your Faascape configuration and choose the provider you want to use.

Values can be :

- s3/s3
- google/google
- azure/azure

## FSCP_KEY

FSCP_KEY, FSCP_SECRET and FSCP_BUCKET must be used together.

When you want to use your own account.

- s3 : account key
- google : key / mail account
- azure : storage name

## FSCP_SECRET

- s3 : account secret
- google : private key
- azure : account secret

## FSCP_BUCKET

Bucket name to use

## FSCP_GOOGLE_ID

If you want to use your google account, you must provide a project id in complement of key, secret and bucket.


# Commands

## upload

Used to send a file to provider

Example :
```

fscp-storage.sh upload /backup/appl1/bu-20160101.tar.gz bu.tar.gz 

```

This command send the file bu.tar.gz in /backup/appl1/bu-20160101.tar.gz for selected storage provider.

If the target path is already used by a file, the command will failed. Existing files are NOT overwritten.


__Command output__

if everything is ok and file is stored :

```
{
    "msg":"OK",
    "hash":"fffb5312e4560bed29710e0c4313bc57",
    "size":"43750"
}

```

if an error occured (for example file already exists)

```
{
    "msg":"Already exists",
    "code":"ERR-AE"
}


```



## get

Retrieve a previously stored file, retrieve info about a file, or list path content.

### retrieve file

By providing a path to a stored file, we get the file content and standard output.

Example :
```

fscp-storage.sh get /backup/appl1/bu-20160101.tar.gz >backup.tar.gz 

```

### retrieve file info

You can retrieve file informations by suffixing your file name with "?info".

Example :
```

fscp-storage.sh get /backup/appl1/bu-20160101.tar.gz?info 

```

__Command output__

```
{
    "id":"0aa1e175-93b3-4857-a2b2-9e833e95ded9",
    "file_name":"/test-example/file1.jpg",
    "creation_date":"2016-02-16T17:10:37.064Z",
    "hash":"fffb5312e4560bed29710e0c4313bc57",
    "file_size":"43750",
    "content_type":"image/jpeg",
    "is_public":false,
    "storage_provider":"azure"
}    

```

### retrieving path content

if parameter path is related to an incomplete path, command will output all path or file store under this path.

Example :
```

fscp-storage.sh get /pictures 

```



__Command output__

if /pictures contains one directory named "dir2" and a file "file1.jpg", the result is :

```
[
    {
        "name":"dir2",
        "type":"dir"
    },
    {
        "name":"file1.jpg",
        "creation_date":"2016-02-16T17:10:37.064Z",
        "hash":"fffb5312e4560bed29710e0c4313bc57",
        "file_size":"43750",
        "content_type":"image/jpeg",
        "is_public":false,
        "storage_provider":"azure",
        "type":"file"
    }
]



```



## delete file

Remove a file from storage, you can't removed "directories" and all their content.

Example :
```

fscp-storage.sh delete /backup/appl1/bu-20160101.tar.gz

```

__Command output__


if everything is ok :

```
{
    "msg":"File removed"
}
    
```

else

```
{
    "msg":"File not found"
}

```




# How does it work ?

This script just send http requests to a Faascape endpoint and build all headers value to be able to use all Faascape features related to provider management.


# License

Simplified BSD License
