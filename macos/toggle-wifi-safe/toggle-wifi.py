#!/usr/bin/env python3
import argparse
import os
import re
import shutil
import subprocess
from datetime import datetime
from pathlib import Path


STATE_FILE = Path('/tmp/toggle-wifi_prev_eth_conn')
LOG_FILE = Path.home() / 'Library' / 'Logs' / 'safe-toggle-wifi.log'


def log_message(message: str) -> None:
    timestamp = datetime.now().astimezone().isoformat(timespec='seconds')
    formatted_message = f'{timestamp} {message}'
    print(formatted_message, flush=True)

    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    with LOG_FILE.open('a', encoding='utf-8') as handle:
        handle.write(formatted_message + '\n')


def command_exists(name: str) -> bool:
    return shutil.which(name) is not None


def run_command(args: list[str], check: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(args, check=check, capture_output=True, text=True)


def notifyready(title: str = 'Ready') -> None:
    if command_exists('terminal-notifier'):
        run_command([
            'terminal-notifier',
            '-title',
            title,
            '-message',
            '',
            '-sound',
            'Bottle',
        ], check=False)


def notifyerror(title: str = 'Error!') -> None:
    if command_exists('osascript'):
        run_command(['osascript', '-e', 'say "error"'], check=False)
    if command_exists('terminal-notifier'):
        run_command([
            'terminal-notifier',
            '-title',
            title,
            '-message',
            '',
            '-sound',
            'Submarine',
        ], check=False)


def parse_devices() -> list[dict[str, str]]:
    regex_devices = r'^\(Hardware Port: ([A-Za-z0-9\.\-\/ ]+), Device: (en\d+)\)$'
    regex_device_status = r'\tstatus: (inactive|active)$'

    result = run_command(['networksetup', '-listnetworkserviceorder'])
    devices: list[dict[str, str]] = []

    for line in result.stdout.splitlines():
        device_match = re.match(regex_devices, line)
        if not device_match:
            continue

        name, device = device_match.groups()
        try:
            ifconfig = run_command(['ifconfig', device]).stdout.splitlines()
        except subprocess.CalledProcessError as err:
            if f'interface {device} does not exist' not in (err.stdout or '') + (err.stderr or ''):
                raise
            continue

        status_match = next(
            (match for line in reversed(ifconfig) if (match := re.match(regex_device_status, line))),
            None,
        )
        if not status_match:
            continue

        devices.append(
            {
                'name': name,
                'device': device,
                'status': status_match.group(1),
                'type': 'wifi' if re.match(r'wi\-?fi', name, re.IGNORECASE) else 'ethernet',
            }
        )

    return devices


def set_wifi_power(device: str, power: str, dry_run: bool = False) -> None:
    command = f'networksetup -setairportpower {device} {power}'
    if dry_run:
        log_message(f'[dry-run] would run: {command}')
        return

    log_message(f'Running: {command}')
    run_command(['networksetup', '-setairportpower', device, power])
    log_message(f'Completed: {command}')


def write_state(eth_conn: bool, dry_run: bool = False) -> None:
    action = 'touch' if eth_conn else 'remove'
    if dry_run:
        log_message(f'[dry-run] would {action} state file: {STATE_FILE}')
        return

    if eth_conn:
        STATE_FILE.touch()
    else:
        STATE_FILE.unlink(missing_ok=True)

    log_message(f'Completed state file action: {action} {STATE_FILE}')


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Toggle Wi-Fi based on Ethernet connectivity.')
    parser.add_argument('--dry-run', action='store_true', help='Print planned actions without changing Wi-Fi state.')
    parser.add_argument(
        '--print-plist',
        action='store_true',
        help='Print a launchd plist with the absolute path to the safe/toggle-wifi wrapper.',
    )
    return parser.parse_args()


def print_plist() -> None:
    script_path = Path(__file__).resolve().with_name('toggle-wifi')
    plist_path = Path(__file__).resolve().with_name('service.plist')
    content = plist_path.read_text(encoding='utf-8').replace('__SAFE_TOGGLE_WIFI_PATH__', str(script_path))
    print(content)


def main() -> int:
    args = parse_args()

    if args.print_plist:
        print_plist()
        return 0

    try:
        log_message(f'Starting Wi-Fi toggle check (dry_run={args.dry_run})')
        devices = parse_devices()
        log_message(f'Detected interfaces: {devices}')

        prev_eth_conn = STATE_FILE.is_file()
        active_ethernet = [x for x in devices if x['status'] == 'active' and x['type'] == 'ethernet']
        active_wifi = [x for x in devices if x['status'] == 'active' and x['type'] == 'wifi']
        inactive_wifi = [x for x in devices if x['status'] == 'inactive' and x['type'] == 'wifi']

        eth_conn = bool(active_ethernet)
        wifi_conn = bool(active_wifi)
        log_message(
            f'Connectivity: previous_ethernet={prev_eth_conn}, active_ethernet={active_ethernet}, '
            f'active_wifi={active_wifi}, inactive_wifi={inactive_wifi}'
        )

        if not prev_eth_conn and eth_conn and wifi_conn:
            log_message('Action: Ethernet connected while Wi-Fi is active; turning Wi-Fi off.')
            for dev in active_wifi:
                set_wifi_power(dev['device'], 'off', dry_run=args.dry_run)
            if args.dry_run:
                log_message('[dry-run] would send Wi-Fi disabled notification.')
            else:
                notifyready('Ethernet connected — Wi-Fi turned off')
                log_message('Sent Wi-Fi disabled notification.')
        elif prev_eth_conn and not eth_conn and not wifi_conn and inactive_wifi:
            log_message('Action: Ethernet disconnected while Wi-Fi is off; turning Wi-Fi on.')
            set_wifi_power(inactive_wifi[0]['device'], 'on', dry_run=args.dry_run)
            if args.dry_run:
                log_message('[dry-run] would send Wi-Fi enabled notification.')
            else:
                notifyready('Ethernet disconnected — Wi-Fi turned on')
                log_message('Sent Wi-Fi enabled notification.')
        else:
            log_message('No Wi-Fi change required: no eligible Ethernet/Wi-Fi state transition was detected.')

        write_state(eth_conn, dry_run=args.dry_run)
        log_message('Wi-Fi toggle check completed successfully.')
        return 0
    except Exception as exc:
        log_message(f'Error: {exc!r}')
        if args.dry_run:
            log_message('[dry-run] would send failure notification.')
        else:
            notifyerror('toggle-wifi failed')
        raise


if __name__ == '__main__':
    raise SystemExit(main())
