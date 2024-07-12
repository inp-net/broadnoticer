# Broadnoticer

Petit outil à la con pour facilement créer des notices pour prévenir de maintenance ou ce genre de choses sur tout nos services d'un coup. Fait avec [Gleam](https://gleam.run)

## Services supportés

- [ ] Gitlab: https://docs.gitlab.com/ee/api/broadcast_messages.html
- [ ] Churros: https://api-docs.churros.inpt.fr/announcements/#mutation/upsertAnnouncement
- [ ] Loca7: var d'env sur le déployment, soit via k8s soit je fais un truc plus propre
- [ ] TDB: à voir si c possible avec ghislain
- [ ] uptime kuma: https://uptime-kuma-api.readthedocs.io/en/latest/api.html#uptime_kuma_api.UptimeKumaApi.post_incident; à voir si on passe pas par https://github.com/MedAziz11/Uptime-Kuma-Web-API (flemme de faire un n-ième projet en python...)
- [ ] Matrix: si seulement on pouvait pin des messages... Pour le moment dcp un bot qui poste sur tt nos channels

## Image docker

Dispo à [uwun/broadnoticer](https://hub.docker.com/r/uwun/broadnoticer)

## Compilation

```sh
git clone ...
gleam run -m gleescript
```

## Usage

Docs TBD

## Développement

```sh
gleam run # pour lancer
```
