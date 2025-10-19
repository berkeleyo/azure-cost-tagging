# ARCHITECTURE

## Control Plane

- **Policy Definitions**:
  - *Require Tags*: Ensures specific tag keys exist on resources.
  - *Inherit Tags*: Uses `Modify` effects to copy tags from the Resource Group or parameters.
- **Initiative (Policy Set)**:
  - Bundles require + inherit, parameterized for tag keys and inheritance precedence.
- **Assignments**:
  - Scoped at Management Group for broad coverage; Subscription for exceptions/pilots.

## Data Plane

- **Resources** carry consistent tags:
  - `costCenter`, `owner`, `env`, `service`, `businessUnit`, `retention`.
- **Reporting**:
  - Azure Cost Management and FinOps tools consume tags for showback/chargeback.

## Operational Flows

- **Change**: Audit → Modify → Deny with comms and exemptions.
- **Exceptions**: Time-bound policy exemptions; tracked and reviewed.
