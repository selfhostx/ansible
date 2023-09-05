workflow for tagging and releasing
==================================

- edit galaxy.yml (version: x.y.z)
- git commit galaxy.yml
- optional: edit Release notes-file
- git tag -a 1.5.0
- git push --follow-tags
- login into github + draft a new release: https://github.com/selfhostx/ansible/releases
  draft a new release
  choose tag
  enter name
  generate release notes (adds link for compare between tags)
  write more description

  see: https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository
