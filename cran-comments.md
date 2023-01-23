## Test environments

* local: ubuntu 22.10, R 4.2.1
* [github-actions][gh_act]:
    * windows-latest
    * macOS-latest
    * ubuntu-20.04 (release)
    * ubuntu-20.04 (devel)
* r-hub: 
    * [windows-x86_64-devel][rhub_win]
    * [ubuntu-gcc-release][rhub_ubu]
    * [fedora-clang-devel][rhub_fed]

## R CMD check results

0 errors | 0 warnings | 2 notes

* This is a new release.
* There is one NOTE that is only found on Windows (Server 2022, R-devel 64-bit): 

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```
As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), 
this could be due to a bug/crash in MiKTeX and can likely be ignored.

## Resubmission

* Added paragraph Description field to DESCRIPTION file.
* Added `\value` tags to all function documentation.
    * Added `\value` tags to the new clipboard reading/writing functions.
* Spell checked new Description field in DESCRIPTION file.

<!-- links: start -->
[gh_act]: https://github.com/kiernann/gluedown/actions
[rhub_win]: https://builder.r-hub.io/status/k5_0.0.5.tar.gz-fe4507f92e784b6daebe78ca907525be
[rhub_ubu]: https://builder.r-hub.io/status/k5_0.0.5.tar.gz-3169c9c34dd94873b98969f409166dfb
[rhub_fed]: https://builder.r-hub.io/status/k5_0.0.5.tar.gz-79dfff34324542c5a3b041e92dd40759
<!-- links: end -->
