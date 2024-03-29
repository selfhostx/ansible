# Contribution guidelines

**Table of contents**

- [Contribution guidelines](#contribution-guidelines)
  * [Contributing](#contributing)
  * [Coding guidelines](#coding-guidelines)
    + [Zabbix roles](#zabbix-roles)
    + [Zabbix modules](#zabbix-modules)
  * [Testing and Development](#testing-and-development)
    + [Testing Zabbix roles](#testing-zabbix-roles)
    + [Testing Zabbix modules](#testing-zabbix-modules)
- [Additional information](#additional-information)
  * [Virtualenv](#virtualenv)
  * [Links](#links)

Thank you very much for taking time to improve this Ansible collection. We appreciate your every contribution. Please make sure you are familiar with the content presented in this document to avoid any delays during reviews or merge.

Please note that this project is released with following codes of conduct and by participating in the project you agree to abide by them:
* [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md)
* [Community Code of Conduct](https://docs.ansible.com/ansible/devel/community/code_of_conduct.html)

If you are interested in joining us as a maintainer, please open an issue.

## Contributing

1. Fork this repository
2. Create a new branch and apply your changes to it. In addition to that:
    1. Ensure that any changes you introduce to this collection are reflected in the documentation.
    2. Ensure that your PR contains valid [changelog fragment](https://docs.ansible.com/ansible/devel/community/development_process.html#changelogs).
    3. Include tests with your contribution to ensure that future pull requests will not break your functionality.
    4. Make sure that tests succeed.
3. Push the branch to your forked repository.
4. Submit a new pull request into this collection.

*Notes:*
* Pull requests that fail during the tests will not be merged. If you have trouble narrowing down cause of a failure and would like some help, do not hesitate to ask for it in comments.
* If you plan to propose an extensive feature or breaking change, please open an issue first. This allows collection maintainers to comment on such change in advance and avoid possible rejection of such contribution.

## Coding guidelines

Style guides are important because they ensure consistency in the content, look, and feel of a book or a website. Any contributions to this collection must adhere to the following rules:

* [Ansible style guide](http://docs.ansible.com/ansible/latest/dev_guide/style_guide/).
* Use "Ansible" when referring to the product and ``ansible`` when referring to the command line tool, package and so on.

### Roles

* Playbooks should be written in multi-line YAML format using ``key: value``.
  * The form ``key=value`` is suitable for ``ansible`` ad-hoc execution, not for ``ansible-playbook``.
* Every task should always have a ``name:`` keyword associated with it.

## Testing and Development

2DO

# Additional information

## Virtualenv

It is recommended to use virtualenv for development and testing work to prevent any conflicting dependencies with other projects.

A few resources describing virtualenvs:

* http://thepythonguru.com/python-virtualenv-guide/
* https://realpython.com/python-virtual-environments-a-primer/
* https://www.dabapps.com/blog/introduction-to-pip-and-virtualenv-python/

## Links

* [Ansible](https://www.ansible.com/)
* [Ansible style guide](http://docs.ansible.com/ansible/latest/dev_guide/style_guide/)
* [Ansible module best practices](https://docs.ansible.com/ansible/devel/dev_guide/developing_modules_best_practices.html)
* [Integration testing with `ansible-test`](https://docs.ansible.com/ansible/latest/dev_guide/testing_integration.html)
* [Docker installation guide](https://docs.docker.com/install/)
* [Molecule](https://molecule.readthedocs.io/)
* [Molecule V2 with your own role](https://werner-dijkerman.nl/2017/09/05/using-molecule-v2-to-test-ansible-roles/)
* [dj-wasabi/ansible-ci-base](https://github.com/dj-wasabi/ansible-ci-base)
* [Current Zabbix releases](https://www.zabbix.com/life_cycle_and_release_policy)

**End note**: Have fun making changes. If a feature helps you, others may find it useful as well and we will be happy to merge it.
