# .dotileet

my nixos system configurations

## setup

assuming you have a flake enabled nix system, you can run the following command while specifying a target host:

```shell
sudo nixos-rebuild switch --flake .#HOSTNAME
```

## hosts

| hostname  | description                  |
| --------- | ---------------------------- |
| nix       | my main threadripper desktop |

## todo

- actually migrate my dots here (home-manager maybe?)
- clean up hosts directory
