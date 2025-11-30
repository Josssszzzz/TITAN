#!/bin/bash

# ============================================================
# TITAN ULTIMATE - Full Spectrum Vulnerability Scanner
# Target: CVEs, Misconfigs, Secrets & Logic
# Author: Jose Eduardo (Modified version)
# ============================================================

DOMAIN=$1
DATE=$(date +%F)
WORKSPACE="titan_${DOMAIN}_${DATE}"

# Colores (Estilo Cyberpunk)
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

logo(){
echo -e "${RED}"
echo "  _______ _____ _______ _    _   _ "
echo " |__   __|_   _|__   __| |  | \ | |"
echo "    | |    | |    | |  | |  |  \| |"
echo "    | |    | |    | |  | |  | . \ |"
echo "    |_|   _| |_   |_|  |_|  |_|\__|"
echo "         ULTIMATE EDITION          "
echo -e "${RESET}"
}

if [ -z "$DOMAIN" ]; then
    logo
    echo -e "${RED}[!] USO: ./titan_ultimate.sh dominio.com${RESET}"
    exit 1
fi

logo
echo -e "${BLUE}[*] OBJETIVO FIJADO: $DOMAIN${RESET}"
mkdir -p $WORKSPACE
cd $WORKSPACE

# ---------------------------------------------------------
# FASE 1: Enumeración Profunda (Subdominios)
# ---------------------------------------------------------
echo -e "\n${PURPLE}[1] 📡 Iniciando Mapeo de Superficie (Subfinder + Assetfinder)...${RESET}"
# Usamos subfinder con todas las fuentes
subfinder -d $DOMAIN -all -silent | anew subdomains_raw.txt
# Assetfinder como respaldo
assetfinder --subs-only $DOMAIN | anew subdomains_raw.txt

echo -e "${GREEN}[+] Subdominios detectados: $(wc -l < subdomains_raw.txt)${RESET}"

# ---------------------------------------------------------
# FASE 2: Detección de WAF (Firewall Check)
# ---------------------------------------------------------
echo -e "\n${PURPLE}[2] 🛡️ Verificando presencia de WAF (Wafw00f)...${RESET}"
# Checamos el dominio principal para saber a qué nos enfrentamos
wafw00f https://$DOMAIN > waf_result.txt
if grep -q "is behind" waf_result.txt; then
    WAF_NAME=$(cat waf_result.txt | grep "is behind" | awk '{print $NF}')
    echo -e "${RED}[!] ALERTA: WAF DETECTADO ($WAF_NAME). Se recomienda usar proxies.${RESET}"
else
    echo -e "${GREEN}[+] Parece limpio. Sin WAF genérico detectado.${RESET}"
fi

# ---------------------------------------------------------
# FASE 3: Filtrado Web & Puertos (Infrastructure)
# ---------------------------------------------------------
echo -e "\n${PURPLE}[3] 🌐 Filtrando Servicios Vivos (Naabu + HTTPX)...${RESET}"
# Escaneo de puertos rápido para no perder tiempo en hosts muertos
naabu -list subdomains_raw.txt -top-ports 1000 -silent | httpx -silent -title -tech-detect -status-code -follow-redirects -o web_alive.txt

# Limpieza de URLs
cat web_alive.txt | awk '{print $1}' > urls_targets.txt
echo -e "${GREEN}[+] Objetivos HTTP Vivos: $(wc -l < urls_targets.txt)${RESET}"

# ---------------------------------------------------------
# FASE 4: Crawling & Parameter Mining (Lógica Backend)
# ---------------------------------------------------------
echo -e "\n${PURPLE}[4] 🕷️ Crawling Agresivo & Búsqueda de Parámetros (Katana)...${RESET}"
# Katana buscando endpoints ocultos, js y parámetros
katana -list urls_targets.txt -jc -kf -d 3 -silent -o crawling_full.txt

# Extraemos solo las URLs que tienen parámetros (Ej: id=1, user=admin)
# Esto es ORO para SQLi y XSS
cat crawling_full.txt | grep "=" | uro > params_vulnerable.txt
echo -e "${GREEN}[+] Endpoints con parámetros (Potencial SQLi/XSS): $(wc -l < params_vulnerable.txt)${RESET}"

# ---------------------------------------------------------
# FASE 5: Búsqueda de Secretos & Fugas (Exposures)
# ---------------------------------------------------------
echo -e "\n${PURPLE}[5] 🔑 Buscando Fugas de Información (.env, git, keys)...${RESET}"
# Buscamos archivos de configuración expuestos, git expuesto, y tokens en JS
nuclei -l urls_targets.txt -t http/exposures/ -t http/misconfiguration/ -severity low,medium,high,critical -o secrets_leaked.txt

# ---------------------------------------------------------
# FASE 6: Escaneo de CVEs Conocidos (Vulnerabilities)
# ---------------------------------------------------------
echo -e "\n${RED}[6] ☢️  INICIANDO ESCANEO DE VULNERABILIDADES (CVEs)...${RESET}"
echo -e "${YELLOW}[!] Esto puede tardar. Buscando fallos conocidos en las tecnologías detectadas.${RESET}"

# Nuclei buscando SOLO CVEs críticos y conocidos
nuclei -l urls_targets.txt -tags cve,critical,high,rce,lfi,ssrf -etags dos -o cve_results.txt

# ---------------------------------------------------------
# FASE 7: Fuzzing de Archivos Sensibles (Backup Files)
# ---------------------------------------------------------
echo -e "\n${PURPLE}[7] 🗑️ Buscando Archivos de Respaldo y Basura (Fuzzing)...${RESET}"
# Buscamos cosas como database.sql, backup.zip, id_rsa
nuclei -l urls_targets.txt -t http/files/ -severity medium,high,critical -o backup_files.txt

# ---------------------------------------------------------
# FIN
# ---------------------------------------------------------
echo -e "\n${CYAN}[!] RECONOCIMIENTO TITAN FINALIZADO.${RESET}"
echo -e "${BLUE}📁 Reporte guardado en: $(pwd)${RESET}"
echo -e "  [!] Vulnerabilidades Críticas (CVEs): cve_results.txt"
echo -e "  [!] Secretos y Fugas: secrets_leaked.txt"
echo -e "  [!] Endpoints con Parámetros: params_vulnerable.txt"