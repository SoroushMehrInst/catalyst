# Rest API

## About Catalyst REST API

This api only uses ``POST`` and ``GET`` HTTP verbs. No other verb is accepted.
Some actions may only support one type of verb depending on their needs.

Preffered verbs are available in each API documentations.

## Full List Of REST Actions:
| Action | URL | Description |
| --- | --- | --- |
| [License Register](#register) | ``api/licensing/register`` | Handles registration of a license on device |
---


## Register
/api/licensing/register ``POST``

### Request info

| URL   | /api/licensing/register |
| Verb  | ``POST (only)`` |
| Accepts  | ``JSON`` |
| Format  | ``{"device_id":"USERS_DEVICE_ID_HERE", "active_code":"USERS_ACTIVATION_CODE_HERE"}`` |

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
