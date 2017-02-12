REPO=repo
CMD=gnuradio
APP=org.gnuradio.Base
MANIFEST=$(APP).json

all: build bundle

clean:
	rm -rf app repo
	rm -f $(APP).flatpak

build:
	flatpak-builder --ccache --force-clean                                 --repo=$(REPO) --subject="git-`git log --pretty=format:'%h' -n 1`" app $(MANIFEST)

build-inc: clean
	flatpak-builder --ccache --keep-build-dirs --disable-updates --verbose --repo=$(REPO) --subject="git-`git log --pretty=format:'%h' -n 1`" app $(MANIFEST)

bundle:
	flatpak build-bundle $(REPO) $(APP).flatpak $(APP)

install:
	flatpak build-update-repo --prune --prune-depth=20 $(REPO)
	flatpak --user remote-add --no-gpg-verify --if-not-exists $(CMD)-local $(REPO)
	flatpak --user --verbose install $(CMD)-local $(APP)

uninstall:
	flatpak --user --verbose install $(CMD)-local $(APP)

update:
	flatpak update --user $(APP)

run-repo:
	flatpak run $(APP)

run-repo-gdb:
	flatpak run --devel --command='sh' $(APP)

run-builder:
	flatpak-builder --run app $(APP).json $(CMD)

run-builder-gdb:
	flatpak-builder --run ---allow=devel app $(MANIFEST) gdb $(CMD)

remotes:
	flatpak remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo --if-not-exists

deps:
	flatpak install $(ARGS) gnome org.freedesktop.Platform//1.4
	flatpak install $(ARGS) gnome org.freedesktop.Sdk//1.4
