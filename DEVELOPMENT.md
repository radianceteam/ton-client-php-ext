# PHP Extension for TON SDK Wrapper - Development notes

## Building extension

### Windows

#### Requirements

 - A 64-bit build host
 - Windows 7 or later. 
 - VS 2017. Required components:
    - C++ dev (VC15)
    - Windows SDK
    - .NET dev
 - Git

#### Running build

```
build.bat <PHP_VERSION> <PLATFORM> [<ZTS>]
```

example:

```
build.bat 7.4.1 x86
```

or

```
build.bat 7.4.1 x64 ZTS
```

### Linux/Mac

#### Required tools

`phpize` is a required command for building extension from sources.
For example, on Ubuntu it can be installed by executing `sudo apt-get install php7.4-dev` command.  

#### TON SDK installation

For installing TON client extension on Linux, first install TON client binaries:

```
git clone https://github.com/radianceteam/ton-client-php-ext.git
cd ton-client-php-ext
./install-sdk.sh [/path/to/sdk/installation/directory]
```

Installation path can be omitted, the script will use $HOME/ton-sdk by default.

#### Building PHP extension

 - Run build script:

```
./build.sh [/path/to/sdk/installation/directory]
```
which will produce lots of text but amongst the last lines will be (note the build path may differ):
```
Libraries have been installed in:
   /Users/andy/Projects/ton/ton-client-php-ext/build/modules
```

 - Copy the extension file `ton_client.so` from the given path to the PHP extension dir.
   It depends on your PHP installation, if it's PHP installed on Mac via Homebrew for example,
   then extension path may be /usr/local/opt/php/lib/php/:

```
PHP_EXT_DIR=$(php-config --extension-dir)
echo $PHP_EXT_DIR
/usr/lib/php/20190902
sudo cp /Users/andy/Projects/ton/ton-client-php-ext/build/modules/ton_client.so $PHP_EXT_DIR
```

 - Add extension to `php.ini`:

```
PHP_INI_DIR=$(php-config --ini-dir)
echo $PHP_INI_DIR
/etc/php/7.4/cli/conf.d
echo 'extension="ton_client.so"' | sudo tee ${PHP_INI_DIR}/ton_client.ini
```

To check if the extension is loaded, call `php --info`:

```
php --info | grep ton_client
```

output should be 

```
ton_client
ton_client support => enabled
```

## Upgrading TON client library

1. Download the latest `ton_client` binaries and place to `deps` directory (replacing the existing ones).
   - binaries can be loaded from the main GitHub repository ([tonlabs/TON-SDK](https://github.com/tonlabs/TON-SDK)) or 
   from side project ([radianceteam/ton-client-dotnet-bridge](https://github.com/radianceteam/ton-client-dotnet-bridge/actions))
   which was created only fo building SDK binaries. 
   - NOTE: BE CAREFUL WITH USING BINARIES FROM TON-SDK REPO as they are only built for the major release at the moment. (Come on guys, please do a better CI/CD for this).
   - Using side project [radianceteam/ton-client-dotnet-bridge](https://github.com/radianceteam/ton-client-dotnet-bridge/actions) 
   is the recommended way ATM.
   - You could also build TON-SDK binaries yourself.
2. Update extension version in `php_ton_client.h`.
3. Commit and push changes; create new tag:

```
git tag <VERSION>
git push origin <VERSION> 
```

for example:

```
git tag 1.3.0
git push origin 1.3.0 
```

3. Wait for the new Release build to finish. Find the extension files in the Release assets.

## Versioning

Package versioning mirrors TON SDK releases. So for example package `1.1.1` works 
with TON SDK binaries of the same version, and contains all the functions from the 
corresponding `api.json`. 

## Troubleshooting

Fire any question to our [Telegram channel](https://t.me/RADIANCE_TON_SDK). 

## Links

 - [TON SDK PHP client library](https://github.com/radianceteam/ton-client-php).
 - [Writing PHP Extensions](https://www.zend.com/resources/writing-php-extensions).

