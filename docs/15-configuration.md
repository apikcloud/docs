<!--
© 2025 Apik — All rights reserved.
Licensed under CC BY-NC-ND 4.0 International.
https://creativecommons.org/licenses/by-nc-nd/4.0/

File: 15-configuration
Project: aikcloud/docs
Last update: 2025-12-08
Status: Stable
Reviewer: royaurelien
-->

# Odoo Configuration

## General concepts

In production, Odoo must run in multi-process mode (`workers > 0`). The threaded mode (`workers = 0`) is only intended for development or very light usage.

Memory and time limits apply **per worker**, and each worker is an isolated process. Therefore, sizing mainly depends on the available RAM.
If `workers × limit_memory_hard` exceeds the physical RAM, the system may start swapping, slow down abruptly, or kill processes.

Recycling mechanisms (`limit_request`, memory/time limits) help keep workers clean, prevent memory leaks, and stop long-running processes from blocking the application.

Memory limits are expressed in bytes. Time limits are in seconds.

> For the rest of the documentation:  
> MiB = bytes / (1024 × 1024)  
> bytes = MiB × (1024 × 1024)  

---

## Key Parameters (odoo.conf)

<!-- | Parameter             | Description                                                                  |
| --------------------- | ---------------------------------------------------------------------------- |
| **workers** | Number of HTTP processes dedicated to requests. |
| **limit_memory_soft** | Memory threshold at which a worker finishes its request and is then recycled. |
| **limit_memory_hard** | Maximum memory threshold. If reached, the worker is killed immediately. |
| **limit_request** | Maximum number of requests before automatic recycling (default: 65536). |
| **limit_time_cpu** | Maximum CPU time allowed per request (default: 60s). |
| **limit_time_real** | Maximum real time allowed per request (default: 120s). |
| **max_cron_threads** | Number of cron threads/processes (default: 2). |
| **limit_time_real_cron** | Maximum real time per cron task (default: limit_time_real). Set to 0 for no limit. |
| **limit_time_worker_cron** | Maximum duration a cron thread/process remains active before being restarted. Set to 0 to disable. (default: 0) | -->


- **workers** : Number of HTTP processes dedicated to requests. 
- **limit_memory_soft** : Memory threshold at which a worker finishes its request and is then recycled. 
- **limit_memory_hard** : Maximum memory threshold. If reached, the worker is killed immediately. 
- **limit_request** : Maximum number of requests before automatic recycling (default: 65536). 
- **limit_time_cpu** : Maximum CPU time allowed per request (default: 60s). 
- **limit_time_real** : Maximum real time allowed per request (default: 120s). 
- **max_cron_threads** : Number of cron threads/processes (default: 2). 
- **limit_time_real_cron** : Maximum real time per cron task (default: limit_time_real). Set to 0 for no limit. 
- **limit_time_worker_cron** : Maximum duration a cron thread/process remains active before being restarted. Set to 0 to disable. (default: 0) 


---

## Role of limits

- **Soft vs hard** : the soft limit allows the request to finish cleanly, while the hard limit acts as a circuit breaker to prevent memory overflow. A soft limit set too high makes the hard limit ineffective, just as a too small delta can interrupt legitimate requests.
- **Recycling via limit_request** : useful for progressive memory leaks (leaks, third-party module behaviors, heavy reports). The worker restarts cleanly.  
- **Time limits** : they stop abnormally long requests (heavy PDF generation, massive file imports, complex processing) before they paralyze the workers, but must be sufficient for legitimate operations.
---

## Configuration examples

> For the initial sizing of workers, refer to the official documentation: [Worker number calculation](https://www.odoo.com/documentation/18.0/administration/on_premise/deploy.html#worker-number-calculation)  

### Small database / moderate load
```ini
workers = 2
limit_memory_soft = 629145600 # 600M
limit_memory_hard = 1677721600 # 1600M
limit_request = 8192
limit_time_cpu = 600 # 10m
limit_time_real = 1200 # 20m
max_cron_threads = 1
```

**Context**: few users, light processing. The soft limit at 600M maintains a memory budget consistent with default values, the hard limit at 1600M absorbs peaks.

### Heavier database / intensive use

```ini
workers = 4
limit_memory_soft = 1073741824 # 1024M
limit_memory_hard = 2147483648 # 2048M
limit_request = 8192
limit_time_cpu = 600 # 10m
limit_time_real = 1200 # 20m
max_cron_threads = 2
```

**Context**: many users, frequent reports, heavy processing. More workers to better distribute the load and more memory margin.

**Warning**: always ensure that `workers × limit_memory_hard` + PostgreSQL + OS fit within the available RAM.

---

## Recommended method: empirical approach
1. Select a simple initial configuration based on the profile (small database / heavy database).
2. Put into production, activate minimal monitoring: RAM, CPU, response times, recycling cycles, errors.
3. Gradually adjust the parameters, for example:
   - If RAM is saturated: reduce `workers` or `limit_memory_hard`.
   - If response times are long or timeout errors appear: increase `workers` or time limits.
   - If workers are frequently killed: increase `limit_memory_soft` and `limit_memory_hard`. 

---

## Practical advice
* Dimension RAM first, CPU comes after.
* Monitor reports, exports, imports: these are the main memory consumers.
* Tuning is only possible with a minimum of logs and metrics.
* Never push memory limits to the maximum of the machine: leave margin for PostgreSQL and the OS.

---

## Conclusion

Odoo configuration relies on a balance: available resources, volume, user behaviors, and installed modules. Start with a simple configuration, then refine with monitoring. This progressive approach ensures robustness and stability over time.
