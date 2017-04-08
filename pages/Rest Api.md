# Rest API

## About Catalyst REST API

This api only uses ``POST`` and ``GET`` HTTP verbs. No other verb is accepted.
Some actions may only support one type of verb depending on their needs.

Preffered verbs are available in each API documentations.

## Full List Of REST Actions:
| Action | URL | Description |
| --- | --- | --- |
| [License Register](#license-register) | ``api/licensing/register`` | Handles registration of a license on device |
| [License Unregister](#license-unregister) | ``api/licensing/register`` | Handles registration of a license on device |
---


## License Register
/api/licensing/register ``POST``

Registers a license on a specific device.

### Request info

| Parameter | Info |
| --- | --- |
| URL   | /api/licensing/register |
| Verb  | ``POST (only)`` |
| Accepts  | ``application/json`` |

Format: ```json
{
    "device_id": "USERS_DEVICE_ID_HERE",
    "active_code": "USERS_ACTIVATION_CODE_HERE",
    "additional_info": [{
        "Key": "phone_number",
        "Value": "PHONE"
    }, {
        "Key": "any_other_param",
        "Value": "VALUE"
    }]
}
```

### Response info

Response content type: ``JSON``

If activation is successful (Status code 200 OK) ``is_activated`` will be true and a ``registration_id`` as a string will be provided.

If activation is unsuccessful ``is_activated`` will be false and ``err`` and ``msg`` will be provided about the error(s).

### Success Response Sample
HTTP Status code 200 (OK!)
```json
{
    "registration_id": "abcsderw123kda",
    "is_activated": true
}
```

### Unsuccessful Response Sample
```json
{
    "msg": "You are not able to activate with this code on this device!",
    "is_activated": false,
    "err": "UNABLE_TO_ACTIVATE"
}
```

---

## License Unregister
/api/licensing/unregister ``POST``

Deactivates a license from a device if possible.
This method is useful in scenarios where users need to migrate from a device.

### Request info

| Parameter | Info |
| --- | --- |
| URL   | /api/licensing/unregister |
| Verb  | ``POST (only)`` |
| Accepts  | ``application/json`` |
| Format  | ``{"device_id":"USERS_DEVICE_ID_HERE", "active_code":"USERS_ACTIVATION_CODE_HERE", "registration_id":"REGISTATION_ID_HERE"}`` |

### Response info

Response content type: ``JSON``

If activation is successful (Status code 200 OK) ``is_unregistered`` will be true and a ``registration_id`` as a string will be provided.

If activation is unsuccessful ``is_unregistered`` will be false and ``err`` and ``msg`` will be provided about the error(s).

### Success Response Sample
HTTP Status code 200 (OK!)
```json
{
    "registration_id": "abcsderw123kda",
    "is_unregistered": true
}
```

### Unsuccessful Response Sample
```json
{
    "msg": "You are not able to activate with this code on this device!",
    "is_unregistered": false,
    "err": "UNABLE_TO_DEACTIVATE"
}
```

---

## List of api errors
| Error | Description |
| ----- | ----------- |
| NOT_FOUND | The following license is not available in database. |
| UNABLE_TO_REGISTER | The device id or activation code is not valid for this register procedure. |
| UNABLE_TO_UNREGISTER | The license is not able to deactivate. it may be non deactivatable or max deactivate reached! |
