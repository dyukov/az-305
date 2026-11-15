# Troubleshooting

## Unrecognized argument `--resource-group`:

### Symptom

What failed?

```bash
az storage container show \
  --name audit-exports \
  --account-name staz305la1589sa \
  --resource-group rg-az305-storage-lab \
  --query '{name:name,publicAccess:properties.publicAccess}' \
  -o json
```

Include the relevant error message, with sensitive values removed.

```bash
unrecognized arguments: --resource-group rg-az305-storage-lab
```

### Context

What operation was I attempting?

- `az storage container show`

Which identity and resource were involved?

- my account. Azure signed-in user with Owner role

### Hypotheses

- Possible cause: parameter is incorrect

### Investigation

1. Check performed:
   Result:
   Checked query with Claude. `--resource-group` was invalid, so I removed it

2. Check performed:
   Result:

### Confirmed cause

What evidence supports this conclusion?

### Fix

What changed?

- removed the invalid parameter

### Verification

How did I prove the fix worked?

- executed query without parameter, result was return

### Lesson

What should I remember next time?

- `--resource-group` is not a valid parameter

## Account does not have the required permissions

### Symptom

What failed?

```bash
CONTAINER_ID=$(az storage container show \
 --name audit-exports \
 --account-name staz305la1589sa \
 --auth-mode key \
 --query id -o tsv)
```

Include the relevant error message, with sensitive values removed.

```bash
You do not have the required permissions needed to perform this operation.
Depending on your operation, you may need to be assigned one of the following roles:
    "Storage Blob Data Owner"
    "Storage Blob Data Contributor"
    "Storage Blob Data Reader"
    "Storage Queue Data Contributor"
    "Storage Queue Data Reader"
    "Storage Table Data Contributor"
    "Storage Table Data Reader"

If you want to use the old authentication method and allow querying for the right account key, please use the "--auth-mode" parameter and "key" value.
```

### Context

What operation was I attempting?

- `az storage container show`

Which identity and resource were involved?

- my own. Azure signed-in user with Owner role

### Hypotheses

- Possible cause: Account does not have the required permissions

### Investigation

1. Check performed:
   Result:
   Checked the error message. There was a hint provided

   ```bash
   There are no credentials provided in your command and environment, we will query for account key for your storage account.
   It is recommended to provide --connection-string, --account-key or --sas-token in your command as credentials.
   You also can add `--auth-mode login` in your command to use Azure Active Directory (Azure AD) for authorization if your login account is assigned required RBAC roles.
   For more information about RBAC roles in storage, visit https://learn.microsoft.com/azure/storage/common/storage-auth-aad-rbac-cli.
   In addition, setting the corresponding environment variables can avoid inputting credentials in your command. Please use --help to get more information about environment variable usage.
   ```

2. Check performed:
   Result:

### Confirmed cause

What evidence supports this conclusion?

- Error fixing hint

### Fix

What changed?

- used another parameter `--auth-mode key`

### Verification

How did I prove the fix worked?

- executed query with parameter `--auth-mode key`. File was uploaded successfully

### Lesson

What should I remember next time?

- Check the logs! Dont trust the ChatGPT fucker

## No credentials provided in your command and environment

### Symptom

What failed?

```bash
CONTAINER_ID=$(az storage container show \
  --name audit-exports \
  --account-name staz305la1589sa \
  --auth-mode key \
  --query id -o tsv)
```

Include the relevant error message, with sensitive values removed.

```bash
WARNING:
There are no credentials provided in your command and environment, we will query for account key for your storage account.
It is recommended to provide --connection-string, --account-key or --sas-token in your command as credentials.

You also can add `--auth-mode login` in your command to use Azure Active Directory (Azure AD) for authorization if your login account is assigned required RBAC roles.
For more information about RBAC roles in storage, visit https://learn.microsoft.com/azure/storage/common/storage-auth-aad-rbac-cli.

In addition, setting the corresponding environment variables can avoid inputting credentials in your command. Please use --help to get more information about environment variable usage.
```

### Context

What operation was I attempting?

- `az storage container show`

Which identity and resource were involved?

- My own. Owner

### Hypotheses

- Possible cause: parameter is incorrect or USER_ID environment variable is empty

### Investigation

1. Check performed: `printenv CONTAINER_ID`
   Result: Empty

2. Check performed: `printenv USER_ID`
   Result: Empty

3. Check performed: `echo $USER_ID`
   Result: Empty

### Confirmed cause

What evidence supports this conclusion?

- `echo $CONTAINER_ID returns empty. echo USER_ID is filled correctly`

### Fix

What changed?

- Used `echo` instead of `printenv`, USER_ID is set correctly
  However CONTAINER_ID is still empty

- Used the following script

```bash
STORAGE_ID=$(az storage account show \
  --name staz305la1589sa \
  --resource-group rg-az305-storage-lab \
  --query id -o tsv)

CONTAINER_SCOPE="$STORAGE_ID/blobServices/default/containers/audit-exports"
```

### Verification

How did I prove the fix worked?

- command returned the message that assignment was done

### Lesson

What should I remember next time?

- `az storage container show` uses Resource name for `--name` parameter
