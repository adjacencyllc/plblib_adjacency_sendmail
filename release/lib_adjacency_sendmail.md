# Adjacency PL/B Sendmail Module

**Module:** lib_adjacency_sendmail
**Version:** 1.0.0  

## License

Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)  
Copyright © 2024–2026 Adjacency Global Solutions LLC

You are free to share and adapt this software provided attribution is given and derivative works are shared under the same license.

Full license: https://creativecommons.org/licenses/by-sa/4.0/

---

## Overview

The Sendmail module provides SMTP-based email sending for PL/B applications using the native `mailsend` runtime command.  
It supports:

- Plaintext SMTP
- SSL (OpenSSL)
- TLS (STARTTLS)
- Optional file attachments
- INI-driven configuration

This allows PL/B applications to send modern authenticated email without external dependencies. 

The advantage of this library over native the native `mailsend` instruction is that the library moves all of the configuration into the program's INI file and abstracts the different variations of `mailsend` into one consistent format. This means no re-compilation is required if a mailserver hostname, port, encryption type, etc. changes.

## Developer Notes

The lib_adjacency_sendmail.plc module is compiled in case-sensitive mode. The external labels are case-sensitive, regardless of whether program 

---

## Files

- `lib_adjacency_sendmail.inc` – API definitions
- `lib_adjacency_sendmail.plc` – Compiled implementation (from `sendmail.pls`)

---

## Installation

Place both files in your PL/B library path and include the header:

```plb
include "lib_adjacency_sendmail.inc"
```

This defines the SMTP record, error constants, and the external function entry.

---

## External API

```plb
SENDMAIL_SEND external "lib_adjacency_sendmail.plc;SENDMAIL"
```

---

## Sendmail Function

This function is an external, aliased as `SENDMAIL_SEND`. It takes the following parameters:

```plb
recipientAddresses   dim 2048   // required one or more valid email addresses, comma delimited
subject              dim 260    // optional subject line of the email
mailBody             dim 65535  // optional email body, limit of 65KB
attachmentList       dim 2048   // optional comma delimited list of filenames to attach
iniSection           dim 100    // optional INI section from which to retrieve server information, defaults to "sendmail"
```

### Parameters

| Parameter | Description |
|---------|-------------|
| recipientAddresses | Comma-separated email list |
| subject | Email subject |
| mailBody | Email message body |
| attachmentList | Optional file list |
| iniSection | INI section (if blank default to "sendmail") |

### Return Values

| Constant | Meaning |
|--------|--------|
| SENDMAIL_ERROR_NONE | Success |
| SENDMAIL_ERROR_FAIL | Failure (see PL/B variable S\$ERROR\$ for more information) |
| SENDMAIL_ERROR_SSL_SETTING | Invalid SSL setting |

---

## INI Configuration

The module reads SMTP settings from PL/B's INI file.

### Supported keys

| Key | Meaning | Default | Comments |
|-----|--------|--------|--------|
| hostname | SMTP server | blank | required IP address or hostname
| username | Login | blank | required SMTP username
| password | Password | blank | required SMTP password
| port | Port | 25 | required TCP/IP port number
| replyto | Reply-To | `nobody@nonsuch.com` | An optional email address in name <address@domain> format where email replies will be delivered
| sendfrom | From header | `Nonsuch System Administrator <no-reply@nonsuch.com>` | An optional email address in name <address@domain> format
| ssl | Encryption type to use | none | This setting needs to match the value expected by the SMTP server. Port 465 will generally be SSL and port 587 generally TLS
| tracelog | SMTP Trace file | none | An optional log file where SMTP communication should be appended. Useful for debugging.

### SSL Values

| Value | Behavior |
|-------|----------|
| SSL | Uses `*OpenSSL` keyword when sending email|
| TLS | Uses `*StartTLS` keyword when sending email |
| blank | Sends email with no encryption |

---

## Example INI Section

```ini
[sendmail]
hostname=smtp.example.com
username=myuser
password=secret
port=587
replyto=support@example.com
sendfrom=Support <support@example.com>
ssl=TLS
```

---

## Example Usage

```plb
    include "lib_adjacency_sendmail.inc"
recipients init "bob@example.com"
subject init "Test"
body init "Hello, email!"
attachmentFilename init "C:\temp\nonsuch_file.txt"
iniSection init "CUSTOM_SENDMAIL"
result integer 2

    // simple usage, with no attachments and using the default ini section of "sendmail"
    call SENDMAIL_SEND giving result using recipients, subject, body

    // more involved usage, with an attachment and a custom INI section
    call SENDMAIL_SEND giving result using recipients, subject, body:
                                           attachmentFilename, iniSection

```

---

## Internal Behavior

The module selects the appropriate SMTP mode based on SSL and attachments, then executes PL/B's `mailsend` command with the correct flags. S\$ERROR$ will be modified by any call to SENDMAIL_SEND. PL/B flags are NOT preserved.

---

Adjacency Global Solutions LLC