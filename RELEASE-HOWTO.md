#  How to prepare a new release

... and not make too many mistakes.


##  In the Local Repository

1. Check that the work-area is clean with respect to **git**-tracked
   files.

   ```git status```

1. Update the date stamp of `\ProvidesPackage`.

1. (Temporarily) Zero the `\overfullrule`s of the documentation and
   the example files.

1. Thoroughly clean the work-area:

   ```make maintainer-clean```

1. Rebuild:

   ```make```

1. Check that all _*.sty_ and _*.pdf_ files are in good shape.
   The files to review are

   ```file *.sty *.pdf```

   In particular verify that the version and date information was
   propagated.

1. Push the documentation files created in the previous step down into
   the *docs* directory:

   ```make update-docs```

   and create the tarballs for [CTAN](https://ctan.org/):

   ```make dist```

1. Undo the `\overfullrule` change.

1. Commit the changes:

   ```git add .```

   and finally

   ```git commit -m 'Release version 1.23 of typog.'```

1. Tag the commit with the version string of `\ProvidesPackage`:

   ```git tag v1.23```

1. Push the changes including the newly created tag to the public
   repository:

   ```git push origin main --tags```


##  In the Public (GitHub) Repository

1. On the project's main page check that the commit reached the GitHub
   repository and ensure that the "Deployments" section got its
   check-mark.

1. Click "Create a new release".

1. On the release/new page select the tag assigned to the release.
   Title the release with "Version 1.23".  Add release notes as
   necessary.

1. Click "Publish release" when done.
