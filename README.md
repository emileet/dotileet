# .dotileet

my nixos system configurations

## setup

assuming you have a flake enabled nix system, you can run the following command while specifying a target host:

```shell
sudo nixos-rebuild switch --flake .#HOSTNAME
```

## hosts

| hostname | description         |
| -------- | ------------------- |
| nix      | threadripper server |
| shodan   | primary desktop     |

## todo

- completely migrate my dots here
