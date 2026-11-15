# Management Plane (Control Plane) vs. Data Plane

Security recommendation
For production, prefer Entra ID and Managed Identities, disable Shared Key authorization where supported, and issue short-lived user delegation SAS tokens when delegation is necessary.

Relevant Terraform setting:
shared_access_key_enabled = false
