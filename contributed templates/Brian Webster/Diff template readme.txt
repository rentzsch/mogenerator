Diff mogenerator template
-------------------------
This template was created for the use case of merging two versions of a .xcdatamodel file,
e.g. when doing a merge in a version control system. Since data model files are stored as 
binary data, there is no way to directly diff them. Additionally, since it's an undocumented 
format, even if we're able to diff them, there still isn't any way to automatically apply those diffs.

The template itself basically just dumps the relevant properties and relationships for each 
entity in the data model into a pseudo plist looking format, with each relevant attribute put 
on its own line. In order to merge two versions of a data model, you would perform the following
steps:

1. Run mogenerator on each of the two versions of the data model and put the results into two
different directories. 
2. Use your favorite diff tool to diff the two resulting directories
3. Look at the changes in each class, then use the data model editor in Xcode to manually apply 
each change to one of the two versions of the data model, so that they match
4. Once you've gone through and made all the changes, you can re-run mogenerator on the edited
version, re-diff them, and double check that you didn't miss anything

The one major caveat here is that only entites in the data model are currently handled, so if 
your model has any fetch request templates in it, those will not be included in the output. 
If anyone wants to add them to the output, feel free. :)