# Creating spellcheck extension

This is a set of files to help you create a spellcheck dictionary extension.

1. Populate [locales.csv](locales.csv) according to your language. Expected fields:
   * `lang` - language code
   * `dict_name` - localized, user-friendly name of the dictionary extension in the corresponding language, e.g. translated "English dictionary"
   * `dict_summary` - short description of the extension in corresponding language, e.g. translated "Spellcheck dictionary for English language"
   * `dict_license` - licence of the dictionary, or `LicenseRef-proprietary` if unsure or no license provided
   
   Dictionaries can be downloaded from http://wps-community.org/download/dicts
2. Run `make all` in this directory. It is expected to produce manifest and appdata, i.e.
   * `com.wps.Office.spellcheck.your_LANG.yml`
   * `com.wps.Office.spellcheck.your_LANG.metainfo.xml`
​
   where `your_LANG` is your language code.
3. Check the generated files and edit them if needed.
   By default they use `extra-data` sources, so that the dictionary is downloaded at install time.
   If the dictionary is free (not proprietary or unlicensed), you can extract the archive at install time, refer to `flatpak-builder` docs to do that.
4. Build, install and check if everything works fine, i.e. WPS Office sees the new dictionary and it actually checks spelling.
5. Put the manifest and appdata into a new git repo and submit to Flathub at will.
