import subprocess
import time
import random
import sys

# Terminal colors
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
MAGENTA = "\033[95m"
RESET = "\033[0m"
BOLD = "\033[1m"

spinner_cycle = ['|', '/', '-', '\\'] 

def slow_print(text, delay=0.012):  # Delay kam kiya
    for char in text:
        print(char, end='', flush=True)
        time.sleep(delay)
    print()

def spinner(seconds):
    end_time = time.time() + seconds
    idx = 0
    while time.time() < end_time:
        print(f"\r{MAGENTA}Processing {spinner_cycle[idx % len(spinner_cycle)]}{RESET}", end='', flush=True)
        idx += 1
        time.sleep(0.07)  # thoda tez
    print("\r", end='', flush=True)

def fake_progress_bar():
    bar_length = 30
    for i in range(bar_length + 1):
        percent = int((i / bar_length) * 100)
        bar = '=' * i + ' ' * (bar_length - i)
        print(f"\r{CYAN}Accessing dark web nodes... [{bar}] {percent}%", end='', flush=True)
        time.sleep(random.uniform(0.01, 0.03))  # delay kaafi kam kiya
    print(RESET)

def hacking_jargon():
    phrases = [
        "Bypassing firewall...",
        "Decrypting payload...",
        "Injecting backdoor...",
        "Extracting session keys...",
        "Spoofing IP headers...",
        "Evading IDS detection...",
        "Compiling exploit code...",
        "Harvesting credentials...",
        "Dumping memory segments...",
        "Accessing root shell..."
    ]
    phrase = random.choice(phrases)
    slow_print(f"{YELLOW}{phrase}", 0.025)  # thoda tez print
    spinner(0.8)  # spinner time kam

def get_ip():
    try:
        result = subprocess.check_output(['curl', '-s', 'checkip.amazonaws.com'])
        return result.decode('utf-8').strip()
    except Exception:
        return None

def whois(ip):
    try:
        result = subprocess.check_output(['whois', ip], stderr=subprocess.DEVNULL)
        return result.decode('utf-8').strip()
    except Exception:
        return None

def extract_isp_descr(ip, whois_info):
    if ip == "122.168.122.16":
        for line in whois_info.splitlines():
            if 'Airtel' in line or 'Bharti' in line or 'airtel' in line.lower():
                if line.lower().startswith('descr:'):
                    return line[6:].strip()
        descr_lines = [line[6:].strip() for line in whois_info.splitlines() if line.lower().startswith('descr:')]
        return descr_lines[0] if descr_lines else "Unknown owner"
    else:
        descr_lines = [line[6:].strip() for line in whois_info.splitlines() if line.lower().startswith('descr:')]
        return descr_lines[0] if descr_lines else "Unknown owner"

def print_warning():
    warnings = [
        "!!! ALERT: INTRUSION DETECTED !!!",
        "!!! WARNING: TRACEBACK IN PROGRESS !!!",
        "!!! CRITICAL: FIREWALL BREACH !!!",
        "!!! SYSTEM ALERT: ROOT ACCESS OBTAINED !!!",
        "!!! SECURITY ALERT: UNAUTHORIZED ACCESS !!!"
    ]
    warn = random.choice(warnings)
    print(f"{RED}{BOLD}{warn}{RESET}")
    time.sleep(0.4)  # kam time

def print_ip_company_table(ip_list, company_list):
    print(f"{BOLD}{CYAN}{'IP Address':<20} | {'Company Name':<50}{RESET}")
    print(f"{CYAN}{'-'*20}-+-{'-'*50}{RESET}")
    for ip, comp in zip(ip_list, company_list):
        print(f"{ip:<20} | {comp:<50}")

def main():
    slow_print(f"{YELLOW}Initializing ultra-secure dark web gateway...", 0.03)
    spinner(1)  # kam time
    fake_progress_bar()
    slow_print(f"{GREEN}Gateway access granted. Commencing IP extraction...\n", 0.03)

    ips = []
    attempt = 0
    while len(set(ips)) < 3:
        attempt += 1
        slow_print(f"{CYAN}[Attempt {attempt}] Querying dark web nodes for IP...", 0.02)
        hacking_jargon()
        ip = get_ip()
        if ip:
            if ip not in ips:
                slow_print(f"{GREEN}>>> New compromised IP identified: {ip}", 0.02)
                ips.append(ip)
            else:
                slow_print(f"{YELLOW}>>> Duplicate IP detected: {ip} (discarded)", 0.02)
        else:
            slow_print(f"{RED}>>> ERROR: Unable to retrieve IP data!", 0.02)

        if random.random() < 0.25:
            print_warning()

    unique_ips = list(set(ips))
    slow_print(f"\n{GREEN}Dark web scan complete: {len(unique_ips)} target IPs located!\n", 0.03)

    companies = []
    for idx, ip in enumerate(unique_ips, 1):
        slow_print(f"{CYAN}--- Target #{idx}: {ip} ---", 0.03)
        slow_print(f"{YELLOW}Extracting WHOIS info...", 0.02)
        hacking_jargon()
        info = whois(ip)
        if info:
            owner_info = extract_isp_descr(ip, info)
            companies.append(owner_info)
            print(f"{GREEN}Owner: {owner_info}")
        else:
            companies.append("WHOIS info unavailable")
            slow_print(f"{RED}WHOIS info unavailable for {ip}", 0.02)
        print()

    print(f"\n{BOLD}{MAGENTA}Summary of Extracted IPs and Companies:{RESET}\n")
    print_ip_company_table(unique_ips, companies)

    slow_print(f"{YELLOW}Finalizing operation. Covering tracks...", 0.03)
    spinner(1)
    slow_print(f"{RED}{BOLD}Operation complete. Disconnecting and wiping logs...{RESET}", 0.03)

if __name__ == "__main__":
    main()
