Ansible-Rolle für postfix (ab Version 2.3) mit den Aufgaben:
- eines mailrelays (mails für interne Systeme)
- "Satelliten"-Systeme die nur zum mailrelay gehen aber keine Zugangsdaten für mail-Accounts mail-servern haben


Die folgenden Rollen wurden aus Ausgangsbasis genommen:
- https://galaxy.ansible.com/geerlingguy/postfix
- https://github.com/Oefenweb/ansible-postfix


Implementiert wurden:

- Testmail (kann mit extra vars -e "postfix_send_test_mail=true" fallweise aktiviert werden)

- relayhost = 
	domain (MX, dann A-Record )
	oder [1.2.3.4]
	-> http://www.postfix.org/postconf.5.html#relayhost

- mydestination = no.local.destination
	deb9: mydestination = $myhostname, postfix-mta-deb9, localhost.localdomain, , localhost"
	centos7: mydestination = $myhostname, localhost.$mydomain, localhost


- hostname - sollte mit defaults funktionieren wenn im Host richtig gesetzt, aber Warnung als task eingefügt 
	 reject_non_fqdn_sender http://www.postfix.org/postconf.5.html#reject_non_fqdn_sender

	hostname --domain

- smarthost auth:

	smtp_sasl_auth_enable
	smtp_sasl_password_maps = hash:/etc/postfix/smtp_auth

	task:
	- name: configure sasl username/password
	[...]
	https://github.com/Oefenweb/ansible-postfix/blob/master/tasks/main.yml

	SASL-Auth am Relay 

  -> Client-Sicht:
	smtp_sasl_auth_enable = yes
	smtp_sasl_password_maps = hash:/etc/postfix/smtp_auth
	+ postmap

  -> Server-Sicht (FIXME noch nicht implementiert!)

  # ein mögliche Konfiguration:

  # vor v2.10:
  # smtpd_recipient_restrictions =
  # seit 2.10
  smtpd_relay_restrictions =

	# unclean mails
	reject_non_fqdn_sender,
	reject_non_fqdn_recipient,
	reject_unknown_sender_domain,
	reject_unknown_recipient_domain,

	# our users
	permit_sasl_authenticated,
	permit_mynetworks,

	# check for existing relay-destination
	# prevent "550 You must log in to send mail..."-Messages with transports+auth
	reject_unverified_recipient,

	# make Mailbackup (MX 20) possible:
	permit_mx_backup,

	# block all other relaying FIXME
	reject_unauth_destination,

	# permit the rest
	permit


- SSL: teilweise implementiert. Nur auf oportunistic-Ebene ausgehend (kein verify)

	ipmlementierte Optionen von Postfix:

	# enable STARTTLS outgoing (früher smtp_use_tls):
	smtp_tls_security_level=may
	# enable STARTTLS incoming (früher smtpd_use_tls):
	smtpd_tls_security_level=may

	smtpd_tls_received_header = yes

	# TLS parameters (certs/keys in pem-format):
	smtpd_tls_cert_file= /etc/postfix/HOST.crt
	smtpd_tls_key_file= /etc/postfix/HOST.key
	smtpd_tls_CAfile= /etc/postfix/HOST.fullchain

- die Idee der postfix_raw_options aus https://github.com/Oefenweb/ansible-postfix/blob/master/templates/etc/postfix/main.cf.j2 ist nicht schlecht, dann aber Umsetzung via template.
  Aktuell find ich ich die Beibehaltung der Standard-optionen der Distribution nicht schlecht, wobei sich dabei Ungereimheiten ergeben könnten.
