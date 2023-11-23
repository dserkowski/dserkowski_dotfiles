
set -e

sudo snapper -c root cleanup number
sudo snapper -c boot cleanup number
sudo snapper -c home cleanup number
sudo snapper -c root cleanup timeline
sudo snapper -c boot cleanup timeline
sudo snapper -c home cleanup timeline
echo "Snapper cleanup done"  >&2
