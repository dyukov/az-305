## Blob upload failed despite resource-management access

### Symptom

The storage account was visible, but uploading a blob was denied.

### Investigation

Checked which identity performed the request and which roles applied.

### Cause

The identity lacked the required blob data-plane permission.

### Fix

Assigned an appropriate data role at the intended scope.

### Verification

Repeated the operation after the assignment became effective.

### Lesson

Managing a resource and accessing its data are different permissions.
