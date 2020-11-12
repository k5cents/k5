# k5 (development version)

* Changed `zip_ls()` to `zip_info()` to match `fs::dir_info()`.
* New `zip_ls()` added to take filenames from `zip_info()` like `fs::dir_ls()`.

# k5 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
* Added `zip_*()` from [kiernann/fs](https://github.com/kiernann/fs).
* Added `aws_ls()` wrapper around `aws.s3::get_bucket_df()`.
* Added simple `print_all()` wrapper around `print(n = Inf)`.
