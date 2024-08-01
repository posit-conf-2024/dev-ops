# Posit::Conf2024 Template for Quarto

In order to make sure the background pictures work in Connect, feel free to use
this code to create the manifest file. It will contain the needed references 
to the pictures.

```r
app_files <- fs::dir_ls()
app_files <- app_files[!grepl("qmd", app_files)]
app_files <- app_files[!grepl("rsconnect", app_files)]
rsconnect::writeManifest(
  appPrimaryDoc = "positconf-2024-template.html",
  appFiles = app_files
)
```

After the file is created, publish it via the Git Backed feature in Connect:
https://docs.posit.co/connect/user/publishing-cli-manifest/

To view a published version of this template visit: https://connect.posit.it/positconf2024-template/