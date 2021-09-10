#!/usr/bin/env bash
#
# Custom Palenight color scheme for Gnome Terminal


UUID=`uuidgen`
PROFILE_NAME="palenight"
DCONF_LEGACY="/org/gnome/terminal/legacy"
DCONF_LEGACY_PROFILE="$DCONF_LEGACY/profiles:/:$UUID"

dset() {
    local key="$1"; shift
    local val="$1"; shift

    dconf write "$DCONF_LEGACY_PROFILE/$key" "$val"
}

# Set custom key bindings
dconf write "$DCONF_LEGACY/keybindings/new-tab" "'<Alt>t'"

# Set profile values with theme options
dset visible-name "'$PROFILE_NAME'"

dset use-theme-colors "false"
dset palette "['#292d3e', '#f07178', '#c3e88d', '#ffcb6b', '#82aaff', '#c792ea', '#89ddff', '#d0d0d0', '#434758', '#ff8b92', '#ddffa7', '#ffe585', '#9cc4ff', '#e1acff', '#a3f7ff', '#ffffff']"
dset background-color "'#292d3e'"
dset foreground-color "'#ffffff'"
dset bold-color "'#ffffff'"
dset bold-color-same-as-fg "true"

dset cursor-colors-set "true"
dset cursor-background-color "'#FDF300'"
dset cursor-foreground-color "'#FDF300'"

dset use-theme-background "false"
dset background-transparency-percent 4

dset font "'JetBrains Mono 10'"
dset use-system-font "false"

dset scrollback-lines 20000
dset scrollbar-policy "'never'"


# Add profile to list and set as default
dconf write "$DCONF_LEGACY/profiles:/list" "['$UUID']"
dconf write "$DCONF_LEGACY/profiles:/default" "'$UUID'"

unset UUID
unset PROFILE_NAME
unset DCONF_LEGACY
unset DCONF_LEGACY_PROFILE
