#import "../specification/settings.typ": *

#h1[Introduction]

*#tk* extends a restricted fragment of NetKAT with schema types and explicit policy contracts. Schema types describe packet fields, their bit widths, and constraints on their values.

The language has the following restrictions:

+ Packet fields and their bit widths are declared through schema syntax.
+ Each program begins with exactly one base schema declaration,
  which fixes the packet structure for the entire program.
  Additional schema declarations may define aliases, refinements,
  or unions of existing schemas, while preserving this structure.
+ Policies are defined through `let` bindings.
  The final expression must reference a bound policy.
+ Every policy binding must explicitly specify its input and output
  schema types.

The following is a simple example of #tk. The program classifies packets into two tenants according to their input ports. Each tenant is associated with a different VLAN identifier.

#block(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
  ```text
  schema Packet = {
      port   : Bits[16]
      tenant : Bits[2]
      vlan   : Bits[12]
  } in
  schema TenantA = Packet & { tenant == 1 vlan == 100 } in
  schema TenantB = Packet & { tenant == 2 vlan == 200 } in
  schema Classified = TenantA | TenantB in

  let classify : Packet -> Classified =
      (port ~ 10; tenant := 1; vlan := 100)
      +
      (port ~ 20; tenant := 2; vlan := 200)
  in
  classify
  ```
]

After type checking, the example translates to the following untyped NetKAT program.

#block(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
  ```text
  let port   = &x[0..16] in
  let tenant = &x[16..18] in
  let vlan   = &x[18..30] in

  let classify =
      (port ~ 10; tenant := 1; vlan := 100)
      +
      (port ~ 20; tenant := 2; vlan := 200)
  in
  classify
  ```
]
