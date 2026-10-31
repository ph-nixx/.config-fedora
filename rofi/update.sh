#!/usr/bin/env bash
# System update, run in a terminal from the Update option in $mod+space.
# dnf, then make sure the NVIDIA driver is built for the newest kernel
# (rebooting before it is can leave you without graphics), then flatpak,
# then offer a reboot if one is needed.
set -u

echo "==> Updating system packages"
if ! sudo dnf upgrade --refresh; then
    read -rp "dnf failed. Press Enter to close."
    exit 1
fi

echo
echo "==> Making sure the NVIDIA driver is built for the newest kernel"
newest=$(rpm -q kernel --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' | sort -V | tail -1)
sudo akmods --kernels "$newest"
if modinfo -k "$newest" nvidia >/dev/null 2>&1; then
    echo "NVIDIA driver ready for $newest"
    driver_ok=1
else
    echo "WARNING: NVIDIA driver is NOT built for $newest. Don't reboot yet."
    driver_ok=0
fi

echo
echo "==> Updating Flatpak apps"
flatpak update -y

echo
# dnf5: exits 1 when a reboot is needed.
# The window closes on its own unless something needs your attention.
if dnf needs-restarting >/dev/null 2>&1; then
    exit 0
elif (( driver_ok )); then
    read -rp "Done. A reboot is recommended. Reboot now? [y/N] " answer
    [[ $answer == [yY] ]] && systemctl reboot
    exit 0
else
    read -rp "Done, but fix the NVIDIA driver before rebooting. Press Enter to close."
fi
