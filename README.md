# .dotileet

emileet's nixos system configurations

## setup

### fresh

assuming your system is partitioned correctly (refer to `./hosts/HOSTNAME/hardware/default.nix`):

```shell
sudo nixos-install --flake https://github.com/emileet/dotileet#HOSTNAME
```

### existing

assuming you have a flake enabled nix system:

```shell
sudo nixos-rebuild switch --flake .#HOSTNAME
```

## hosts

| hostname | description         |
| -------- | ------------------- |
| nix      | threadripper server |
| nixsrv   | vm server           |
| shodan   | primary desktop     |

## todo

- completely migrate my dots here
