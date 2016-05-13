## INSTALL

 $ curl -L https://cpanmin.us | perl - App::cpanminus
 $ cpanm Carton
 $ cd scripts
 $ carton install

## FAQ

### compile.pl usage

 * build HTMLs by `cd scripts` && `carton exec perl compile.pl`
 * build specified url by `carton exec perl compile -p why-us`

### Local test

After HTML build, you can run `sudo grunt connect` then visits [https://localhost/en/home.html] for test

### github.io deploy

 * `carton exec perl compile -d`
