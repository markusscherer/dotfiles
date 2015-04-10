import subprocess

def get_password(id):
    return decrypt(id + ".gpg")

def get_user(id):
    return decrypt(id + "-acc.gpg")

def get_host(id):
    return decrypt(id + "-host.gpg")

def decrypt(filename):
    passhome = "/home/markus/.config/credentials/"
    try:
        return subprocess.check_output(["gpg", "--use-agent", "--quiet", \
                "--decrypt", passhome + filename]).strip()
    except:
        return ""
