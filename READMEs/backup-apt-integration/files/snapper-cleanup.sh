
set -e

snapper -c root cleanup number
snapper -c boot cleanup number
snapper -c home cleanup number
snapper -c root cleanup timeline
snapper -c boot cleanup timeline
snapper -c home cleanup timeline
echo "Snapper cleanup done"  >&2
