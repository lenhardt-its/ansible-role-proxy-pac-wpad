# Ansible Role: pac-file

## Description

Install and configure proxy.pac using ansible.

Requires ansible-role-caddyserver

## Requirements

- Ansible >= 2.5 (It might work on previous versions, but we cannot guarantee it)

## Role Variables

All variables which can be overridden are stored in [defaults/main.yml](defaults/main.yml) file as well as in table below.

| Name           | Default Value | Description                        |
| -------------- | ------------- | -----------------------------------|
| `pac_caddy_user` | caddy | Caddy user |
| `pac_caddy_group` | caddy | Caddy group |
| `pac_webroot` | /var/www | Caddy Webroot folder (you can define custom in ansible-role-caddyserver) |
| `pac_file_save_path` | /var/www/proxy.pac | PAC-File save Path |

## Example

```yaml
---
# Define proxy servers with variables in playbooks
pac_file_proxys:
  - name: proxy-internal
    address: "192.168.1.10:3128"
  - name: proxy-external
    address: "192.168.2.10:3128"
# Define pac-file rules.
# You musst escape the `"` inside single quotes for the pac-file generating script
pac_file_rules:
  # Go direct for defines networks
  - name: '\"169.254.0.0\", \"255.255.0.0\"'
    type: "isInNet"
    return: direct
  - name: '\"172.16.0.0\", \"255.240.0.0\"'
    type: "isInNet"
    return: direct
  - name: '\"192.168.0.0\", \"255.255.0.0\"'
    type: "isInNet"
    return: direct
  - name: '\"10.60.0.0\", \"255.252.0.0\"'
    type: "isInNet"
    return: direct
  - name: '\"10.201.0.0\", \"255.255.0.0\"'
    type: "isInNet"
    return: direct
  - name: '\"fe80:*\"'
    type: "shExpMatch"
    return: direct
  - name: '\"fc00:*\"'
    type: "shExpMatch"
    return: direct
  # Go over proxy-internal for intranet
  - name: '\"company.lan\"'
    type: "shExpMatch"
    return: proxy-internal
  # Go over proxy-external for others
  - name: '\"vimeo.com\"'
    type: "shExpMatch"
    return: proxy-external
  - name: '\"*.vimeo.com\"'
    type: "shExpMatch"
    return: proxy-external
  - name: '\"github.com\"'
    type: "shExpMatch"
    return: proxy-external
```

### Playbook

```yaml
---
- hosts: all
  roles:
  - ansible-role-pac
```

## Contributing

See [contributor guideline](CONTRIBUTING.md).

## License

This project is licensed under MIT License. See [LICENSE](/LICENSE) for more details.
