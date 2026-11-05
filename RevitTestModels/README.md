# Revit Test Models

Kelly test models for the in-Revit tests of the Kelly Tools For Revit repositories (v4 and v5). They sit here, in the jhkweb root repository and outside every sibling repository, so every repository's tests can open them.

The models are stored in Git LFS (`*.rvt` in the root `.gitattributes`), because GitHub rejects files over 100 MB; a clone needs Git LFS installed to get the models rather than pointer files. Commit a model only when it changes on purpose: every committed version counts against the GitHub LFS storage quota.

The tests never change a model here: they open an isolated copy (`OpenIsolatedCopy`) and delete it afterwards. A test whose model is missing is ignored, not failed.

## Kelly fabrication test model (to be built)

Needed by the 8 Kelly-Revit-Logic-v5 types listed in [Unit Test Implementation - Kelly Tools For Revit.md](../Unit Test Implementation - Kelly Tools For Revit.md). Save it in Revit 2024 and keep it small (a few parts on one level), with:

- fabrication duct and pipe parts from a fabrication configuration (record which one, and its path on the test machine, here);
- a fabrication assembly (spool) with welded joints;
- Kelly hanger and trapeze supports, with vertical members;
- custom data values and a few materials on the parts;
- no Kelly shared parameters (the tests bind their own stubs).
