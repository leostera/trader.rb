# Trader
> Trade slaves between Jenkins Instances

```
λ rb acquire_slaves.rb --help move

  NAME:

    move

  DESCRIPTION:

    No description.

  OPTIONS:

    --label NAME
        The label to add to this nodes

    --jenkins URL
        The url of the jenkins instance to associate this slaves with

    --username NAME
        Username to login with

    --token TOKEN
        Token to login with

    --fqdn FQDN
        Domain Suffix (<slave-name>.some.internal.domain)

    --port PORT
        Port to connect to (22)

    --mode MODE
        NORMAL or EXCLUSIVE
```
