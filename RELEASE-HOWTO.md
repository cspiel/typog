#  How to prepare a new release

... and not make too many mistakes.


1. Check that the work-area is clean with respect to **git**-tracked
   files.

   ``` git status ```

1. Update the date stamp of `\ProvidesPackage`.

1. (Temporarily) Zero the `\overfullrule`s of the documentation and
   the example files.

1. Thoroughly clean the work-area:

   ```make maintainer-clean```

1. Rebuild:

   ```make```

1. Check that all _*.sty_ and _*.pdf_ files are in good shape.

1. Push the documentation files created in the previous step down into
   the *docs* directory:

   ```make update-docs```

1. Undo the `\overfullrule` change.

1. Commit the changes:

   ```
   git add .
   ```

   and finally

   ```
   git commit
   ```

1. Tag the commit with the version string of `\ProvidesPackage`:

   ```git tag v1.23```

1. Push the changes to the public repository:

   ```git push origin master --tags```
