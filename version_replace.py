import subprocess

def main():
    cmd_get_current_tag = "git describe --tags"
    cmd_get_base_master = "git rev-parse --short FETCH_HEAD"
    subprocess.call('git fetch origin master'.split())

    current_tag = subprocess.check_output(cmd_get_current_tag.split()).decode('utf-8').strip()
    base_master = subprocess.check_output(cmd_get_base_master.split()).decode('utf-8').strip()

    if len(current_tag) == 0:
        current_tag = 'v0.0.0'

    with open('utils/version.h') as f:
        fix_header = list(
            map(lambda x: x.replace('v0.0.0_0000000', '{}_{}'.format(current_tag, base_master)),
                [s for s in f]))

    with open('utils/version.h', 'w') as f:
        f.writelines(fix_header)


if __name__ == '__main__':
    main()
