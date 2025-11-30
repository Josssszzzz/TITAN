# 🪐 PROJECT TITAN: ULTIMATE RECON PIPELINE `[v1.0]`

<!-- EFECTO DE ESCRITURA TIPO TERMINAL (ANIMACIÓN) -->
<p align="center">
  <img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&weight=600&size=25&pause=1000&color=00FF00&center=true&vCenter=true&width=600&lines=INIT_SYSTEM_KERNEL...;LOADING+OFFENSIVE+MODULES...;TARGET+LOCKED:+RECON_MODE_ON;PROJECT+TITAN+READY." alt="Typing SVG" />
</p>

```text
████████╗██╗████████╗ █████╗ ███╗   ██╗
╚══██╔══╝██║╚══██╔══╝██╔══██╗████╗  ██║
   ██║   ██║   ██║   ███████║██╔██╗ ██║
   ██║   ██║   ██║   ██╔══██║██║╚██╗██║
   ██║   ██║   ██║   ██║  ██║██║ ╚████║
   ╚═╝   ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝
```

> **🔰 CLASSIFICATION:** `OFFENSIVE / RED TEAM`
>
> **👨‍💻 AUTHOR:** `JOSE EDUARDO (BACKEND/SEC)`
>
> **🔋 STATUS:** ![Active](https://img.shields.io/badge/SYSTEM-OPERATIONAL-brightgreen?style=for-the-badge&logo=linux)

---

## 💀 // SYSTEM KERNEL: SYNOPSIS

**TITAN ULTIMATE** no es un simple escáner. Es una **suite de orquestación ofensiva automatizada**. Diseñada para mapear, filtrar y explotar la superficie de ataque de infraestructuras complejas.

Combina la velocidad de herramientas escritas en **Go** con lógica de filtrado backend para eliminar falsos positivos y enfocarse en vectores de alto impacto:

`[RCE]` `[LFI]` `[SSRF]` `[SECRET LEAKS]`

---

## 🛠️ // ARMORY: LOADOUT

> ⚠️ **SYSTEM REQUIREMENT:** Linux Environment (Kali/Parrot/Ubuntu/VPS) + **Go Language**.

### 🔧 Core Tools (ProjectDiscovery & Tomnomnom)
Instalando dependencias del arsenal...
```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/tomnomnom/anew@latest
```

### 🐍 Python Support Modules
```bash
pip3 install wafw00f uro
```

---

## 🚀 // DEPLOYMENT PROTOCOL

**1. Asignar Permisos de Ejecución:**
```bash
chmod +x titan.sh
```

**2. Iniciar Secuencia de Ataque:**
```bash
./titan.sh target.com
```

> **⛔ WARNING // OPSEC ALERT**
> Este pipeline genera un **volumen masivo de tráfico**.
> *   ❌ **NO EJECUTAR** desde redes domésticas.
> *   ✅ **REQUERIDO:** VPS Desechable (DigitalOcean/Linode) o Proxy Rotation.

---

## ⛓️ // KILL CHAIN: EXECUTION PHASES

El script ejecuta **7 fases secuenciales** de compromiso:

### `[PHASE 1]` 📡 SURFACE MAPPING
*   **Tools:** `subfinder`, `assetfinder`
*   **Mission:** Enumeración pasiva masiva.
*   **Target:** Encontrar todos los subdominios vinculados a la raíz.

### `[PHASE 2]` 🛡️ DEFENSE ID (WAF Detection)
*   **Tools:** `wafw00f`
*   **Mission:** Identificar contramedidas (Cloudflare, Akamai, AWS Shield).
*   **Intel:** Si `WAF_DETECTED == TRUE`, ajustar rate-limits manualmente.

### `[PHASE 3]` 🔌 INFRASTRUCTURE PROBING
*   **Tools:** `naabu`, `httpx`
*   **Mission:**
    1.  Escaneo rápido de **Top 1000 puertos** + Bases de datos.
    2.  Filtrado de servicios HTTP vivos.
    3.  Purga de hosts muertos (Time Optimization).

### `[PHASE 4]` 🕷️ DEEP CRAWLING
*   **Tools:** `katana`, `uro`, `grep`
*   **Mission:** Navegación *headless* activa.
    *   ⛏️ Extracción de URLs profundas.
    *   💉 Identificación de vectores GET (`?id=`, `?redirect=`) para SQLi/XSS.
    *   🧹 Filtrado de ruido con `uro`.

### `[PHASE 5]` 💎 SECRET HUNTING
*   **Tools:** `nuclei` (tags: `exposure`, `token`, `key`)
*   **Mission:** Escaneo forense en `.js`, `.env` y directorios `.git`.
*   **Loot:** AWS Keys, Stripe Tokens, Hardcoded Credentials.

### `[PHASE 6]` ☢️ VULNERABILITY ASSESMENT
*   **Tools:** `nuclei` (Critical/High templates)
*   **Mission:** **FUEGO PESADO.** Búsqueda de CVEs conocidos y RCEs.
*   **Filters:** `cve`, `critical`, `rce`, `lfi`, `ssrf`.

### `[PHASE 7]` 🗑️ ARTIFACT FUZZING
*   **Tools:** `nuclei` (fuzzing templates)
*   **Mission:** Encontrar residuos de SysAdmins.
*   **Targets:** `backup.zip`, `database.sql`, `dump.tar.gz`.

---

## 💾 // INTEL OUTPUTS (LOOT)

Todos los resultados se exfiltran a la carpeta: `titan_target_FECHA/`

| ARCHIVO | PRIORIDAD | CONTENIDO / VALOR ESTRATÉGICO |
| :--- | :---: | :--- |
| `secrets_leaked.txt` | 🚨 **P1** | Claves, tokens y fugas de información. |
| `cve_results.txt` | ☢️ **P1** | Vulnerabilidades críticas confirmadas. |
| `params_vulnerable.txt` | 💉 **P2** | URLs listas para inyectar (SQLmap/Manual). |
| `backup_files.txt` | 📦 **P2** | Archivos sensibles (Backups, Logs). |
| `subdomains_raw.txt` | ℹ️ **P3** | Lista cruda de subdominios. |
| `web_alive.txt` | ℹ️ **P3** | Servidores HTTP respondiendo (Title/Tech). |
| `crawling_full.txt` | 🗺️ **P3** | Mapa completo del sitio. |

---

## ⚠️ // OPERATIONAL NOTES

*   **Rate Limiting:** Si el WAF bloquea la IP, modificar el script agregando `-rate-limit 100` a `httpx` y `nuclei`.
*   **Falsos Positivos:** Nuclei es preciso, pero **siempre verificar manualmente** (*manual verification*) antes de reportar.
*   **Scope:** Respetar siempre el alcance del programa de Bug Bounty. **No atacar dominios fuera de scope.**

> **SYSTEM HALTED.**
> `END OF FILE`