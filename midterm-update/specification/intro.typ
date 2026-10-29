#import "../specification/settings.typ": *

#h1[Introduction]

#tk is an extension of NetKAT for describing packet structures and checking
policy contracts. Packet types specify the fields of a packet, their bit widths,
and constraints on their values. A packet type without additional constraints
plays the role of a schema. More specific packet types are constructed using
intersection (#raw("&")) and union (#raw("|")), so schemas and refined packets
share a single declaration form.

The following example classifies packets into two tenants according to their
input ports. Each tenant is associated with a different VLAN identifier.

#block(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
  ```text
  packet Packet = {
      port   : Bits[16]
      tenant : Bits[2]
      vlan   : Bits[12]
  };
  packet TenantA = Packet & { tenant == 1 vlan == 100 };
  packet TenantB = Packet & { tenant == 2 vlan == 200 };
  packet Classified = TenantA | TenantB;

  let classify : Packet -> Classified =
      (port ~ 10; tenant := 1; vlan := 100)
      +
      (port ~ 20; tenant := 2; vlan := 200)
  in
  classify
  ```
]

The policy assigns tenant 1 and VLAN 100 to packets arriving at port 10, and
tenant 2 and VLAN 200 to packets arriving at port 20. Other packets are dropped.
The type #raw("Classified") preserves the relationship between the tenant and
VLAN fields: it permits the two declared combinations rather than arbitrary
combinations of their field values.

The contract #raw("Packet -> Classified") requires every output produced from
an input of type #raw("Packet") to satisfy #raw("Classified"). It does not require
an output for every input. Under this interpretation, the policy
#raw("classify; vlan := 200") violates the same contract because it can produce
an output with tenant 1 and VLAN 200. The type system is intended to detect such
violations before compilation.
