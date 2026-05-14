## Summary

<!-- What does this change and why? -->

## Checklist

- [ ] Ensure you have bumped the `local.module_version` value in `main.tf` accordingly with semver conventions

## Release procedure

After this PR is merged, cut a release with:

```
gh release create vX.Y.Z --generate-notes
```
