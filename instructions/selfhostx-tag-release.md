workflow for tagging and releasing
==================================

- edit galaxy.yml (version: x.y.z)
- optional: edit Release notes
- git tag -a 1.3.0
- git push --follow-tags
- login into github + draft a new release: https://github.com/selfhostx/ansible/releases
