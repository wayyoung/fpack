#!/usr/bin/env bash

# Copyright (C) 2015 Red Hat, Inc. All rights reserved.
#
# This copyrighted material is made available to anyone wishing to use,
# modify, copy, or redistribute it subject to the terms and conditions
# of the GNU General Public License v.2.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

SKIP_WITH_LVMLOCKD=1
SKIP_WITHOUT_LVMETAD=1
SKIP_WITH_LVMPOLLD=1

. lib/inittest

kill "$(< LOCAL_LVMETAD)"
rm LOCAL_LVMETAD

aux prepare_devs 2

pvcreate --metadatacopies 0 "$dev1"
pvcreate --metadatacopies 1 "$dev2"
vgcreate $vg1 "$dev1" "$dev2"
lvcreate -n foo -l 1 -an --zero n $vg1

# start lvmetad but make sure it doesn't know about $dev1 or $dev2
aux disable_dev "$dev1" "$dev2"
aux prepare_lvmetad
lvs
mv LOCAL_LVMETAD XXX
aux enable_dev "$dev2" "$dev1"
mv XXX LOCAL_LVMETAD

aux lvmconf 'global/use_lvmetad = 0'
check inactive $vg1 foo
aux lvmconf 'global/use_lvmetad = 1'

pvscan --cache --background "$dev2" -aay

aux lvmconf 'global/use_lvmetad = 0'
# FIXME: inconclusive. may be a timing issue
check inactive $vg1 foo
aux lvmconf 'global/use_lvmetad = 1'

pvscan --cache --background "$dev1" -aay

aux lvmconf 'global/use_lvmetad = 0'
i=100
while ! check active $vg1 foo; do
	test $i -lt 0 && fail "Failed to autoactivate"
	sleep .1
	i=$((i-1))
done
aux lvmconf 'global/use_lvmetad = 1'

vgremove -ff $vg1
